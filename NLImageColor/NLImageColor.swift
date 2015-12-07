//
//  NLImageColor.swift
//  NLImageColor
//
//  Created by Nobel on 15/11/3.
//  Copyright © 2015年 Nobel. All rights reserved.
//

import UIKit

extension UIImage {
    
    func averageColor() -> UIColor {
        var bitmap = [UInt8](count: 4, repeatedValue: 0)
        let smallImage = resizeImage(self, targetSize: CGSizeMake(20, 20))
        if #available(iOS 9.0, *) {
            // Get average color.
            let context = CIContext()
            let inputImage = smallImage.CIImage ?? CoreImage.CIImage(CGImage: smallImage.CGImage!)
            let extent = inputImage.extent
            let inputExtent = CIVector(x: extent.origin.x, y: extent.origin.y, z: extent.size.width, w: extent.size.height)
            let filter = CIFilter(name: "CIAreaAverage", withInputParameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: inputExtent])!
            let outputImage = filter.outputImage!
            let outputExtent = outputImage.extent
            assert(outputExtent.size.width == 1 && outputExtent.size.height == 1)

            // Render to bitmap.
            context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: kCIFormatRGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())
        } else {
            // Create 1x1 context that interpolates pixels when drawing to it.
            let context = CGBitmapContextCreate(&bitmap, 1, 1, 8, 4, CGColorSpaceCreateDeviceRGB(), CGBitmapInfo.ByteOrderDefault.rawValue | CGImageAlphaInfo.PremultipliedLast.rawValue)!
            let inputImage = smallImage.CGImage ?? CIContext().createCGImage(smallImage.CIImage!, fromRect: smallImage.CIImage!.extent)

            // Render to bitmap.
            CGContextDrawImage(context, CGRect(x: 0, y: 0, width: 1, height: 1), inputImage)
        }

        // Compute result.
        let result = UIColor(red: CGFloat(bitmap[0]) / 255.0, green: CGFloat(bitmap[1]) / 255.0, blue: CGFloat(bitmap[2]) / 255.0, alpha: CGFloat(bitmap[3]) / 255.0)
        return result
    }
    
    func edgeColor() -> UIColor {
        return getMostColors(true)
    }
    
    func mostColor() -> UIColor {
        return getMostColors(false)
    }
    
    func getMostColors(forEdge:Bool) -> UIColor {
        let smallImage = resizeImage(self, targetSize: CGSizeMake(40, 40))
        let edgeWidth = 5
        let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(smallImage.CGImage))
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let colors = NSCountedSet(capacity:Int(smallImage.size.width * smallImage.size.height))
        for x in 0...Int(smallImage.size.width) {
            for y in 0...Int(smallImage.size.height) {
                let pixelInfo: Int = ((Int(smallImage.size.width) * y) + x) * 4
                let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
                let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
                let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
                let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
                if (x > edgeWidth && (x + edgeWidth) < Int(smallImage.size.width)) && (y > edgeWidth && (y + edgeWidth) < Int(smallImage.size.height)) && forEdge{
                    continue
                }
                colors.addObject(UIColor(red: b, green: g, blue: r, alpha: a))
            }
        }
        let enumerator =  colors.objectEnumerator()
        var mostColor = UIColor()
        var MaxCount = 0
        while let currrentColor = enumerator.nextObject() {
            let tmpCount =  colors.countForObject(currrentColor)
            if tmpCount > MaxCount {
                MaxCount = tmpCount
                mostColor = currrentColor as! UIColor
            }
        }
        return mostColor
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(targetSize, hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: targetSize))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext() // !!!
        return scaledImage
    }
}

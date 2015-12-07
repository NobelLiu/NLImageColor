//
//  ViewController.swift
//  NLImageColor
//
//  Created by Nobel on 15/11/3.
//  Copyright © 2015年 Nobel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var segment: UISegmentedControl!
    var index = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        button.setImage(UIImage(named: "IMG_0513.JPG"), forState: UIControlState.Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func changePicture(sender: AnyObject) {
        switch index{
            case 0:button.setImage(UIImage(named: "IMG_0513.JPG"), forState: UIControlState.Normal)
            index = 1
            case 1:button.setImage(UIImage(named: "IMG_0514.JPG"), forState: UIControlState.Normal)
            index = 2
            case 2:button.setImage(UIImage(named: "IMG_0515.JPG"), forState: UIControlState.Normal)
            index = 3
            case 3:button.setImage(UIImage(named: "IMG_0516.JPG"), forState: UIControlState.Normal)
            index = 4
            case 4:button.setImage(UIImage(named: "bw.jpg"), forState: UIControlState.Normal)
            index = 0
            default:break
        }
        exchange(segment)
    }

    @IBAction func exchange(sender: AnyObject) {
        switch segment.selectedSegmentIndex{
        case 0:view.backgroundColor = button.imageView?.image?.averageColor()
        case 1:view.backgroundColor = button.imageView?.image?.mostColor()
        case 2:view.backgroundColor = button.imageView?.image?.edgeColor()
        default:break
        }
    }
}


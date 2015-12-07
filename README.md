# NLImageColor
Pick the color in an image via Swift.
![](https://raw.githubusercontent.com/NobelLiu/NLImageColor/master/Screen Shot.png) 
## Description
Resize image to 40 * 40, use CIAreaAverage to get average color, count all or just 5px border of the resize image and get the most.
## Usage
Drag `NLImageColor.swift` into your project.
Use
```
UIImage().averageColor()   
UIImage().mostColor()   
UIImage().edgeColor()   
```
to get the function of the corresponding.
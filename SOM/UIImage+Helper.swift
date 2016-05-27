//
//  UIImage+Helper.swift
//  SOM
//
//  Created by Kevin Ayuque on 26/05/16.
//  Copyright © 2016 Kevin Ayuque. All rights reserved.
//

import Foundation
import UIKit

extension UIImage{
    func resize(dimension:Int) -> UIImage{
        
        UIGraphicsBeginImageContext(CGSizeMake(CGFloat(dimension), CGFloat(dimension)))
        self.drawInRect(CGRectMake(0, 0, CGFloat(dimension), CGFloat(dimension)))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func rgbData() -> [[Double]]{
        
        let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage))
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        var imageRGB:[[Double]] = [[]]
        imageRGB.removeFirst()
        for i in 0...Int(self.size.height)-1{
            for j in 0...Int(self.size.width)-1{
                let pixelInfo: Int = ((Int(self.size.width) * Int(i)) + Int(j)) * 4
                print(pixelInfo)
                let r:Double = Double(data[pixelInfo]) / 255
                let g:Double = Double(data[pixelInfo+1]) / 255
                let b:Double = Double(data[pixelInfo+2]) / 255
                
                let pixelRGB=[r,g,b]
                imageRGB.append(pixelRGB)
            }
        }
        
        //Bug: Something odd going on with the colors
        return imageRGB
        
    }
}
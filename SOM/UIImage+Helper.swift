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
        
        UIGraphicsBeginImageContext(CGSize(width: CGFloat(dimension), height: CGFloat(dimension)))
        self.draw(in: CGRect(x: 0.0, y: 0.0, width: CGFloat(dimension), height: CGFloat(dimension)))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func rgbData() -> [[Double]]{
        
        let pixelData = CGDataProvider.init(data: self.cgImage!.dataProvider as! CFData)
        //        let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(self.cgImage!)!)
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData as! CFData)
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

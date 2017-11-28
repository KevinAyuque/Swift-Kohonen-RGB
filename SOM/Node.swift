//
//  Node.swift
//  SOM
//
//  Created by Kevin Ayuque on 26/05/16.
//  Copyright © 2016 Kevin Ayuque. All rights reserved.
//

import Foundation

class Node{
    var weight:[Double]!
    var x:Double!
    var y:Double!
    private var left:Int!
    private var top:Int!
    private var bottom:Int!
    private var right:Int!
    

    
    init(left:Int, right:Int, top:Int, bottom:Int, weightN:Int){
    
        weight = [Double](repeating:0.0, count:weightN)
//        weight = [Double(weightN), 0.0]
        self.left = left
        self.right = right
        self.top = top
        self.bottom = bottom
        
        for index in 0...weightN - 1{
            weight [index] = Double(arc4random()) / Double(UInt32.max)
            //weight[index] = drand48() //Drand48 returns same numbers
        }
        
        print(index)
        
        x = Double(left + (right - left)/2)
        y = Double(top  + (bottom - top)/2)
        
    }
    
    func calculateDistance(input:[Double]) -> Double{
        var distance:Double = 0
        
        for i in 0...weight.count - 1{
            distance += (input[i] - weight[i]) * (input[i] - weight[i])
        }
        return sqrt(distance)
    }
    
    func adjustWeights(target:[Double], learningRate:Double, influence:Double){
        for i in 0...target.count - 1{
            weight[i] += learningRate * influence * (target[i] - weight[i])
        }
    }
}

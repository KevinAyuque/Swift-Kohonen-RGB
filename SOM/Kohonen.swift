//
//  Kohonen.swift
//  SOM
//
//  Created by Kevin Ayuque on 26/05/16.
//  Copyright © 2016 Kevin Ayuque. All rights reserved.
//

import Foundation

class Kohonen{
    
    var som:[Node] = []
    var winningNode: Node?
    var winningNodePos: Int = 0
    var mapRadius:Double! = 0
    var randomData:Int = 0
    
    var timeConstant:Double! = 0
    var iterations:Int! = 0
    var iterationCount:Int = 1
    var neighbourhoodRadius:Double! = 0
    var influence:Double! = 0
    var learningRate:Double! = Constants.initialLearningRate
    var done:Bool! = false
    
    //the height and width of the cells that the nodes occupy when rendered into 2D space.
    var cellWidth:Double! = 0
    var cellHeight:Double! = 0
    
    init(xClient:Int, yClient:Int, cellsUp:Int, cellsAcross:Int, iterations:Int){
        
        self.iterations=iterations
        
        cellWidth  = Double(xClient/cellsAcross)
        cellHeight = Double(yClient/cellsUp)
        
        
        //create all the nodes
        
        for i in 0...cellsUp-1{
            for j in 0...cellsAcross-1{
                som.append(Node(left: j*Int(cellWidth), right: (j+1)*Int(cellWidth), top: i*Int(cellHeight), bottom: (i+1)*Int(cellHeight), weightN: Constants.sizeOfInputVector))
            }
        }
        
        //this is the topological 'radius' of the feature map
        mapRadius = Double(max(Constants.windowWidth, Constants.windowHeight)/2)
        timeConstant = Double(self.iterations)/log(mapRadius)
    }
    
    func epoch(data:[[Double]]) -> Bool {
        
        if data[0].count != Constants.sizeOfInputVector {
            return false
        }
        
        if done == true {
            print("Training is complete")
            return true
        }
        
        
        if iterations > 0{
            let thisVector = Int(arc4random_uniform(UInt32(data.count)))
            randomData=thisVector
            winningNode = findBestMatchingNode(vec: data[thisVector])
            neighbourhoodRadius = mapRadius * exp(-(Double(iterationCount)/timeConstant))
            
            for i in 0...som.count-1{
                //Euclidean distance
                let distToNode = pow((winningNode!.x - som[i].x),2) + pow((winningNode!.y - som[i].y),2)
                let widthSq = pow(neighbourhoodRadius,2)
                
                if distToNode < widthSq{
                    influence = exp(-(distToNode/(2*widthSq)))
                    som[i].adjustWeights(target: data[thisVector], learningRate: learningRate, influence: influence)
                }
            }
            
            learningRate = Constants.initialLearningRate * exp(-Double(iterationCount/iterations))
            iterationCount += 1
        }
            
        else {
            done = true
        }
        
        return true
    }
    
    func findBestMatchingNode(vec:[Double])->Node?{
        var winner:Node?
        var lowestDistance = 999999.0
        for i in 0...som.count - 1{
            let dist=som[i].calculateDistance(input: vec)
            if dist < lowestDistance{
                lowestDistance = dist
                winner = som[i]
                winningNodePos=i
            }
        }
        return winner
    }
    
}

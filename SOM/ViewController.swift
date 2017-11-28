//
//  ViewController.swift
//  SOM
//
//  Created by Kevin Ayuque on 26/05/16.
//  Copyright © 2016 Kevin Ayuque. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var data:[[Double]]=[[]]
    var imagePicker: UIImagePickerController!
    var som:Kohonen!
    
    @IBOutlet weak var mapCollectionView: UICollectionView!
    @IBOutlet weak var epochLabel: UILabel!
    @IBOutlet weak var winningNodeLabel: UILabel!
    @IBOutlet weak var neighborhoodRadiusLabel: UILabel!
    @IBOutlet weak var colorImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Kohonen"
        mapCollectionView.delegate = self
        mapCollectionView.dataSource = self
        mapCollectionView.layer.borderColor=UIColor.black.cgColor
        mapCollectionView.layer.borderWidth = 1
        
        som = Kohonen(xClient: Constants.windowWidth, yClient: Constants.windowHeight, cellsUp: Constants.cellsDown, cellsAcross: Constants.cellsAcross, iterations: Constants.iterations)
        createData()

    }
    
    @IBAction func epoch(sender: AnyObject) {
        //print(data)
        if (som.epoch(data: data)) {
            
            epochLabel.text = "Epoch: \(som.iterationCount - 1)"
            let nodeY = som.winningNodePos % Constants.cellsAcross
            let nodeX = som.winningNodePos / Constants.cellsAcross
            winningNodeLabel.text="Winning node: [\(nodeX),\(nodeY)] (\(som.winningNodePos))"
            neighborhoodRadiusLabel.text = "Neighborhood radius: \(som.neighbourhoodRadius)"
            let red = CGFloat(data[som.randomData][0])
            let green = CGFloat(data[som.randomData][1])
            let blue = CGFloat(data[som.randomData][2])
            colorImage.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
            mapCollectionView.reloadData()
            
        }
    }
    
    func train()->Bool{
        if !som.done {
            if !som.epoch(data: data){
                return false
            }
        }
        return true
    }
    @IBAction func refresh(sender: AnyObject) {
        createData()
        som = Kohonen(xClient: Constants.windowWidth, yClient: Constants.windowHeight, cellsUp: Constants.cellsDown, cellsAcross: Constants.cellsAcross, iterations: Constants.iterations)
        mapCollectionView.reloadData()
    }
    
    @IBAction func takePic(sender: AnyObject) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        let resizedImage = image?.resize(dimension: 40)
        let imageRGB=resizedImage?.rgbData()
        data = imageRGB!
        som = Kohonen(xClient: Constants.windowWidth, yClient: Constants.windowHeight, cellsUp: Constants.cellsDown, cellsAcross: Constants.cellsAcross, iterations: Constants.iterations)
        mapCollectionView.reloadData()

    }
    
    
    func createData(){
        let green:[Double] = [0,1,0]
        let red:[Double] = [1,0,0]
        let dk_green:[Double] = [0,0.5,0.25]
        let blue:[Double] = [0,0,0.5]
        let dk_blue:[Double] = [0,0,0.5]
        let yellow:[Double] = [1,1,0.2]
        let orange:[Double] = [1,0.4,0.25]
        let purple:[Double] = [1,0,1]
        data.removeAll()
        //data.removeFirst()
        data.append(green)
        data.append(red)
        data.append(dk_green)
        data.append(blue)
        data.append(dk_blue)
        data.append(yellow)
        data.append(orange)
        data.append(purple)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.cellsAcross * Constants.cellsDown
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return Constants.cellsDown
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = mapCollectionView.dequeueReusableCell(withReuseIdentifier: "pixel", for: indexPath as IndexPath)
        cell.layer.borderColor=UIColor.black.cgColor
        cell.layer.borderWidth = 0.5
        if som != nil{
            let location = indexPath.section * Constants.cellsAcross + indexPath.row
            let red = CGFloat(som.som[location].weight[0])
            let green = CGFloat(som.som[location].weight[1])
            let blue = CGFloat(som.som[location].weight[2])
            cell.backgroundColor=UIColor(red: red, green: green, blue: blue, alpha: 1)
        }else{
            cell.backgroundColor=UIColor.white
        }
        return cell
    }
    
    
    func collectionView(_ collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAt indexPath:IndexPath) -> CGSize
    {
        var cellWidth:CGFloat!
        var cellHeight:CGFloat!
        
        cellWidth = self.mapCollectionView.frame.width / CGFloat(Constants.cellsAcross)
        cellHeight = self.mapCollectionView.frame.width / CGFloat(Constants.cellsDown)
        let cellSize:  CGSize = CGSize(width: cellWidth, height: cellHeight)
        return cellSize
    }



}


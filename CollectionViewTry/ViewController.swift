//
//  ViewController.swift
//  CollectionViewTry
//
//  Created by JOEL CRAWFORD on 2/14/20.
//  Copyright © 2020 JOEL CRAWFORD. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    //================Data=================
    var colectionArr : [String] = ["1","2","3","4"]
    let titlesF = [("Apple"),("Apricot"),("Banana"),("Grapes"),("Kiwi"),("Orange"),("Peach")]
    let desF = [("An apple is a sweet, edible fruit produced by an apple tree."),
                ("An apricot is a fruit, or the tree that bears the fruit, of several species in the genus Prunus (stone fruits)."),
                ("A banana is an edible fruit – botanically a berry – produced by several kinds of large herbaceous flowering plants in the genus Musa."),
                ("A grape is a fruit, botanically a berry, of the deciduous woody vines of the flowering plant genus Vitis."),
                ("Kiwifruit, or Chinese gooseberry is the edible berry of several species of woody vines in the genus Actinidia."),
                ("The orange is the fruit of the citrus species Citrus × sinensis in the family Rutaceae. "),
                ("A peach is a soft, juicy and fleshy stone fruit produced by a peach tree.")]
    let imagesF = [UIImage(named: "apple"),
                   UIImage(named: "apricot"),
                   UIImage(named: "banana"),
                   UIImage(named: "grapes"),
                   UIImage(named: "kiwi"),
                   UIImage(named: "orange"),
                   UIImage(named: "peach")]
    
    
    
    //==========================================================
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //=====delegates====
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return titlesF.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        
        
        //let thisElement = colectionArr[indexPath.item]
        
        //let closeFrameSize = bestFrameSize()
        let cellIndex = indexPath.item
        
        cell.categoryimageView.image = imagesF[cellIndex]
        
        cell.categorylabel.text = titlesF[cellIndex]
        
        
        cell.contentView.layer.cornerRadius = 5
               cell.contentView.layer.borderWidth = 1.0
               
               
               cell.contentView.layer.borderColor = UIColor.blue.cgColor
               cell.contentView.layer.masksToBounds = true
               cell.backgroundColor = UIColor.white

               cell.layer.shadowColor = UIColor.gray.cgColor
              cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
               cell.layer.shadowRadius = 2.0
               cell.layer.shadowOpacity = 1.0
               cell.layer.masksToBounds = false
              
        
        return cell
        
        
    }
    
//    func bestFrameSize() -> CGFloat {
//           let frameHeight = self.view.frame.height
//           let frameWidth = self.view.frame.width
//           let bestFrameSize = (frameHeight > frameWidth ) ? frameHeight : frameWidth
//           
//           return bestFrameSize
//       }
    
}





// extention for UICollectionViewDelegateFlowLayout
extension ViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let heightVal = self.view.frame.height
        let widthVal = self.view.frame.width
        let cellsize = (heightVal < widthVal) ?  bounds.height/2 : bounds.width/2
        
        return CGSize(width: cellsize - 10   , height:  cellsize - 10  ) //-10 becacuse of 5 + 5 top/bottom for the height
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}//end of extension  ViewController

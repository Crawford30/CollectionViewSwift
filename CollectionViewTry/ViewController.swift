//
//  ViewController.swift
//  CollectionViewTry
//
//  Created by JOEL CRAWFORD on 2/14/20.
//  Copyright © 2020 JOEL CRAWFORD. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var collectionData:[AnyObject]!
    var task: URLSessionDownloadTask!
    var session: URLSession!
    var cache:NSCache<AnyObject, AnyObject>!
    
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷
    
    @IBOutlet weak var fakeTabBar: UIButton!
    
    let myCellSize: CGSize = CGSize( width: 148, height: 164) // Got these from the cell on the storyboard
    
    let mySpacing: CGFloat = CGFloat( 8.0 )
    
    //🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷
    
    //================Data=================
    //    var colectionArr : [String] = ["1","2","3","4"]
    //    let titlesF = [("Apple"),("Apricot"),("Banana"),("Grapes"),("Kiwi"),("Orange"),("Peach")]
    //    let desF = [("An apple is a sweet, edible fruit produced by an apple tree."),
    //                ("An apricot is a fruit, or the tree that bears the fruit, of several species in the genus Prunus (stone fruits)."),
    //                ("A banana is an edible fruit – botanically a berry – produced by several kinds of large herbaceous flowering plants in the genus Musa."),
    //                ("A grape is a fruit, botanically a berry, of the deciduous woody vines of the flowering plant genus Vitis."),
    //                ("Kiwifruit, or Chinese gooseberry is the edible berry of several species of woody vines in the genus Actinidia."),
    //                ("The orange is the fruit of the citrus species Citrus × sinensis in the family Rutaceae. "),
    //                ("A peach is a soft, juicy and fleshy stone fruit produced by a peach tree.")]
    //
    //    let imagesF = [UIImage(named: "apple"),
    //                   UIImage(named: "apricot"),
    //                   UIImage(named: "banana"),
    //                   UIImage(named: "grapes"),
    //                   UIImage(named: "kiwi"),
    //                   UIImage(named: "orange"),
    //                   UIImage(named: "peach")]
    
    
    
    
    
    //==========================================================
    
    // multiple number to creat font size based on device screen size
    let relativeFontWelcomeTitle:CGFloat = 0.045
    let relativeFontButton:CGFloat = 0.060
    let relativeFontCellTitle:CGFloat = 0.023
    let relativeFontCellDescription:CGFloat = 0.015
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadImage()
        session = URLSession.shared
        task = URLSessionDownloadTask()
        
      //=======array of of data===========
        self.collectionData = []
        self.cache = NSCache()
        
        //=====delegates====
        collectionView.delegate   = self
        collectionView.dataSource = self
        
        var tempRect: CGRect = collectionView.frame
        
        tempRect.origin.y    = 80 // Put below nav bar
        
        tempRect.size.width  = ( myCellSize.width * 2 ) + ( mySpacing * 3 )
        
        tempRect.size.height = ( fakeTabBar.frame.origin.y - tempRect.origin.y ) - 8
        
        // fakeTabBar.frame.origin.y - tempRect.origin.y puttin bottom of collection view ontop of the tabbed button
        
        // All typecasting below is ugly.... but Xcode accepts it
        tempRect.origin.x    = CGFloat( roundf( Float( ( self.view.frame.size.width - tempRect.size.width ) / 2.0) ) ) //centers the collection view horizonatlly
        
        collectionView.frame = tempRect
        
    }
    
    
    /////=========================https://sweettutos.com/2015/12/31/swift-how-to-asynchronously-download-and-cache-images-without-relying-on-third-party-libraries/   ==============    USING THIS LINK TO FOLLOW ALONG
    
    
    @objc func loadImage(){
        let url:URL! = URL(string: "https://ichuzz2work.com/api/services/categories")
        task = session.downloadTask(with: url, completionHandler: { (location: URL?, response: URLResponse?, error: Error?) -> Void in
            
            if location != nil{
                let data:Data! = try? Data(contentsOf: location!)
                do{
                    let dic = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
                    self.collectionData = dic.value(forKey : "data") as? [AnyObject]
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.collectionView.reloadData()
                        
                    })
                }catch{
                    print("something went wrong, try again")
                }
            }
        })
        task.resume()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.collectionData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        let dictionary = self.collectionData[(indexPath as NSIndexPath).row] as! [String:AnyObject]
        cell.categorylabel.text = dictionary["name"] as? String
        cell.categoryimageView.image = UIImage(named: "placeholder")
        
        
        if (self.cache.object(forKey: (indexPath as NSIndexPath).item as AnyObject) != nil){
            // 2
            // Use cache
            print("Cached image used, no need to download it")
            cell.categoryimageView?.image = self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage
        } else {
            
            let categoryImageUrl = dictionary["image"] as! String
            let url:URL! = URL(string: categoryImageUrl)
            task = session.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                if let data = try? Data(contentsOf: url){
                    // 4
                    DispatchQueue.main.async(execute: { () -> Void in
                        // 5
                        // Before we assign the image, check whether the current cell is visible
                        if let updateCell = collectionView.cellForItem(at: indexPath) {
                            let img:UIImage! = UIImage(data: data)
                           // updateCell.categoryimageView.image = img   =======gives an error
                            self.cache.setObject(img, forKey: (indexPath as NSIndexPath).row as AnyObject)
                        }
                        
                        
                    })
                }
            })
            task.resume()
        }
        

        
        cell.contentView.layer.cornerRadius = 10
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // In this function is the code you must implement to your code project if you want to change size of Collection view
        return myCellSize
        
    }
    
    func bestFrameSize() -> CGFloat {
        
        let frameHeight   = self.view.frame.height
        let frameWidth    = self.view.frame.width
        let bestFrameSize = (frameHeight > frameWidth ) ? frameHeight : frameWidth
        
        return bestFrameSize
        
    }
    
}


// extention for UICollectionViewDelegateFlowLayout
extension ViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: mySpacing, left: mySpacing, bottom: mySpacing, right: mySpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return mySpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return mySpacing
    }
    
}//end of extension  ViewController



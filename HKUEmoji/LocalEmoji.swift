//
//  LocalEmoji.swift
//  HKUEmoji
//
//  Created by huhao on 12/10/15.
//  Copyright © 2015 huhao. All rights reserved.
//

import UIKit

class localEmojiCtrl : UIViewController,UICollectionViewDelegate,UICollectionViewDataSource
{
    let images = [
        ["pic":"cut"],
        ["pic":"eye"],
        ["pic":"mouth"]
    ]
    
    @IBOutlet var imageCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //imageCollection.backgroundColor = UIColor.whiteColor()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    // CollectionView行数
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return images.count;
    }
    
    
func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("defaultCell", forIndexPath: indexPath) as! localImageCell
        cell.imageView.image=UIImage(named: images[indexPath.item]["pic"]!)
        cell.imageView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 03).CGColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        return cell
    
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
       /* if let tabItem = BackgroundChoice.init(rawValue: backgroundChoice.rawValue){
        switch tabItem{
    case .trueEmoji:
        selectedItem = self.trueEmojiBackground[indexPath.item]
    default:
        selectedItem = self.cartoonEmojiBackground[indexPath.item]
        }
        }
        let vcs = self.navigationController!.viewControllers
        let stgii = vcs[vcs.count - 2] as! StaticEmojiGenII
        stgii.currentImage = selectedItem!
        self.navigationController!.popViewControllerAnimated(true)*/
    }
    


}
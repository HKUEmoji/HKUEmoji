//
//  LocalEmoji.swift
//  HKUEmoji
//
//  Created by huhao on 12/10/15.
//  Copyright © 2015 huhao. All rights reserved.
//

import UIKit
import Photos
import AssetsLibrary

class localEmojiCtrl : UIViewController,UICollectionViewDelegate,UICollectionViewDataSource
{
    var images = [
        UIImage(named: "cut"),
        UIImage(named: "eye"),
        UIImage(named: "mouth")
        ]
    
    let imageGroup :PHAssetCollection = CustomPhotoAlbum.sharedInstance.assetCollection
    @IBOutlet var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.backgroundColor = UIColor.whiteColor()
        let album = CustomPhotoAlbum.sharedInstance.assetCollection
        let fetchOption = PHFetchOptions()
        let collection = PHAsset.fetchAssetsInAssetCollection(album,options:fetchOption)
        let imageManager = PHCachingImageManager()
        for(var i=0;i<collection.count;i++){
            let imageC = collection[i]
            let imageOption = PHImageRequestOptions()
            imageManager.requestImageForAsset(imageC as! PHAsset, targetSize: PHImageManagerMaximumSize, contentMode:  PHImageContentMode.AspectFit, options: imageOption, resultHandler: { (result, info) -> Void in
                self.images.append(result!)
            self.collectionView.reloadData()
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)

    }
    
    
    // CollectionView行数
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return images.count;
    }
    
    
func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("defaultCell", forIndexPath: indexPath) as! localImageCell
        cell.imageView.image=images[indexPath.item]!
        cell.imageView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 03).CGColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        return cell
    
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let image = self.images[indexPath.item]
        let shareParames = NSMutableDictionary()
        shareParames.SSDKSetupShareParamsByText("Share contents",
            images : image,
            url : NSURL(string:"http://mob.com"),
            title : "分享标题",
            type : SSDKContentType.Auto)
        
        ShareSDK.showShareActionSheet(self.view, items: nil, shareParams: shareParames, onShareStateChanged: nil)
    }
}
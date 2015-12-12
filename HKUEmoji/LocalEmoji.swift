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
        imageCollection.backgroundColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // CollectionView行数
     func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            return images.count;
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            // storyboard里设计的单元格
            let identify:String = "defaultCell"
            // 获取设计的单元格，不需要再动态添加界面元素
            let cell = (imageCollection.dequeueReusableCellWithReuseIdentifier(
                identify, forIndexPath: indexPath)) as UICollectionViewCell
            // 从界面查找到控件元素并设置属性
            (cell.contentView.viewWithTag(0) as! UIImageView).image =
                UIImage(named: images[indexPath.item]["pic"]!)
            return cell
    }
    
 
    
    //实现UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        //某个Cell被选择的事件处理
    }
    
    /*
    func saveOrShare() {
        if let currentImage = backgroundImage {
            UIImageWriteToSavedPhotosAlbum(currentImage, self, "image:didFinishSavingWithError:contextInfo:", nil)
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafePointer<Void>) {
        if error == nil {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
    }*/

}
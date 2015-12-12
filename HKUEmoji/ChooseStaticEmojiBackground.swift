//
//  ChooseStaticEmojiBackground.swift
//  HKUEmoji
//
//  Created by Wang Youan on 10/12/2015.
//  Copyright © 2015 Wang Youan. All rights reserved.
//

import UIKit

enum BackgroundChoice: Int{
    case trueEmoji = 0
    case cartoonEmoji
}

class ChooseStaticEmojiBackground: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backgroundInfo: UISegmentedControl!
    
    @IBAction func chooseBackgroun(sender: AnyObject) {
        if backgroundInfo.selectedSegmentIndex == 0{
            backgroundChoice = .cartoonEmoji
        } else {
            backgroundChoice = .trueEmoji
        }
    }
    
    var trueEmojiBackground: [String]!
    var cartoonEmojiBackground: [String]!
    var selectedItem: String?
    var backgroundChoice: BackgroundChoice! {
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundInfo.selectedSegmentIndex = 0
        backgroundChoice = .cartoonEmoji
        self.navigationController!.setNavigationBarHidden(false, animated:true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Confirm", style: .Done, target: self, action: "prepareForPopSugue")


    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        super.viewDidDisappear(animated)
    }
    
    func prepareForPopSugue(sender: AnyObject) {
        print("yes")
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let tabItem = BackgroundChoice.init(rawValue: backgroundChoice.rawValue){
            switch tabItem{
            case .cartoonEmoji: return self.cartoonEmojiBackground.count
            default: return self.trueEmojiBackground.count
            }
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("EmojiBackground", forIndexPath: indexPath) as! ChooseStaticEmojiShow
        if let tabItem = BackgroundChoice.init(rawValue: backgroundChoice.rawValue){
            switch tabItem{
            case .cartoonEmoji:
                cell.imageView.image = UIImage(named: self.cartoonEmojiBackground[indexPath.item])
            default:
                cell.imageView.image = UIImage(named: self.trueEmojiBackground[indexPath.item])
            }
        }
        cell.imageView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 03).CGColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let tabItem = BackgroundChoice.init(rawValue: backgroundChoice.rawValue){
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
        self.navigationController!.popViewControllerAnimated(true)
    }
}


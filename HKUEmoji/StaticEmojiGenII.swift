//
//  StaticEmojiGenII.swift
//  HKUEmoji
//
//  Created by Wang Youan on 3/12/2015.
//  Copyright © 2015 Wang Youan. All rights reserved.
//

import UIKit
import ImageIO

class StaticEmojiGenII: UIViewController {
    
    var leftEyeBound: CGRect?
    var rightEyeBound: CGRect?
    var mouthBound: CGRect?
    var faceImage: UIImage?
    
    var currentImage: (String, Int)!
    var trueEmojiNames = ["CP3 2": 0,
                          "CP3": 0,
                          "curry1": 0,]

    lazy var context: CIContext = {
        return CIContext(options: nil)
    } ()
    
    var backgroundImage: UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        currentImage = trueEmojiNames.first!
        backgroundImage = UIImage(named: self.currentImage.0)
        let backgroundbond = faceBoundDetection(backgroundImage!)
        backgroundImage = addFaceToBackGround(backgroundbond, backgroundImage: backgroundImage, faceImage: faceImage!)
        imageView.image = backgroundImage
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "saveOrShare")
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addFaceToBackGround(bound: CGRect, backgroundImage: UIImage, faceImage: UIImage) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(backgroundImage.size, false, 0.0)
        backgroundImage.drawInRect(CGRect(origin: CGPointZero, size: backgroundImage.size))
        faceImage.drawInRect(bound)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func faceBoundDetection(originPic: UIImage) -> CGRect {
        let inputImage = CIImage(image: originPic)
        let detector = CIDetector(ofType: CIDetectorTypeFace, context: context,
            options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        var faceFeatures: [CIFaceFeature]!
        if let orientation: AnyObject = inputImage?.properties[kCGImagePropertyOrientation as String] {
            faceFeatures = detector.featuresInImage(inputImage!,
                options: [CIDetectorImageOrientation: orientation]
                ) as! [CIFaceFeature]
        } else {
            faceFeatures = detector.featuresInImage(inputImage!) as! [CIFaceFeature]
        }
        
        var transform = CGAffineTransformMakeScale(1 / originPic.scale, 1 / originPic.scale)
        var bounds = CGRectApplyAffineTransform(faceFeatures[self.currentImage.1].bounds, transform)
        
        transform = CGAffineTransformMakeScale(1, -1)
        transform = CGAffineTransformTranslate(transform, 0, -originPic.size.height)
        bounds = CGRectApplyAffineTransform(bounds, transform)
        return bounds
    }
    
    func cutOutOriginalFace(originPic: UIImage) -> UIImage? {
        return nil
    }
    
    func saveOrShare() {
        if let currentImage = backgroundImage {
            UIImageWriteToSavedPhotosAlbum(currentImage, self, "image:didFinishSavingWithError:contextInfo:", nil)
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error == nil {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

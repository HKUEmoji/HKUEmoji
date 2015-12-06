//
//  StaticEmojiGen.swift
//  HKUEmoji
//
//  Created by Wang Youan on 30/11/2015.
//  Copyright © 2015 Wang Youan. All rights reserved.
//

import UIKit
import ImageIO
//import GPUImage

class StaticEmojiGen: UIViewController {

    @IBOutlet weak var imageShow: UIImageView!
    @IBOutlet weak var leftEye: UIImageView!
    @IBOutlet weak var rightEye: UIImageView!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var mouth: UIImageView!

    
    lazy var originalImage: UIImage = {
        return UIImage(named: "test.png")
    } ()!
    
    lazy var context: CIContext = {
        return CIContext(options: nil)
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageShow.image = originalImage
        imageShow.userInteractionEnabled = false
        mouth.image = UIImage(named: "mouth")
        mouth.userInteractionEnabled = true
        leftEye.image = UIImage(named: "eye")
        leftEye.userInteractionEnabled = true
        rightEye.image = UIImage(named: "eye")
        rightEye.userInteractionEnabled = true
    }
    
    override func viewDidAppear(animated: Bool) {
//        detecFace()
        super.viewDidAppear(animated)
    }
    
    func detecFace() {
        let inputImage = CIImage(image: originalImage)
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
        
        if let faceFeature = faceFeatures.first as CIFaceFeature! {
//            print(faceFeature.bounds)

            if faceFeature.hasLeftEyePosition {
                leftEye.frame = adjustFaceFeatures(CGRect(origin: faceFeature.leftEyePosition, size: CGSize(width: faceFeature.bounds.size.width * 0.25, height: faceFeature.bounds.size.width * 0.15)))
            }
            
            if faceFeature.hasRightEyePosition {
                rightEye.frame = adjustFaceFeatures(CGRect(origin: faceFeature.rightEyePosition, size: CGSize(width: faceFeature.bounds.size.width * 0.25, height: faceFeature.bounds.size.width * 0.15)))
            }
            
            if faceFeature.hasMouthPosition {
                mouth.frame = adjustFaceFeatures(CGRect(origin: faceFeature.mouthPosition, size: CGSize(width: faceFeature.bounds.size.width * 0.45, height: faceFeature.bounds.size.width * 0.2)))
            }
        }
    }
    
    func adjustFaceFeatures(frameRec: CGRect) -> CGRect {
        let originalImageSize = originalImage.size
        let scale = min(imageShow.bounds.height / originalImageSize.height, imageShow.bounds.width / originalImageSize.width)
        
        var transform = CGAffineTransformMakeScale(1, -1)
        transform = CGAffineTransformTranslate(transform, 0, -originalImageSize.height)
        var newBound = CGRectApplyAffineTransform(frameRec, transform)
        
        newBound.origin.x -= newBound.size.width / 2
        newBound.origin.y += newBound.size.height / 2
        transform = CGAffineTransformMakeScale(scale, scale)
        newBound = CGRectApplyAffineTransform(newBound, transform)
        
        let offsetX = (imageShow.bounds.width - originalImageSize.width * scale) / 2 + imageShow.frame.origin.x + background.frame.origin.x
        let offsetY = (imageShow.bounds.height - originalImageSize.height * scale) / 2 + imageShow.frame.origin.y + background.frame.origin.y
        
        newBound.origin.x += offsetX
        newBound.origin.y += offsetY
//        print("after: \(newBound.size) \(newBound.origin)")
//        print("bounds: \(imageShow.bounds.size) frame: \(imageShow.frame.origin) \(imageShow.frame.size)")
//        imageView.frame = newBound
        return newBound
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showGenerater" {
            let svc = segue.destinationViewController as! StaticEmojiGenII
            if let bound1 = rightEye?.frame {
                svc.rightEyeBound = bound1
            }
            
            if let bound1 = leftEye?.frame {
                svc.leftEyeBound = bound1
            }
            
            if let bound1 = mouth?.frame {
                svc.mouthBound = bound1
            }
            
            svc.faceImage = originalImage
        }
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        let touch = touches.first!
        let location = touch.locationInView(self.view)
        if let node = touch.view {
            if node.tag == 1024 {
                let newLocation = CGPoint(x: location.x, y: location.y)
                node.center = newLocation
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        detecFace()
//        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.hidesBarsOnTap = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        detecFace()
        self.view.sendSubviewToBack(background)
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

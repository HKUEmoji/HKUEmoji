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
    var leftEye: UIImageView!
    var rightEye: UIImageView!
    var mouth: UIImageView!
    let leftEyeTag = 1
    let rightEyeTag = 2
    let mouthTag = 3
    
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
        
//        let stillImageFilter:GPUImageSketchFilter = GPUImageSketchFilter()
        
//        imageShow.image = stillImageFilter.imageByFilteringImage(image)
        detecFace()
//        view.sendSubviewToBack(imageShow)
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

            if faceFeature.hasLeftEyePosition {
                leftEye = UIImageView(frame: CGRect(origin: faceFeature.leftEyePosition, size: CGSize(width: faceFeature.bounds.size.width * 0.25, height: faceFeature.bounds.size.width * 0.15)))
//                leftEye = UIImageView(frame: CGRect(origin: faceFeature.leftEyePosition, size: CGSize(width: 50, height: 50)))
                leftEye.image = UIImage(named: "eye")
                adjustFaceFeatures(leftEye, inputImage: inputImage!)
                imageShow.addSubview(leftEye)
            }
            
            if faceFeature.hasRightEyePosition {
                rightEye = UIImageView(frame: CGRect(origin: faceFeature.rightEyePosition, size: CGSize(width: faceFeature.bounds.size.width * 0.25, height: faceFeature.bounds.size.width * 0.15)))
                
                rightEye.image = UIImage(named: "eye")
                rightEye.tag = rightEyeTag
                adjustFaceFeatures(rightEye, inputImage: inputImage!)
                imageShow.addSubview(rightEye)
            }
            
            if faceFeature.hasMouthPosition {
                mouth = UIImageView(frame: CGRect(origin: faceFeature.mouthPosition, size: CGSize(width: faceFeature.bounds.size.width * 0.45, height: faceFeature.bounds.size.width * 0.2)))

                mouth.image = UIImage(named: "mouth")
                mouth.tag = mouthTag
                adjustFaceFeatures(mouth, inputImage: inputImage!)
                imageShow.addSubview(mouth)
            }
        }
    }
    
    func adjustFaceFeatures(imageView: UIImageView, inputImage: CIImage) {
        var transform = CGAffineTransformIdentity
        transform = CGAffineTransformScale(transform, 1, -1)
        transform = CGAffineTransformTranslate(transform, 0, -imageShow.frame.height)
        let newBound = CGRectApplyAffineTransform(imageView.frame, transform)
//        let offsetY = self.imageShow.frame.origin.y / 2.0
//        newBound.origin.y += offsetY
        imageView.frame = newBound
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
        let touch = touches.first!
        let location = touch.locationInView(self.view)
        if let node = touch.view {
            for view in imageShow.subviews{
                if node == view {
                    let newLocation = CGPoint(x: location.x, y: location.y + imageShow.bounds.size.height / 2 - imageShow.frame.origin.y)
                    node.frame = CGRect(origin: newLocation, size: node.frame.size)
                }
            }
        }
        
        super.touchesMoved(touches, withEvent: event)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

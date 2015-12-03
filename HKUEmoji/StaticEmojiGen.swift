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
        view.sendSubviewToBack(imageShow)
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
        
        let inputImageSize = inputImage?.extent.size
        var transform = CGAffineTransformIdentity
        transform = CGAffineTransformScale(transform, 1, -1)
        transform = CGAffineTransformTranslate(transform, 0, -(inputImageSize?.height)!)
        
        if let faceFeature = faceFeatures.first as CIFaceFeature! {
            
            var faceViewBounds = CGRectApplyAffineTransform(faceFeature.bounds, transform)
            
            // 2.
            let scale = min(imageShow.bounds.size.width / inputImageSize!.width,
                imageShow.bounds.size.height / inputImageSize!.height)
            let offsetX = (imageShow.bounds.size.width - inputImageSize!.width * scale) / 2
            let offsetY = (imageShow.bounds.size.height - inputImageSize!.height * scale) / 2
            
            faceViewBounds = CGRectApplyAffineTransform(faceViewBounds, CGAffineTransformMakeScale(scale, scale))
            faceViewBounds.origin.x += offsetX
            faceViewBounds.origin.y += offsetY

            if faceFeature.hasLeftEyePosition {
                leftEye = UIImageView(frame: CGRect(origin: faceFeature.leftEyePosition, size: CGSize(width: 50, height: 50)))
                leftEye.image = UIImage(named: "eye.png")
                imageShow.addSubview(leftEye)
            }
            
            if faceFeature.hasRightEyePosition {
                rightEye = UIImageView(frame: CGRect(origin: faceFeature.rightEyePosition, size: CGSize(width: 50, height: 50)))
                rightEye.image = UIImage(named: "eye.png")
                imageShow.addSubview(rightEye)
            }
            
            if faceFeature.hasMouthPosition {
                mouth = UIImageView(frame: CGRect(origin: faceFeature.mouthPosition, size: CGSize(width: 50, height: 50)))
                mouth.image = UIImage(named: "mouth.png")
                imageShow.addSubview(mouth)
            }
        }
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

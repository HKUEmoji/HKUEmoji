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

    lazy var context: CIContext = {
        return CIContext(options: nil)
    } ()
    
    @IBOutlet weak var imageView: UIImageView!
    
    lazy var backgroundImage: UIImage = {
        return UIImage(named: "superdad.png")
    } ()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        // Do any additional setup after loading the view.
        imageView.image = backgroundImage
        let backgroundbond = faceBoundDetection(backgroundImage)
        
        let newFace = UIImageView(image: faceImage)
        newFace.frame = adjustFaceBound(backgroundbond, backgroundImage: backgroundImage)
        imageView.addSubview(newFace)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func adjustFaceBound(bound: CGRect, backgroundImage: UIImage) -> CGRect {
        let imageSize = backgroundImage.size
        let imageViewSize = imageView.frame.size
        let scale = imageViewSize.height / imageSize.height
        
        
        var transform = CGAffineTransformIdentity
        transform = CGAffineTransformScale(transform, 1, -1)
        transform = CGAffineTransformTranslate(transform, 0, -imageView.frame.height)
        var newBound = CGRectApplyAffineTransform(bound, transform)

        let offsetX = (imageViewSize.width - imageSize.width * scale) / 2
        let offsetY = (imageViewSize.height - imageSize.height * scale) / 2
        
        newBound = CGRectApplyAffineTransform(newBound, CGAffineTransformMakeScale(scale, scale))
        newBound.origin.x += offsetX
        newBound.origin.y += offsetY

        return newBound
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
        return faceFeatures.first!.bounds
    }
    
    func cutOutOriginalFace(originPic: UIImage) -> UIImage? {
//        let faceBound = faceBoundDetection(originPic)
        
        return nil
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

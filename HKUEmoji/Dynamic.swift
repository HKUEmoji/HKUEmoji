//
//  Dynamic.swift
//  HKUEmoji
//
//  Created by hh on 15/12/7.
//  Copyright © 2015年 Wang Youan. All rights reserved.
//

import UIKit

class Dynamic: UIViewController {


	@IBOutlet weak var gifImage: UIImageView!

	@IBOutlet weak var gifTemplate1: UIImageView!

	@IBOutlet weak var gifTemplate2: UIImageView!
	@IBOutlet weak var gifTemplate3: UIImageView!

    var faceBound = CGRect(x: 196, y: 135, width: 230, height: 230)
    var faceImage = UIImage(named: "test1.png")

	override func viewDidLoad() {
		super.viewDidLoad()

		gifTemplate1.userInteractionEnabled = true
		gifTemplate2.userInteractionEnabled = true
		gifTemplate3.userInteractionEnabled = true

		let tapGR1 = UITapGestureRecognizer(target: self, action: "tapHandler1:")
		gifTemplate1.addGestureRecognizer(tapGR1)

		gifTemplate1.animationImages = NSArray() as? [UIImage] ;
		gifTemplate1.animationImages?.append(UIImage(named: "hou2.png")!) ;
		gifTemplate1.animationImages?.append(UIImage(named: "hou5.png")!) ;

		gifTemplate1.animationDuration = 1
		gifTemplate1.animationRepeatCount = 0
		gifTemplate1.startAnimating()

		let tapGR2 = UITapGestureRecognizer(target: self, action: "tapHandler2:")
		gifTemplate2.addGestureRecognizer(tapGR2)

		gifTemplate2.animationImages = NSArray() as? [UIImage] ;
		gifTemplate2.animationImages?.append(UIImage(named: "hou1.png")!) ;
		gifTemplate2.animationImages?.append(UIImage(named: "hou3.png")!) ;

		gifTemplate2.animationDuration = 1
		gifTemplate2.animationRepeatCount = 0
		gifTemplate2.startAnimating()

		let tapGR3 = UITapGestureRecognizer(target: self, action: "tapHandler3:")
		gifTemplate3.addGestureRecognizer(tapGR3)


		gifTemplate3.animationImages = NSArray() as? [UIImage] ;
		gifTemplate3.animationImages?.append(UIImage(named: "hou4.png")!) ;
		gifTemplate3.animationImages?.append(UIImage(named: "hou6.png")!) ;

		gifTemplate3.animationDuration = 1
		gifTemplate3.animationRepeatCount = 0
		gifTemplate3.startAnimating()

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func tapHandler1(sender: UITapGestureRecognizer) {
		gifImage.animationImages = NSArray() as? [UIImage] ;
		gifImage.animationImages?.append(UIImage(named: "hou3.jpg")!) ;
		gifImage.animationImages?.append(UIImage(named: "hou4.jpg")!) ;

		gifImage.animationDuration = 1
		gifImage.animationRepeatCount = 0
		gifImage.startAnimating()

	}

	func tapHandler2(sender: UITapGestureRecognizer) {
		gifImage.animationImages = NSArray() as? [UIImage] ;
		gifImage.animationImages?.append(UIImage(named: "hou1.png")!) ;
		gifImage.animationImages?.append(UIImage(named: "hou2.png")!) ;

		gifImage.animationDuration = 1
		gifImage.animationRepeatCount = 0
		gifImage.startAnimating()

	}
    
    func addFaceToBackGround(faceBound: CGRect, backgroundImage: UIImage, faceImage: UIImage) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(backgroundImage.size, false, 0.0)
        faceImage.drawInRect(faceBound)
        backgroundImage.drawInRect(CGRect(origin: CGPointZero, size: backgroundImage.size))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func tapHandler3(sender:UITapGestureRecognizer){
        gifImage.animationImages = NSArray() as? [UIImage];
        
        let image1 = addFaceToBackGround(faceBound, backgroundImage: UIImage(named: "hou1.png")!, faceImage: faceImage!)
        let image2 = addFaceToBackGround(faceBound, backgroundImage: UIImage(named: "hou6.png")!, faceImage: faceImage!)
        gifImage.animationImages?.append(image1);
        gifImage.animationImages?.append(image2);

        gifImage.animationDuration = 1
        gifImage.animationRepeatCount = 0
        gifImage.startAnimating()
        
    }
	/*




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
	 bounds.size.height *= 1.25
	 bounds.size.width *= 1.1
	 return bounds
	 }

	 */
}



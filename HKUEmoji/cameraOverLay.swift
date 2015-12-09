//
//  cameraOverLay.swift
//  HKUEmoji
//
//  Created by hu hao on 12/3/15.
//  Copyright © 2015 hu hao. All rights reserved.
//
import UIKit

class cameraOverLay: UIView {
    
    
    @IBOutlet var overLayImg: UIImageView!
    
    //MARK:
    //MARK: functions
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        overLayImg.image = UIImage(named: "test.png")
    }
    
    
}

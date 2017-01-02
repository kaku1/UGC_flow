//
//  CustomCameraOverlayView.swift
//  UGC_flow
//
//  Created by shashi kumar on 02/01/17.
//  Copyright © 2017 Siddhant Saxena. All rights reserved.
//

import UIKit

protocol CustomCameraOverlayViewDelegate: class {
    func takePic(sender: UIButton, view: CustomCameraOverlayView)
}

class CustomCameraOverlayView: UIView {

    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var takePicButton: UIButton!
    weak var delegate: CustomCameraOverlayViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        takePicButton.layer.masksToBounds = true
        takePicButton.layer.cornerRadius = takePicButton.height() / 2
        takePicButton.layer.borderColor = UIColor.whiteColor().CGColor
        takePicButton.layer.borderWidth = 3
    }
    
    
    @IBAction func didTapTakePicButton(sender: UIButton) {
        if let delegate = delegate {
            delegate.takePic(sender, view: self)
        }
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

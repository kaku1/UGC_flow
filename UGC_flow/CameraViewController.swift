//
//  CameraViewController.swift
//  UGC_flow
//
//  Created by shashi kumar on 02/01/17.
//  Copyright © 2017 Siddhant Saxena. All rights reserved.
//

import UIKit
protocol CameraViewControllerDelegate:class {
    func goToNextPage(pageIndex: Int)
    func imageClicked(image: UIImage)
    
}
class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CustomCameraOverlayViewDelegate {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var toolTipButton: UIButton!
    @IBAction func toolTipButtonAction(sender: AnyObject) {
        self.toolTipButton.hidden = true;
    }
    
    weak var delegate: CameraViewControllerDelegate?
    var pageIndex = 0
//    @IBOutlet weak var next_Button: UIButton!
//    @IBAction func next_screen(sender: AnyObject) {
//        
//    }
    
    lazy var customCameraView: CustomCameraOverlayView = {
        let view = CustomCameraOverlayView.loadFromNib() as! CustomCameraOverlayView
        view.frame = self.view.bounds
        view.backgroundColor = .clearColor()
        view.opaque = false
        view.delegate = self
        
        return view
    }()
    
    lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController.init()
        picker.delegate = self
        picker.allowsEditing = true
        
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        openPhoneCamera()
        self.view.bringSubviewToFront(closeButton)
        self.view.bringSubviewToFront(titleLabel)
        self.view.bringSubviewToFront(toolTipButton)
        
        self.toolTipButton.layer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.5).CGColor
        self.toolTipButton.layer.borderWidth = 0.5
        self.toolTipButton.layer.cornerRadius = 4
        nextButton.alpha = 0
        self.view.bringSubviewToFront(nextButton)
        // Do any additional setup after loading the view.
        
//        self.next_Button.layer.cornerRadius = 30
//        self.next_Button.layer.borderColor = UIColor.whiteColor().CGColor
//        self.next_Button.layer.borderWidth = 2
        
    }
    
    //MARK: Action
    
    @IBAction func didTapCloseButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didTapNextButton(sender: UIButton) {
        if let delegate = delegate {
            delegate.goToNextPage(pageIndex + 1)
        }
    }
    
    //MARK: CustomCameraOverlayViewDelegate
    
    func takePic(sender: UIButton, view: CustomCameraOverlayView) {
        imagePicker.takePicture()
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.view.removeFromSuperview()

//        if isCameraOpeningDirectly {
//            isCameraOpeningDirectly = false
//        } else {
//            picker.dismissViewControllerAnimated(true, completion: nil)
//        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var chosenImage: UIImage?
        if info[UIImagePickerControllerEditedImage] != nil {
            chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage //2
        } else if info[UIImagePickerControllerOriginalImage] != nil {
            chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage //2
        }
        
        if let delegate = delegate {
            delegate.imageClicked(chosenImage!)
        }
        
        self.toolTipButton.hidden = true
        nextButton.alpha = 1
        previewImageView.contentMode = .ScaleAspectFill
        previewImageView.image = chosenImage
//        cameraView.configureWithImage(chosenImage)
        print("image data non compressed \(UIImageJPEGRepresentation(chosenImage!, 1)?.length)")
        let imageData = UIImageJPEGRepresentation(chosenImage!, 0.5)
        print("image data compressed \(imageData?.length)")
//        uploadImage(imageData!)
        
        picker.view.removeFromSuperview()
//
//        if isCameraOpeningDirectly {
//            isCameraOpeningDirectly = false
//            self.openNextController(false)
//        } else {
//            picker.dismissViewControllerAnimated(true, completion: {
//                self.openNextController(false)
//            })
//        }
        
    }
    
    //MARK: Helpers
    
    func openPhoneCamera() -> Void {
        imagePicker.sourceType = .Camera
        imagePicker.cameraCaptureMode = .Photo
        imagePicker.showsCameraControls = false
        imagePicker.cameraDevice = .Rear
        
//        customCameraView.frame = (imagePicker.cameraOverlayView?.frame)!
        imagePicker.cameraOverlayView = customCameraView
        let screenSize = UIScreen.mainScreen().bounds.size
        let ratio: CGFloat = 4.0 / 3.0
        let cameraHeight = screenSize.width * ratio
        let scale: CGFloat = screenSize.height / cameraHeight
        imagePicker.cameraViewTransform = CGAffineTransformMakeTranslation(0, (screenSize.height - cameraHeight) / 2.0)
        imagePicker.cameraViewTransform = CGAffineTransformScale(imagePicker.cameraViewTransform, scale, scale);
                
        imagePicker.toolbarHidden = true
        imagePicker.navigationBarHidden = true
        self.view.addSubview(imagePicker.view)

//        if isCameraOpeningDirectly {
//        } else {
//            imagePicker.modalPresentationStyle = .FullScreen
//            self.presentViewController(imagePicker, animated: true, completion: nil)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension NSObject {
    class func className() -> String {
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }
}

//MARK: UIView
extension UIView {
    class func nib() -> UINib {
        return UINib(nibName: className(), bundle: nil)
    }
    
    class func reuseIdentifier() -> String {
        return className()
    }
    
    class func loadFromNib() -> UIView? {
        return nib().instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
    
    func transformViewToIdentity(duration: NSTimeInterval, delay: NSTimeInterval, damping: CGFloat, velocity: CGFloat, alpha: CGFloat) -> Void {
        UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: .CurveEaseOut, animations: {
            self.alpha = alpha
            self.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
    func transformViewWithTranslation(duration: NSTimeInterval, delay: NSTimeInterval, damping: CGFloat, velocity: CGFloat, alpha: CGFloat, y: CGFloat, x: CGFloat) -> Void {
        UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: .CurveEaseOut, animations: {
            self.alpha = alpha
            self.transform = CGAffineTransformMakeTranslation(x, y)
            }, completion: nil)
    }
    
    func top() -> CGFloat {
        return self.frame.origin.y
    }
    func bottom() -> CGFloat {
        return self.frame.origin.y + self.frame.size.height
    }
    func left() -> CGFloat {
        return self.frame.origin.x
    }
    func right() -> CGFloat {
        return self.frame.origin.x + self.frame.size.width
    }
    func width() -> CGFloat {
        return self.bounds.width
    }
    func height() -> CGFloat {
        return self.bounds.height
    }
    
    func setBottom(bottom: CGFloat) -> Void {
        var frame = self.frame
        frame.origin.y = bottom - self.height()
        self.frame = frame
    }
    func setTop(top: CGFloat) -> Void {
        var frame = self.frame
        frame.origin.y = top
        self.frame = frame
    }
}

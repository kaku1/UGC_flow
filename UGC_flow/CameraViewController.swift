//
//  CameraViewController.swift
//  UGC_flow
//
//  Created by shashi kumar on 02/01/17.
//  Copyright © 2017 Siddhant Saxena. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation

protocol CameraViewControllerDelegate:class {
    func goToNextPage(pageIndex: Int)
    func imageClicked(image: UIImage)
}

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CustomCameraOverlayViewDelegate {

    @IBOutlet weak var retakeButton: UIButton!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var toolTipButton: UIButton!
    @IBAction func toolTipButtonAction(sender: AnyObject) {
        self.toolTipButton.hidden = true;
    }
    
    var avPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    
    var videoName = ""
    var playButton: UIButton?

    weak var delegate: CameraViewControllerDelegate?
    var pageIndex = 0
    var countdown: CGFloat = 0
    var myTimer: NSTimer?
    
    var videoView: DummyVideoView?
    
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
        picker.allowsEditing = false
        
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        playButton = UIButton.init(frame: CGRectMake((UIScreen.mainScreen().bounds.size.width - 100) / 2, 20, 100, 50))
        playButton?.setTitle("Play", forState: .Normal)
        playButton?.addTarget(self, action: #selector(CameraViewController.didTapPlayButton), forControlEvents: .TouchUpInside)
        playButton?.alpha = 0
        playButton?.setTitleColor(UIColor.blueColor(), forState: .Normal)
        self.view!.addSubview(playButton!)

        openPhoneCamera()
        
        self.view.bringSubviewToFront(closeButton)
        self.view.bringSubviewToFront(toolTipButton)
        self.view.bringSubviewToFront(playButton!)
        self.view.bringSubviewToFront(retakeButton)

        self.toolTipButton.layer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.5).CGColor
        self.toolTipButton.layer.borderWidth = 0.5
        self.toolTipButton.layer.cornerRadius = 4
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let avPlayerLayer = avPlayerLayer {
            avPlayerLayer.frame = view.bounds
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: avPlayer.currentItem)
    }
    
    //MARK: Action
    
    @IBAction func didTapRetakeButton(sender: UIButton) {
        removeVideoLayer()
        playButton?.alpha = 0
        customCameraView.timerView.alpha = 1
        openPhoneCamera()
    }
    
    @IBAction func didTapCloseButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didTapNextButton(sender: UIButton) {
        if let delegate = delegate {
            delegate.goToNextPage(pageIndex + 1)
        }
    }
    
    func didTapPlayButton() {
        playVideo()
    }
    
    //MARK: CustomCameraOverlayViewDelegate
    
    func takePic(view: CustomCameraOverlayView) {
        countdown = 10
        customCameraView.timerView.alpha = 1
        customCameraView.startProgress()
        myTimer = NSTimer(timeInterval: 1.0, target: self, selector:#selector(CameraViewController.countDownTick), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(myTimer!, forMode: NSDefaultRunLoopMode)
        customCameraView.timerLabel.text = "\(countdown)"

        imagePicker.startVideoCapture()
    }
    
    func stopCapturingVideo() {
        countdown = 0
        if let myTimer = myTimer {
            myTimer.invalidate()
        }
        myTimer = nil
        imagePicker.stopVideoCapture()
        customCameraView.timerView.alpha = 0
//        customCameraView.stopProgress()
        
        customCameraView.timerLabel.text = "\(countdown)"
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.view.removeFromSuperview()
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedVideo:NSURL = (info[UIImagePickerControllerMediaURL] as? NSURL) {
            
            // Save video to the main photo album
            let selectorToCall = #selector(CameraViewController.videoWasSavedSuccessfully(_:didFinishSavingWithError:context:))
            UISaveVideoAtPathToSavedPhotosAlbum(pickedVideo.relativePath!, self, selectorToCall, nil)
            
            // Save the video to the app directory so we can play it later
            let videoData = NSData(contentsOfURL: pickedVideo)
            let paths = NSSearchPathForDirectoriesInDomains(
                NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            let documentsDirectory: AnyObject = paths[0]
            let dataPath = documentsDirectory.stringByAppendingPathComponent(saveFileName())
            videoData?.writeToFile(dataPath, atomically: false)
            
            let movieAsset = AVURLAsset.init(URL: NSURL.fileURLWithPath(dataPath))
            
            let assetImageGemerator = AVAssetImageGenerator.init(asset: movieAsset)
            assetImageGemerator.appliesPreferredTrackTransform = true
            var thumbnail : CGImageRef?
            var actualTime = kCMTimeZero
            do {
                thumbnail = try assetImageGemerator.copyCGImageAtTime(CMTimeMake(1, 2), actualTime: &actualTime)
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
            
            if let thumbnail = thumbnail {
                previewImageView.alpha = 1
                previewImageView.contentMode = .ScaleAspectFill
                previewImageView.image = UIImage.init(CGImage: thumbnail)
            }
            
            picker.view.removeFromSuperview()
            addVideoLayer()
        }

//        var chosenImage: UIImage?
//        if info[UIImagePickerControllerEditedImage] != nil {
//            chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage //2
//        } else if info[UIImagePickerControllerOriginalImage] != nil {
//            chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage //2
//        }
//        
//        if let delegate = delegate {
//            delegate.imageClicked(chosenImage!)
//        }
        
//        self.toolTipButton.hidden = true
//        nextButton.alpha = 1
//        previewImageView.contentMode = .ScaleAspectFill
//        previewImageView.image = chosenImage
//        print("image data non compressed \(UIImageJPEGRepresentation(chosenImage!, 1)?.length)")
//        let imageData = UIImageJPEGRepresentation(chosenImage!, 0.5)
//        print("image data compressed \(imageData?.length)")
//        uploadImage(imageData!)
        
    }
    
    //MARK: Helpers
    
    func addVideoLayer() -> Void {
        retakeButton.alpha = 1
        playButton?.alpha = 1
        customCameraView.timerView.alpha = 0
        
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        view.layer.insertSublayer(avPlayerLayer, atIndex: 0)
        self.view.layoutIfNeeded()
    }
    
    func removeVideoLayer() -> Void {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: avPlayer.currentItem)
        avPlayerLayer.removeFromSuperlayer()
        avPlayerLayer = nil
    }
    
    func playerItemDidReachEnd(notification: NSNotification) {
        previewImageView.alpha = 1
        playButton?.alpha = 1
        
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seekToTime(kCMTimeZero)
    }
    
    func playVideo() {
        previewImageView.alpha = 0
        playButton?.alpha = 0
        
        let paths = NSSearchPathForDirectoriesInDomains(
            NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: AnyObject = paths[0]
        let dataPath = documentsDirectory.stringByAppendingPathComponent(videoName)
        let videoAsset = (AVAsset(URL: NSURL(fileURLWithPath: dataPath)))
        let playerItem = AVPlayerItem(asset: videoAsset)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CameraViewController.playerItemDidReachEnd(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: playerItem)
        
        avPlayer.replaceCurrentItemWithPlayerItem(playerItem)
        avPlayer.play()
//        videoView!.player?.play()
    }
    
    func addVideoView() -> Void {
        videoView = DummyVideoView.init(frame: self.view.frame)
        self.view.addSubview(videoView!)
        videoView!.layer.borderColor = UIColor.lightGrayColor().CGColor
        videoView!.layer.borderWidth = 1
        videoView!.backgroundColor = UIColor.orangeColor()
        videoView!.alpha = 0
        
        playButton = UIButton.init(frame: CGRectMake((UIScreen.mainScreen().bounds.size.width - 100) / 2, 20, 100, 50))
        playButton?.setTitle("Play", forState: .Normal)
        playButton?.addTarget(self, action: #selector(CameraViewController.didTapPlayButton), forControlEvents: .TouchUpInside)
        videoView!.addSubview(playButton!)
    }
    
    func videoWasSavedSuccessfully(video: String, didFinishSavingWithError error: NSError!, context: UnsafeMutablePointer<()>){
        print("Video saved")
        if let theError = error {
            print("An error happened while saving the video = \(theError)")
        } else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                // What you want to happen
            })
        }
    }
    
    func saveFileName() -> String {
        let df = NSDateFormatter()
        let currentDateStr = df.stringFromDate(NSDate())
        videoName = "ugc_\(currentDateStr).mp4"
        
        return videoName
    }
    
    func countDownTick() {
        countdown -= 1
        if (countdown == 0) {
            myTimer!.invalidate()
            myTimer = nil
            imagePicker.stopVideoCapture()
            customCameraView.timerView.alpha = 0
            customCameraView.stopProgress()
        }
        
        customCameraView.timerLabel.text = "\(countdown)"
    }
    
    func openPhoneCamera() -> Void {
        retakeButton.alpha = 0
        playButton?.alpha = 0
        
        imagePicker.sourceType = .Camera
        imagePicker.mediaTypes =  [kUTTypeMovie as String]
        imagePicker.showsCameraControls = false
        imagePicker.cameraDevice = .Rear
        imagePicker.videoQuality = .TypeHigh
        
        imagePicker.videoMaximumDuration = 10
        
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

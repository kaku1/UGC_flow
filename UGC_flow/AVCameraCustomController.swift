//
//  AVCameraCustomController.swift
//  UGC_flow
//
//  Created by shashi kumar on 19/01/17.
//  Copyright © 2017 Siddhant Saxena. All rights reserved.
//

import UIKit
import AVFoundation

class AVCameraCustomController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var capturedImageView: UIImageView!
    @IBOutlet weak var captureButton: UIButton!
    
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var stillImageOutput: AVCaptureStillImageOutput?
    var lastZoomFactor: CGFloat = 0
    var currentZoomFactor: CGFloat = 0

    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?
    
    var pinchGest: UIPinchGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captureButton.layer.masksToBounds = true
        captureButton.layer.cornerRadius = closeButton.height() / 2
        captureButton.backgroundColor = UIColor.clearColor()
        captureButton.layer.borderColor = UIColor.whiteColor().CGColor
        captureButton.layer.borderWidth = 6
        
        pinchGest = UIPinchGestureRecognizer.init(target: self, action: #selector(AVCameraCustomController.didPinch(_:)))
        self.view.addGestureRecognizer(pinchGest!)
        
        // Do any additional setup after loading the view, typically from a nib.
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        

        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        captureSession.addOutput(stillImageOutput)
        
        
        let devices = AVCaptureDevice.devices()
        
        // Loop through all the capture devices on this phone
        for device in devices {
            // Make sure this particular device supports video
            if (device.hasMediaType(AVMediaTypeVideo)) {
                // Finally check the position and confirm we've got the back camera
                if(device.position == AVCaptureDevicePosition.Back) {
                    captureDevice = device as? AVCaptureDevice
                    if captureDevice != nil {
                        print("Capture device found")
                        beginSession()
                        self.view.bringSubviewToFront(closeButton)
                        self.view.bringSubviewToFront(captureButton)
                    }
                }
            }
        }
        
    }
    
    func focusTo(focusPoint : CGPoint) {
        if let device = captureDevice {
            do {
                try device.lockForConfiguration()
                device.focusPointOfInterest = focusPoint
                device.focusMode = AVCaptureFocusMode.ContinuousAutoFocus
                device.exposurePointOfInterest = focusPoint
                device.exposureMode = AVCaptureExposureMode.ContinuousAutoExposure
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }

//        if let device = captureDevice {
//            do {
//                try device.lockForConfiguration()
//            } catch {
//                // handle error
//                return
//            }
//            
//            device.setFocusModeLockedWithLensPosition(value, completionHandler: { (time) -> Void in
//            })
//            device.unlockForConfiguration()
//        }
    }
    
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches , withEvent: event)
        let touch = touches.first
        let touchPoint = touch!.locationInView(self.view)
//        focusTo(touchPoint)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        let touch = touches.first
        let touchPoint = touch!.locationInView(self.view)
//        focusTo(touchPoint)
    }
        
    func configureDevice() {
        if let device = captureDevice {
            if device.isFocusModeSupported(.ContinuousAutoFocus) {
                do {
                    try device.lockForConfiguration()
                } catch {
                    // handle error
                    return
                }
                device.focusMode = .ContinuousAutoFocus
                device.unlockForConfiguration()
            } else {
                do {
                    try device.lockForConfiguration()
                } catch {
                    // handle error
                    return
                }
                device.focusMode = .Locked
                device.unlockForConfiguration()
            }
        }
        
    }
    
    func beginSession() {
        
        configureDevice()
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            // Do the rest of your work...
        } catch let error as NSError {
            // Handle any errors
            print(error)
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.view.layer.addSublayer(previewLayer!)
        previewLayer?.frame = self.view.layer.frame
        captureSession.startRunning()
    }
    
    @IBAction func didTapCaptureButton(sender: UIButton) {
        if let videoConnection = stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo) {
            
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(sampleBuffer, error) in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                print("imageData size \(Double(imageData.length) / 1024.0 / 1024.0 * 100 / 100) MB")
                

                let dataProvider = CGDataProviderCreateWithCFData(imageData)
                let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, .RenderingIntentDefault)
                let image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
                
                let compressedImageData = UIImageJPEGRepresentation(image, 0.3)
                print("image data compressed \((CGFloat((compressedImageData?.length)!) / 1024.0 / 1024.0) * 100 / 100) MB")

                dispatch_async(dispatch_get_main_queue(), {() in
                    self.capturedImageView.image = image
                    self.captureSession.stopRunning()
                    self.previewLayer?.removeFromSuperlayer()
                    self.captureButton.alpha = 0
                    self.view.removeGestureRecognizer(self.pinchGest!)
                    self.lastZoomFactor = 0.0
                    self.currentZoomFactor = 0.0
                })
            })
        }
    }
    
    func didPinch(recognizer: UIPinchGestureRecognizer) -> Void {
        if let device = self.captureDevice {
            if recognizer.state == .Ended || recognizer.state == .Cancelled {
                if recognizer.scale > 1 {
                    lastZoomFactor += recognizer.scale
                } else {
                    lastZoomFactor = max(0, (lastZoomFactor - 1 + recognizer.scale))
                }
                print("recognizer ended \(recognizer.scale) lastZoomFactor \(lastZoomFactor)")
            } else {
                let vZoomFactor = ((recognizer).scale)
                
                if vZoomFactor > 1 {
                    currentZoomFactor = lastZoomFactor + vZoomFactor
                } else {
                    currentZoomFactor = lastZoomFactor - 1 + vZoomFactor
                }
                print("vZoomFactor \(vZoomFactor) currentZoomFactor \(currentZoomFactor) lastZoomFactor \(lastZoomFactor)")
                var error:NSError!
                do{
                    try device.lockForConfiguration()
                    defer {device.unlockForConfiguration()}
                    if (currentZoomFactor <= device.activeFormat.videoMaxZoomFactor){
                        device.videoZoomFactor = max(1.0, currentZoomFactor)
                    }else{
                        print("Unable to set videoZoom: (max %f, asked %f)", device.activeFormat.videoMaxZoomFactor, currentZoomFactor)
                    }
                }catch error as NSError{
                    print("Unable to set videoZoom: \(error.localizedDescription)");
                }catch _{
                    
                }
            }
        }
    }
    
    @IBAction func didTapCloseButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
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

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

    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captureButton.layer.masksToBounds = true
        captureButton.layer.cornerRadius = closeButton.height() / 2
        captureButton.backgroundColor = UIColor.clearColor()
        captureButton.layer.borderColor = UIColor.whiteColor().CGColor
        captureButton.layer.borderWidth = 6
        
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
    
    func focusTo(value : Float) {
        if let device = captureDevice {
            do {
                try device.lockForConfiguration()
            } catch {
                // handle error
                return
            }
            
            device.setFocusModeLockedWithLensPosition(value, completionHandler: { (time) -> Void in
            })
            device.unlockForConfiguration()
        }
    }
    
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches , withEvent: event)
        let touch = touches.first
        let touchPercent = touch!.locationInView(self.view).x / screenWidth
//        focusTo(Float(touchPercent))
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        let touch = touches.first
        let touchPercent = touch!.locationInView(self.view).x / screenWidth
//        focusTo(Float(touchPercent))
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
                })
            })
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

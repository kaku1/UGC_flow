//
//  CustomCameraOverlayView.swift
//  UGC_flow
//
//  Created by shashi kumar on 02/01/17.
//  Copyright © 2017 Siddhant Saxena. All rights reserved.
//

import UIKit
import AVFoundation

protocol CustomCameraOverlayViewDelegate: class {
    func takePic(view: CustomCameraOverlayView)
    func stopCapturingVideo()
}

class CustomCameraOverlayView: UIView {

    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var takePicButton: UIButton!
    weak var delegate: CustomCameraOverlayViewDelegate?
    
    var isRecording = false
    
    let progressRadius: CGFloat = 35
    var progressLineLayer = CAShapeLayer()

    var progressPath: UIBezierPath!
    var endAngle: CGFloat = 0
    var startAngle: CGFloat = 3 * CGFloat(M_PI) / 2
    var isFirstTimeProgress = true

    override func awakeFromNib() {
        super.awakeFromNib()
        startAngle = 3 * CGFloat(M_PI) / 2

        takePicButton.layer.masksToBounds = true
        takePicButton.layer.cornerRadius = takePicButton.height() / 2
        takePicButton.layer.borderColor = UIColor.whiteColor().CGColor
        takePicButton.layer.borderWidth = 3
        takePicButton.userInteractionEnabled = false
        timerView.alpha = 1
        timerView.backgroundColor = .clearColor()
        timerView.layer.masksToBounds = true
        timerView.layer.cornerRadius = timerView.height() / 2
        timerView.userInteractionEnabled = true
    }
    
    @IBAction func didTapTakePicButton(sender: UIButton) {
//        if let delegate = delegate {
//            delegate.takePic(self)
//        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let center = timerView.center
        print("startAngle \(startAngle) endAngle \((3 * CGFloat(M_PI) / 2) + endAngle)")
        progressPath = UIBezierPath.init(arcCenter: center, radius: progressRadius, startAngle: startAngle, endAngle: (3 * CGFloat(M_PI) / 2) + endAngle, clockwise: true)
        progressLineLayer.path = progressPath.CGPath
        progressLineLayer.strokeColor = UIColor.redColor().CGColor
        progressLineLayer.fillColor = UIColor.clearColor().CGColor
        progressLineLayer.lineWidth = 10;
        progressLineLayer.lineCap = kCALineCapSquare;
        self.layer.addSublayer(progressLineLayer)

        let animationStrokeEnd = CABasicAnimation.init(keyPath: "strokeEnd")
        animationStrokeEnd.duration = 10
        animationStrokeEnd.fromValue = NSNumber.init(float: 0)
        animationStrokeEnd.toValue = NSNumber.init(float: 1)
        animationStrokeEnd.fillMode = kCAFillModeForwards
        progressLineLayer.addAnimation(animationStrokeEnd, forKey: "animate stroke end animation")

        startAngle = endAngle
    }
    
    func startProgress() -> Void {
        startAngle = 3 * CGFloat(M_PI) / 2
        endAngle = CGFloat(M_PI) * 2
        self.setNeedsDisplay()
    }
    
    func stopProgress() -> Void {
        isRecording = false
        startAngle = 3 * CGFloat(M_PI) / 2
        endAngle = 0;
        self.setNeedsDisplay()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let point = touch!.locationInView(self)
        
        if true == timerView.frame.contains(point) {
            print("touchesBegan in timer view frame \(frame) point \(point)")
            if !isRecording {
                isRecording = true
                if let delegate = delegate {
                    delegate.takePic(self)
                }
            }
        } else {
            print("touchesBegan began lol")
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let point = touch!.locationInView(self)
        
        if true == timerView.frame.contains(point) {
            print("touchesMoved in timer view frame \(frame) point \(point)")
        } else {
            if isRecording {
                stopProgress()
                if let delegate = delegate {
                    delegate.stopCapturingVideo()
                }
            }
            print("touchesMoved moved lol")
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let point = touch!.locationInView(self)
        if isRecording {
            stopProgress()
            if let delegate = delegate {
                delegate.stopCapturingVideo()
            }
        }
        if true == timerView.frame.contains(point) {
            print("touchesEnded in timer view frame \(frame) point \(point)")
        } else {
            print("touchesEnded ended lol")
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if let touches = touches {
            let touch = touches.first
            let point = touch!.locationInView(self)
            
            if isRecording {
                stopProgress()
                if let delegate = delegate {
                    delegate.stopCapturingVideo()
                }
            }

            if true == timerView.frame.contains(point) {
                print("touchesCancelled in timer view frame \(frame) point \(point)")
            } else {
                print("touchesCancelled cancelled lol")
            }
        }
    }
}

//
//  DummyVideoView.swift
//  UGC_flow
//
//  Created by shashi kumar on 16/01/17.
//  Copyright © 2017 Siddhant Saxena. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation

class DummyVideoView: UIView {
        
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer {

        return layer as! AVPlayerLayer
    }
    
    // Override UIView property
    override class func layerClass() -> AnyClass {
        return AVPlayer.self
    }
}

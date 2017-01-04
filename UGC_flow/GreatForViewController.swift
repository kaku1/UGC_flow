//
//  GreatForViewController.swift
//  UGC_flow
//
//  Created by Siddhant Saxena on 02/01/17.
//  Copyright © 2017 Siddhant Saxena. All rights reserved.
//

import UIKit

protocol GreatForViewControllerDelegate: class {
    func postRecommendation(whereStr: String)
}

class GreatForViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var postButtonBottomConstraint: NSLayoutConstraint!
    weak var delegate: GreatForViewControllerDelegate?
    var pageIndex = 2
    lazy var panGesture: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer.init(target: self, action: #selector(GreatForViewController.didTapView(_:)))
        
        return gest
    }()

    @IBOutlet weak var placeholderTextPlace: UILabel!
    @IBOutlet weak var placeText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeText.delegate = self
        
        addNotification()

        // Do any additional setup after loading the view.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func addNotification() -> Void {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GreatForViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GreatForViewController.keyboardWillDismiss(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }

    func didTapView(recognizer: UIGestureRecognizer) -> Void {
        self.view.endEditing(true)
    }
    
    func textViewDidChange(textView: UITextView) {
        placeholderTextPlace.alpha = (textView.text == "") ? 1 : 0
    }
    func textViewDidBeginEditing(textView: UITextView) {
        
    }

    @IBAction func didTapPostButton(sender: UIButton) {
        self.view.endEditing(true)
        if placeText.text != "" {
            if let delegate = delegate {
                delegate.postRecommendation(placeText.text)
            }
        }
       
    }
    
    //MARK: Keyboard Notification
    
    func keyboardWillShow(notification: NSNotification) -> Void {
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        keyboardFrame = self.view.convertRect(keyboardFrame, fromView: nil)
        
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
        
        UIView.animateWithDuration(duration, delay: 0, options: options, animations: {
            self.postButtonBottomConstraint.constant = keyboardFrame.height
        }) { (isSucceed) in
            self.view.addGestureRecognizer(self.panGesture)
            self.view.userInteractionEnabled = true
            self.view.layoutIfNeeded()
        }
        //        }
    }
    
    func keyboardWillDismiss(notification: NSNotification) -> Void {
        //        if let obj = notification.object {
        //            print("obj \(obj)")
        self.view.removeGestureRecognizer(self.panGesture)
        self.postButtonBottomConstraint.constant = 0
        self.view.layoutIfNeeded()
        //        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

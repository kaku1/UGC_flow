//
//  RecommendPlaceController.swift
//  UGC_flow
//
//  Created by Siddhant Saxena on 02/01/17.
//  Copyright © 2017 Siddhant Saxena. All rights reserved.
//

import UIKit

protocol RecommendPlaceControllerDelegate:class {
    func pushNextButton()
    
}
class RecommendPlaceController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var greatFor: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    weak var delegate: RecommendPlaceControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        greatFor.delegate = self

        
//keyboard accessory bar
//        let numberToolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
//        numberToolbar.barStyle = UIBarStyle.Default
//        numberToolbar.items = [
//            UIBarButtonItem(title: "CANCEL", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelNumberPad"),
//            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
//            UIBarButtonItem(title: "NEXT", style: UIBarButtonItemStyle.Plain, target: self, action: "NextScreen")]
//        numberToolbar.sizeToFit()
//        greatFor.inputAccessoryView = numberToolbar
        
        
        // Do any additional setup after loading the view.
    }
    var pageIndex = 1
    func textViewDidChange(textView: UITextView) { //Handle the text changes here
        print(textView.text);
        placeholderLabel.text = ""
        if textView.text != "" {
            print("nothing in textview")
            placeholderLabel.text = ""
        }
        //textView.text = ""//the textView parameter is the textView where text was changed
    }
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
//        placeholderLabel.text = ""
//        if textView.text != "" {
//            print("nothing in textview")
//            placeholderLabel.text = ""
//        }
        textView.textColor = UIColor.blackColor()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let delay = 2 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.greatFor.becomeFirstResponder()
            
            if let delegate = self.delegate {
                delegate.pushNextButton()
            }
        }
        
//        print("accessing parent components")
//        if let parentVC = self.parentViewController as? RecommendParentController {
//            print("accessing parent components")
//            parentVC.nextBottomConsraint.constant = 300
//        }
        // self.GreatFor.becomeFirstResponder()
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

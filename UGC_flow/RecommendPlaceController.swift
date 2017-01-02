//
//  RecommendPlaceController.swift
//  UGC_flow
//
//  Created by Siddhant Saxena on 02/01/17.
//  Copyright © 2017 Siddhant Saxena. All rights reserved.
//

import UIKit

class RecommendPlaceController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var greatFor: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        greatFor.delegate = self
        // Do any additional setup after loading the view.
    }
    var pageIndex = 1
    func textViewDidChange(textView: UITextView) { //Handle the text changes here
        print(textView.text);
        //textView.text = ""//the textView parameter is the textView where text was changed
    }
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        textView.text = ""
        textView.textColor = UIColor.blackColor()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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

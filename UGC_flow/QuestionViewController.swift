//
//  QuestionViewController.swift
//  UGC_flow
//
//  Created by shashi kumar on 03/01/17.
//  Copyright © 2017 Siddhant Saxena. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var questionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answerTextView.delegate = self
    }
    
    var pageIndex = 0
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
    }
    
}

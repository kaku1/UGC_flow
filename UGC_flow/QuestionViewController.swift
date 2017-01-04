//
//  QuestionViewController.swift
//  UGC_flow
//
//  Created by shashi kumar on 03/01/17.
//  Copyright © 2017 Siddhant Saxena. All rights reserved.
//

import UIKit

protocol QuestionViewControllerDelegate: class {
    func enteredAnswer(text: String, pageIndex: Int, controller: QuestionViewController)
}

class QuestionViewController: UIViewController, UITextViewDelegate {
    
    weak var delegate: QuestionViewControllerDelegate?

    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answerTextView.delegate = self
        addToolBar()
        placeholderLabel.alpha = (answerTextView.text == "") ? 1 : 0
    }
    
    var pageIndex = 0
    var doneButton: UIBarButtonItem?
    func textViewDidChange(textView: UITextView) { //Handle the text changes here
        placeholderLabel.alpha = (textView.text == "") ? 1 : 0
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
//        textView.text = ""
        textView.textColor = UIColor.blackColor()
        placeholderLabel.alpha = (textView.text == "") ? 1 : 0
        return true
    }
    
    func addToolBar() -> Void {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        doneButton = UIBarButtonItem(title: "NEXT", style: .Done, target: self, action: #selector(QuestionViewController.didTapDoneButton(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton!], animated: false)
        toolBar.userInteractionEnabled = true
        toolBar.sizeToFit()
        answerTextView.inputAccessoryView = toolBar
    }
    
    func didTapDoneButton(sender: UIBarButtonItem) {
        view.endEditing(true)
        if let delegate = delegate {
            delegate.enteredAnswer(answerTextView.text, pageIndex: pageIndex, controller: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

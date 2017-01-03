//
//  ViewController.swift
//  UGC_flow
//
//  Created by Siddhant Saxena on 02/01/17.
//  Copyright © 2017 Siddhant Saxena. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func didTapQuestion4Button(sender: UIButton) {
        let sb = UIStoryboard.init(name: "Question", bundle: nil)
        let contr = sb.instantiateViewControllerWithIdentifier("QuestionParentViewController") as! QuestionParentViewController
        contr.initialIndex = 3
        self.presentViewController(contr, animated: true, completion: nil)
    }
    @IBAction func didTapQuestion3Button(sender: UIButton) {
        let sb = UIStoryboard.init(name: "Question", bundle: nil)
        let contr = sb.instantiateViewControllerWithIdentifier("QuestionParentViewController") as! QuestionParentViewController
        contr.initialIndex = 2
        self.presentViewController(contr, animated: true, completion: nil)
    }
    @IBAction func didTapQuestion2Button(sender: UIButton) {
        let sb = UIStoryboard.init(name: "Question", bundle: nil)
        let contr = sb.instantiateViewControllerWithIdentifier("QuestionParentViewController") as! QuestionParentViewController
        contr.initialIndex = 1
        self.presentViewController(contr, animated: true, completion: nil)
    }
    @IBAction func didTapQuestion1Button(sender: UIButton) {
        let sb = UIStoryboard.init(name: "Question", bundle: nil)
        let contr = sb.instantiateViewControllerWithIdentifier("QuestionParentViewController") as! QuestionParentViewController
        contr.initialIndex = 0
        self.presentViewController(contr, animated: true, completion: nil)
    }
}


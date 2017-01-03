//
//  ViewController.swift
//  UGC_flow
//
//  Created by Siddhant Saxena on 02/01/17.
//  Copyright © 2017 Siddhant Saxena. All rights reserved.
//

import UIKit

class ViewController: UIViewController, QuestionParentViewControllerDelegate {
    
    
    @IBOutlet weak var recommendationImage: UIImageView!
    @IBOutlet weak var recommendationTitle: UILabel!
    @IBOutlet weak var recommendationPlace: UILabel!
    
    var answer1Text: String?
    var answer2Text: String?
    var answer3Text: String?
    var answer4Text: String?
    
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
        contr.delegate = self
        contr.answer1Text = answer1Text
        contr.answer2Text = answer2Text
        contr.answer3Text = answer3Text
        contr.answer4Text = answer4Text
        self.presentViewController(contr, animated: true, completion: nil)
    }
    @IBAction func didTapQuestion3Button(sender: UIButton) {
        let sb = UIStoryboard.init(name: "Question", bundle: nil)
        let contr = sb.instantiateViewControllerWithIdentifier("QuestionParentViewController") as! QuestionParentViewController
        contr.initialIndex = 2
        contr.delegate = self
        contr.answer1Text = answer1Text
        contr.answer2Text = answer2Text
        contr.answer3Text = answer3Text
        contr.answer4Text = answer4Text
        self.presentViewController(contr, animated: true, completion: nil)
    }
    @IBAction func didTapQuestion2Button(sender: UIButton) {
        let sb = UIStoryboard.init(name: "Question", bundle: nil)
        let contr = sb.instantiateViewControllerWithIdentifier("QuestionParentViewController") as! QuestionParentViewController
        contr.initialIndex = 1
        contr.answer1Text = answer1Text
        contr.answer2Text = answer2Text
        contr.answer3Text = answer3Text
        contr.answer4Text = answer4Text
        contr.delegate = self
        self.presentViewController(contr, animated: true, completion: nil)
    }
    @IBAction func didTapQuestion1Button(sender: UIButton) {
        let sb = UIStoryboard.init(name: "Question", bundle: nil)
        let contr = sb.instantiateViewControllerWithIdentifier("QuestionParentViewController") as! QuestionParentViewController
        contr.initialIndex = 0
        contr.delegate = self
        contr.answer1Text = answer1Text
        contr.answer2Text = answer2Text
        contr.answer3Text = answer3Text
        contr.answer4Text = answer4Text
        self.presentViewController(contr, animated: true, completion: nil)
    }
    
    //MARK: QuestionParentViewControllerDelegate
    
    func configireFeature(text: String?, type: Int) {
        if type == 0 {
            answer1Text = text
        } else if type == 1 {
            answer2Text = text
        } else if type == 2 {
            answer3Text = text
        } else if type == 3 {
            answer4Text = text
        }
    }
}


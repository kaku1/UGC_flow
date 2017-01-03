//
//  QuestionParentViewController.swift
//  UGC_flow
//
//  Created by shashi kumar on 03/01/17.
//  Copyright © 2017 Siddhant Saxena. All rights reserved.
//

import UIKit

protocol QuestionParentViewControllerDelegate: class {
    func configireFeature(text: String?, type: Int)
}

class QuestionParentViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, QuestionViewControllerDelegate {
    
    @IBOutlet weak var closeButton: UIButton!
    var answer1Text: String?
    var answer2Text: String?
    var answer3Text: String?
    var answer4Text: String?

    weak var delegate: QuestionParentViewControllerDelegate?
    
    lazy var questionFirstContr: QuestionViewController = {
        let sb = UIStoryboard.init(name: "Question", bundle: nil)
        let contr = sb.instantiateViewControllerWithIdentifier("QuestionViewController") as! QuestionViewController
        contr.view.backgroundColor = .whiteColor()
        contr.questionLabel.text = "Q1. Share your experience"
        contr.delegate = self
        contr.answerTextView.text = self.answer1Text
        
        return contr
    }()
    
    lazy var questionSecondContr: QuestionViewController = {
        let sb = UIStoryboard.init(name: "Question", bundle: nil)
        let contr = sb.instantiateViewControllerWithIdentifier("QuestionViewController") as! QuestionViewController
        contr.view.backgroundColor = .whiteColor()
        contr.questionLabel.text = "Q2. Protip"
        contr.delegate = self
        contr.answerTextView.text = self.answer2Text

        return contr
    }()

    lazy var questionThirdContr: QuestionViewController = {
        let sb = UIStoryboard.init(name: "Question", bundle: nil)
        let contr = sb.instantiateViewControllerWithIdentifier("QuestionViewController") as! QuestionViewController
        contr.view.backgroundColor = .whiteColor()
        contr.questionLabel.text = "Q3. Best time to visit"
        contr.delegate = self
        contr.answerTextView.text = self.answer3Text

        return contr
    }()

    lazy var questionFourthContr: QuestionViewController = {
        let sb = UIStoryboard.init(name: "Question", bundle: nil)
        let contr = sb.instantiateViewControllerWithIdentifier("QuestionViewController") as! QuestionViewController
        contr.view.backgroundColor = .whiteColor()
        contr.questionLabel.text = "Q4. Howdy!!"
        contr.delegate = self
        contr.answerTextView.text = self.answer4Text

        return contr
    }()
    
    lazy var pageController: UIPageViewController = {
       let contr = UIPageViewController.init(transitionStyle: .Scroll, navigationOrientation: .Vertical, options: nil)
        contr.view.backgroundColor = .whiteColor()
        
        return contr
    }()
    
    var initialIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.backgroundColor = .whiteColor()
        self.pageController.dataSource = self
        self.pageController.delegate = self
        let questionFContr = viewControllerAtIndex(initialIndex)
        
        if let contr = questionFContr {
            let viewControllers = [contr]
            
            pageController.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
        }
        
        
        // Change the size of page view controller
        pageController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.addChildViewController(pageController)
        self.view.addSubview(pageController.view)
        self.pageController.didMoveToParentViewController(self)
        
        self.view.bringSubviewToFront(self.closeButton)
    }
    
    @IBAction func didTapCloseButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //QuestionViewControllerDelegate
    
    func enteredAnswer(text: String, pageIndex: Int, controller: QuestionViewController) {
        var index = 0
        if controller == questionFirstContr {
            index = questionFirstContr.pageIndex
        } else if controller == questionSecondContr {
            index = questionSecondContr.pageIndex
        } else if controller == questionThirdContr {
            index = questionThirdContr.pageIndex
        } else if controller == questionFourthContr {
            index = questionFourthContr.pageIndex
        }
        
        if let delegate = delegate {
            delegate.configireFeature(text, type: index)
        }
    }
    
    //MARK: UIPageViewControllerDelegate, UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = 0
        if viewController == questionFirstContr {
            index = questionFirstContr.pageIndex
        } else if viewController == questionSecondContr {
            index = questionSecondContr.pageIndex
        } else if viewController == questionThirdContr {
            index = questionThirdContr.pageIndex
        } else if viewController == questionFourthContr {
            index = questionFourthContr.pageIndex
        }
        
        if (index == NSNotFound) {
            return nil;
        }
        
        index += 1
        if (index == 4) {
            return nil;
        }
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = 0
        if viewController == questionFirstContr {
            index = questionFirstContr.pageIndex
        } else if viewController == questionSecondContr {
            index = questionSecondContr.pageIndex
        } else if viewController == questionThirdContr {
            index = questionThirdContr.pageIndex
        } else if viewController == questionFourthContr {
            index = questionFourthContr.pageIndex
        }
        
        if ((index == 0) || (index == NSNotFound)) {
            return nil
        }
        
        index -= 1
        return viewControllerAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 4
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    //MARK: Helpers
    
    func viewControllerAtIndex(index: Int) -> UIViewController? {
        if index == 0 {
            questionFirstContr.pageIndex = index
            return questionFirstContr
        } else if index == 1 {
            questionSecondContr.pageIndex = index
            return questionSecondContr
        } else if index == 2 {
            questionThirdContr.pageIndex = index
            return questionThirdContr
        } else if index == 3 {
            questionFourthContr.pageIndex = index
            return questionFourthContr
        }
        
        return nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

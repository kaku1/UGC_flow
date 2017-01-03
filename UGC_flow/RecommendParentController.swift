//
//  RecommendParentController.swift
//  UGC_flow
//
//  Created by shashi kumar on 02/01/17.
//  Copyright © 2017 Siddhant Saxena. All rights reserved.
//

import UIKit

class RecommendParentController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, CameraViewControllerDelegate, RecommendPlaceControllerDelegate {

    @IBOutlet weak var next_Button: UIButton!
    @IBOutlet weak var nextBottomConsraint: NSLayoutConstraint!
    
    var currentIndex = 0
    @IBAction func next_screen(sender: AnyObject) {
                                            pagerContr.setViewControllers([viewControllerAtIndex(1)!],
                                              direction: UIPageViewControllerNavigationDirection.Forward,
                                              animated: true,
                                              completion: nil)
        print("next called")
       
    }
    
    lazy var pagerContr: UIPageViewController = {
        let ugc = UIStoryboard.init(name: "Main", bundle: nil)
        let contr = ugc.instantiateViewControllerWithIdentifier("PageController") as? UIPageViewController
        contr!.view.backgroundColor = .whiteColor()

        return contr!
    }()
    //first controller
    lazy var cameraContr: CameraViewController = {
        let ugc = UIStoryboard.init(name: "Main", bundle: nil)
        let contr = ugc.instantiateViewControllerWithIdentifier("CameraViewController") as? CameraViewController
        contr?.delegate = self
        return contr!
    }()
    //second controller
    lazy var placeContr: RecommendPlaceController = {
        let ugc = UIStoryboard.init(name: "Main", bundle: nil)
        let contr = ugc.instantiateViewControllerWithIdentifier("RecommendPlaceController") as? RecommendPlaceController
        contr?.delegate = self
        return contr!
    }()
    // third controller
    lazy var GreatContr: GreatForViewController = {
        let ugc = UIStoryboard.init(name: "Main", bundle: nil)
        let contr = ugc.instantiateViewControllerWithIdentifier("GreatForViewController") as? GreatForViewController
        //contr?.delegate = self
        return contr!
    }()

    lazy var StickerContr: StickersViewController = {
        let ugc = UIStoryboard.init(name: "Main", bundle: nil)
        let contr = ugc.instantiateViewControllerWithIdentifier("StickersViewController") as? StickersViewController
        
        return contr!
    }()
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .whiteColor()
        setCameraView()
        self.view.bringSubviewToFront(next_Button)
        self.next_Button.hidden = true;
        //self.next_Button.layer.cornerRadius = 30
        //self.next_Button.layer.borderColor = UIColor.whiteColor().CGColor
        //self.next_Button.layer.borderWidth = 3
        self.next_Button.backgroundColor = UIColor.clearColor()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    func setCameraView() -> Void {
        self.pagerContr.dataSource = self
        self.pagerContr.delegate = self
        let cameraController = viewControllerAtIndex(0)
        
        if let contr = cameraController {
            let viewControllers = [contr]
            
            pagerContr.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
        }
        
        
        // Change the size of page view controller
        pagerContr.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        self.addChildViewController(pagerContr)
        self.view.addSubview(pagerContr.view)
        self.pagerContr.didMoveToParentViewController(self)
    }
    
    //MARK: UIPageViewControllerDelegate, UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = 0
        if true == viewController.isKindOfClass(CameraViewController) {
            let contr = viewController as! CameraViewController
            index = contr.pageIndex
        } else if (true == viewController.isKindOfClass(RecommendPlaceController)) {
            let contr = viewController as! RecommendPlaceController
            index = contr.pageIndex
        } else if (true == viewController.isKindOfClass(GreatForViewController)) {
            let contr = viewController as! GreatForViewController
            index = contr.pageIndex
        } else if (true == viewController.isKindOfClass(StickersViewController)) {
            let contr = viewController as! StickersViewController
            index = contr.pageIndex
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
        if true == viewController.isKindOfClass(CameraViewController) {
            let contr = viewController as! CameraViewController
            index = contr.pageIndex
        } else if (true == viewController.isKindOfClass(RecommendPlaceController)) {
            let contr = viewController as! RecommendPlaceController
            index = contr.pageIndex
        } else if (true == viewController.isKindOfClass(GreatForViewController)) {
            let contr = viewController as! GreatForViewController
            index = contr.pageIndex
        } else if (true == viewController.isKindOfClass(StickersViewController)) {
            let contr = viewController as! StickersViewController
            index = contr.pageIndex
        }
        
        if ((index == 0) || (index == NSNotFound)) {
            return nil
        }
        
        index -= 1
        return viewControllerAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 3
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func showNextButton() {
        self.next_Button.hidden = false;
    }
    
    func pushNextButton(pageIndex: Int) {
        print("pushing next")
        let contr = viewControllerAtIndex(pageIndex + 1)
        if let contr = contr {
            pagerContr.setViewControllers([contr], direction: .Forward, animated: true, completion: nil)
        }
    }
    //MARK: Helpers
    
    func viewControllerAtIndex(index: Int) -> UIViewController? {
         print("view controller index \(index)")
        if index == 0 {
            cameraContr.pageIndex = index
            return cameraContr
        } else if index == 1 {
            placeContr.pageIndex = index
            return placeContr
        } else if index == 2 {
            GreatContr.pageIndex = index
            return GreatContr
        }
        
        return nil
    }

}

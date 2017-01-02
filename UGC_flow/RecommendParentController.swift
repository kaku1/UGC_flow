//
//  RecommendParentController.swift
//  UGC_flow
//
//  Created by shashi kumar on 02/01/17.
//  Copyright © 2017 Siddhant Saxena. All rights reserved.
//

import UIKit

class RecommendParentController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, CameraViewControllerDelegate {

    @IBOutlet weak var next_Button: UIButton!
    @IBAction func next_screen(sender: AnyObject) {
        let cameraController = viewControllerAtIndex(1)
        let viewControllers = [placeContr]
        pagerContr.setViewControllers(viewControllers,
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
    
    lazy var cameraContr: CameraViewController = {
        let ugc = UIStoryboard.init(name: "Main", bundle: nil)
        let contr = ugc.instantiateViewControllerWithIdentifier("CameraViewController") as? CameraViewController
        contr?.delegate = self
        return contr!
    }()
    
    lazy var placeContr: RecommendPlaceController = {
        let ugc = UIStoryboard.init(name: "Main", bundle: nil)
        let contr = ugc.instantiateViewControllerWithIdentifier("RecommendPlaceController") as? RecommendPlaceController
        
        return contr!
    }()
    
    lazy var GreatContr: GreatForViewController = {
        let ugc = UIStoryboard.init(name: "Main", bundle: nil)
        let contr = ugc.instantiateViewControllerWithIdentifier("GreatForViewController") as? GreatForViewController
        
        return contr!
    }()

    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .whiteColor()
        setCameraView()
        self.view.bringSubviewToFront(next_Button)
        self.next_Button.hidden = true;
        self.next_Button.layer.cornerRadius = 30
        self.next_Button.layer.borderColor = UIColor.whiteColor().CGColor
        self.next_Button.layer.borderWidth = 3
        
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
        }
        
        if (index == NSNotFound) {
            return nil;
        }
        
        index += 1
        if (index == 3) {
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
    
    //MARK: Helpers
    
    func viewControllerAtIndex(index: Int) -> UIViewController? {
        
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

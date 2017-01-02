//
//  RecommendParentController.swift
//  UGC_flow
//
//  Created by shashi kumar on 02/01/17.
//  Copyright © 2017 Siddhant Saxena. All rights reserved.
//

import UIKit

class RecommendParentController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    lazy var pagerContr: UIPageViewController = {
        let ugc = UIStoryboard.init(name: "Main", bundle: nil)
        let contr = ugc.instantiateViewControllerWithIdentifier("PageController") as? UIPageViewController
        contr!.view.backgroundColor = .whiteColor()

        return contr!
    }()
    
    lazy var cameraContr: CameraViewController = {
        let ugc = UIStoryboard.init(name: "Main", bundle: nil)
        let contr = ugc.instantiateViewControllerWithIdentifier("CameraViewController") as? CameraViewController
        
        return contr!
    }()
    
    lazy var middleViewController: UIViewController = {
        let contr = UIViewController.init(nibName: nil, bundle: nil)
        contr.view.backgroundColor = .redColor()
        
        return contr
    }()
    
    lazy var lastViewController: UIViewController = {
        let contr = UIViewController.init(nibName: nil, bundle: nil)
        contr.view.backgroundColor = .blueColor()
        
        return contr
    }()
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .whiteColor()
        setCameraView()
    }
    
    func setCameraView() -> Void {
        self.pagerContr.dataSource = self
        self.pagerContr.delegate = self
        let cameraController = viewControllerAtIndex(0)
        let viewControllers = [cameraController]
        pagerContr.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: nil)
        
        // Change the size of page view controller
        pagerContr.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        self.addChildViewController(pagerContr)
        self.view.addSubview(pagerContr.view)
        self.pagerContr.didMoveToParentViewController(self)
    }
    
    //MARK: UIPageViewControllerDelegate, UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if index != 2 {
            index += 1
            return viewControllerAtIndex(index)
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if index != 0 {
            index -= 1
            return viewControllerAtIndex(index)
        }
        
        return nil
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 3
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    //MARK: Helpers
    
    func viewControllerAtIndex(index: Int) -> UIViewController {
        if index == 0 {
            return cameraContr
        } else if index == 1 {
            return middleViewController
        } else if index == 2 {
            return lastViewController
        }
        
        return UIViewController.init(nibName: nil, bundle: nil)
    }

}

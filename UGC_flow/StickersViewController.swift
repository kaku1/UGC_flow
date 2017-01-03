//
//  StickersViewController.swift
//  UGC_flow
//
//  Created by Siddhant Saxena on 03/01/17.
//  Copyright © 2017 Siddhant Saxena. All rights reserved.
//

import UIKit

class StickersViewController: UIViewController {

    var pageIndex = 3
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func postAndShowFinal(sender: AnyObject) {
        let secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        //self.navigationController!.pushViewController(secondViewController, animated: true)
        self.parentViewController?.navigationController!.pushViewController(secondViewController, animated: true)
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

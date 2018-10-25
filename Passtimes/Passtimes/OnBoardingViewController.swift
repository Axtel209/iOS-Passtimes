//
//  OnBoardingViewController.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/25/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit

class OnBoardingViewController: UIViewController {

    //@IBOutlet var loginButton: UIButton!
    @IBOutlet weak var pageContainer: UIView!
    
    /* Member Variables */
    var pageViewController: UIPageViewController!
    var messages = ["Hello world", "Ciao"]

    override func viewDidLoad() {
        super.viewDidLoad()

        //loginButton.roundedCorners(radius: 7.5)
        pageViewControllerSetup()
    }

    func pageViewControllerSetup() {
        pageViewController = (self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController)
        self.pageViewController.dataSource = self

        //let pageContentViewController = self.viewControllerAtIndex(0)
        //self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)

        // Start from the first page
        let pageContentViewController = viewController(at: 0)
        self.pageViewController.setViewControllers([pageContentViewController!], direction: .forward, animated: true, completion: nil)


        /* We are substracting 30 because we have a start again button whose height is 30*/
        //self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height - 30)
        //self.addChildViewController(pageViewController)
        //self.view.addSubview(pageViewController.view)
        self.pageContainer.addSubview(pageViewController.view)
        //self.pageViewController.didMove(toParent: )
        //self.pageViewController.didMoveToParentViewController(self)
    }

    func viewController(at index : Int) -> UIViewController? {
        if((self.messages.count == 0) || (index >= self.messages.count)) {
            return nil
        }

        // Get pageContentViewController
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as! PageContentViewController

        // Set pageContent
        pageContentViewController.contentMessage = self.messages[index]

        return pageContentViewController
    }

}

extension OnBoardingViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // Get current pageIndex and add one
        var index = (viewController as! PageContentViewController).pageIndex!
        index += 1

        // If pageIndex is last don't change
        if(index >= self.messages.count){
            return nil
        }

        return self.viewController(at: index)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // Get current pageIndex and substract one
        var index = (viewController as! PageContentViewController).pageIndex!
        index -= 1

        if(index < 0){
            return nil
        }

        return self.viewController(at: index)
    }

}

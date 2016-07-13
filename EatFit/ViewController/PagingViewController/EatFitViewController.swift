//
//  EatFitViewcontroller.swift
//  Pager
//
//  Created by aleksey on 08.05.15.
//  Copyright (c) 2015 Aleksey Chernish. All rights reserved.
//

import UIKit

protocol EatFitViewControllerDataSource: class {
    func numberOfPagesForPagingViewController(_ controller: EatFitViewController) -> Int
    func chartColorForPage(_ index: Int, forPagingViewController controller: EatFitViewController) -> UIColor
    func percentageForPage(_ index: Int, forPagingViewController controller: EatFitViewController) -> Int
    func titleForPage(_ index: Int, forPagingViewController controller: EatFitViewController) -> String
    func descriptionForPage(_ index: Int, forPagingViewController controller: EatFitViewController) -> String
    func logoForPage(_ index: Int, forPagingViewController controller: EatFitViewController) -> UIImage
    func chartThicknessForPagingViewController(_ controller: EatFitViewController) -> CGFloat
}

class EatFitViewController : UIViewController {
    weak var dataSource: EatFitViewControllerDataSource!

    @IBOutlet
    weak var pageViewContainer: UIView!
    
    @IBOutlet
    weak var pageControl: EatFitPageControl!
    
    private var pageViewController: UIPageViewController = {
        let controller = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal, options:nil)
        
        return controller
    }()
    
    class func controller() -> EatFitViewController {
        return EatFitViewController(nibName: "EatFitViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageViewController.view.backgroundColor = UIColor.clear()
        pageViewContainer.tlk_addSubview(pageViewController.view, options: TLKAppearanceOptions.overlay)
        pageControl.pagesCount = dataSource.numberOfPagesForPagingViewController(self)
        pageControl.selectButton(0)
        reloadData()
    }
    
    func reloadData() {
        pageViewController.ac_setDidFinishTransition({ (pageController, viewController, idx) -> Void in
            self.pageControl.selectButton(Int(idx))
            let slide = viewController as! EatFitSlideViewController
            slide.animate()
        })
        
        var pages: [UIViewController] = Array()
        
        for idx in 0..<dataSource.numberOfPagesForPagingViewController(self) {
            let vc = EatFitSlideViewController(nibName:"EatFitSlideViewController", bundle: nil)
            vc.loadView()
            vc.chartTitle = dataSource.titleForPage(idx, forPagingViewController: self)
            vc.chartColor = dataSource.chartColorForPage(idx, forPagingViewController: self)
            vc.chartDescription = dataSource.descriptionForPage(idx, forPagingViewController: self)
            vc.percentage = dataSource.percentageForPage(idx, forPagingViewController: self)
            vc.logoImage = dataSource.logoForPage(idx, forPagingViewController: self)
            vc.chartThickness = dataSource.chartThicknessForPagingViewController(self)
            pages.append(vc)

            pageControl.selectButton(0)
            pageViewController.ac_setViewControllers(pages)
        }
    }
}

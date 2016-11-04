//
//  ViewController.swift
//  FriendsAbroad
//
//  Created by Vladimir on 03.11.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    let vkManager = VKDataManager.sharedInstance
    
    
    lazy var mapViewController: MapViewController = {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        self.addViewControllerAsChildViewController(viewController: viewController)
        return viewController
    }()
    
    lazy var listViewController: ListViewController = {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
        self.addViewControllerAsChildViewController(viewController: viewController)
        return viewController
    }()
    
    private func addViewControllerAsChildViewController(viewController: UIViewController){
        addChildViewController(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParentViewController: self)
    }
    
    private func updateView(){
        mapViewController.view.isHidden = !(segmentControl.selectedSegmentIndex == 0)
        listViewController.view.isHidden = (segmentControl.selectedSegmentIndex == 0)
        
        if !listViewController.view.isHidden{
            listViewController.reloadUI()
        }
        
    }
    
    @IBAction func selectionDidChanged(_ sender: UISegmentedControl) {
        updateView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if vkManager.checkState() != .authorized{
            vkManager.login()
        }
        
        segmentControl.selectedSegmentIndex = 0
        updateView()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


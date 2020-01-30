//
//  EventsMainViewController.swift
//  TripPlanner
//
//  Created by Hamster on 1/27/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import Foundation
import UIKit

class EventsMainViewController: UIViewController {
    // MARK: Properties
    let transition = MenuSlideInTransition()
    
    // MARK: Initializations
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Handlers
    @IBAction func didTapMenu(_ sender: UIBarButtonItem) {
        // Instantiate menu view controller
        guard let menuViewController = storyboard?.instantiateViewController(
            withIdentifier: "MenuViewController") as? MenuViewController else { return }
        
        menuViewController.didTapMenuButton = {
            selectedMenu in
            self.showNewController(selectedMenu)
        }
        
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        present(menuViewController, animated: true)
    }
    
    func showNewController(_ selectedMenu: MenuType) {
        var newViewController: UIViewController
        
        switch selectedMenu {
        case .events:
            newViewController = (storyboard?.instantiateViewController(
                withIdentifier: "EventsNavigationViewController"))!
        case .contacts:
            newViewController = (storyboard?.instantiateViewController(
                withIdentifier: "ContactsNavigationViewController"))!
        case .settings:
            newViewController = (storyboard?.instantiateViewController(
                withIdentifier: "SettingsNavigationViewController"))!
        }
        
        newViewController.modalPresentationStyle = .fullScreen
        present(newViewController, animated: false)
    }
}

extension EventsMainViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}

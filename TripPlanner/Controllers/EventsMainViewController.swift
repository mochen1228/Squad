//
//  EventsMainViewController.swift
//  TripPlanner
//
//  Created by Hamster on 1/27/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

/*
 EventsMainViewController
 A view controller that manages events page
 This is the main VC of all VC associated with events
*/

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
        // Executes when side menu button icon is tapped
        
        // Instantiate menu view controller
        guard let menuViewController = storyboard?.instantiateViewController(
            withIdentifier: "MenuViewController") as? MenuViewController else { return }
        
        // Set the closure value of menu VC
        menuViewController.didTapMenuButton = {
            selectedMenu in
            self.showNewController(selectedMenu)
        }
        
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        present(menuViewController, animated: true)
    }
    
    func showNewController(_ selectedMenu: MenuType) {
        // Takes selected menu as input and present corresponding VC

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
        
        // Present VC in fullscreen
        newViewController.modalPresentationStyle = .fullScreen
        present(newViewController, animated: false)
    }
}

extension EventsMainViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // Asks your delegate for the transition animator object to use
        // when presenting a view controller
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}

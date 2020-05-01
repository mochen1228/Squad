//
//  SettingsTableViewController.swift
//  Pods
//
//  Created by Hamster on 4/1/20.
//
// References:
// https://medium.com/@novall/how-to-cleanly-hide-a-uitableview-section-4e11d43741e3


import UIKit
import Firebase

class SettingsTableViewController: UITableViewController {
    let transition = MenuSlideInTransition()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        loadProfileInfo()
        super.viewDidLoad()
    }
    // Hello
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var firstLastNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadProfileInfo()
    }
    
    func loadProfileInfo() {
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;

        self.firstLastNameLabel.text = appDelegate.currentUser.firstname + " " + appDelegate.currentUser.lastname
        self.usernameLabel.text = appDelegate.currentUser.username
    }
    
    @IBAction func didTapMenuButton(_ sender: Any) {
        // Executes when side menu button icon is tapped
        print("Menu tapped")
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


extension SettingsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.section)
        switch indexPath.section {
        case 3:
            // Log out
            do {
                try Auth.auth().signOut()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let toVC = storyboard.instantiateViewController(withIdentifier: "WelcomeScreenViewController")
                toVC.modalPresentationStyle = .fullScreen
                present(toVC, animated: false)
            } catch {
                print("Cannot logout")
            }
        default:
            return
        }
        
        // print(indexPath.section)
    }
}

extension SettingsTableViewController: UIViewControllerTransitioningDelegate {
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

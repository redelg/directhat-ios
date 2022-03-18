//
//  ViewController.swift
//  Direct Chat
//
//  Created by Renzo Delgado on 18/02/22.
//

import UIKit

class ViewController: UITabBarController {

    let context = (UIApplication.shared.delegate
                   as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.items?[0].title = LocalizedString.getString(value: "Chat")
        tabBar.items?[1].title = LocalizedString.getString(value: "History")
        tabBar.items?[2].title = LocalizedString.getString(value: "Messages")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shouldShowOnboarding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func shouldShowOnboarding() {
        let userDetaults = UserDefaults.standard
        if !userDetaults.bool(forKey: "onboarding") {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .horizontal
            present(OnboardingViewController(collectionViewLayout: flowLayout), animated: true, completion: {
                userDetaults.set(true, forKey: "onboarding")
                self.initMessage()
            })
        }
    }
    
    private func initMessage() {
        let message = Message(context: context)
        message.title = "Hi!"
        message.content = "Hello"
        message.selected = true
        do {
            try context.save()
        }
        catch {
            print("error")
        }
    }
    
    func gotoAddMessage(message: Message? = nil) {
        let vc = AddEditMessageViewController()
        vc.message = message
        self.navigationController?.pushViewController(vc, animated: true)
    }
 
    func gotoDialMessage(message: Message? = nil) {
        let vc = DialViewController()
        vc.message = message
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


//
//  AddEditMessageViewController.swift
//  Direct Chat
//
//  Created by Renzo Delgado on 14/03/22.
//

import UIKit

class AddEditMessageViewController: UIViewController {
    
    var message: Message? = nil
    
    let context = (UIApplication.shared.delegate
                   as! AppDelegate).persistentContainer.viewContext
    
    private var myView: AddEditMessageView? { view as? AddEditMessageView }
    
    override func loadView() {
        view = AddEditMessageView(with: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        view.backgroundColor = .systemGroupedBackground
        setNavAppearance()
        addUpdateConfig()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func addUpdateConfig() {
        if message == nil {
            title = LocalizedString.getString(value: "Add-Message")
            myView?.addEditButton.addTarget(self, action: #selector(saveMessage), for: .touchUpInside)
        } else {
            title = LocalizedString.getString(value: "Edit-Message")
            myView?.titleField.text = message?.title
            myView?.messageTextView.text = message?.content
            myView?.addEditButton.addTarget(self, action: #selector(editMessage), for: .touchUpInside)
        }
    }

    func setNavAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .mainGreen
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func editMessage() {
        if validateData() {
            do {
                message?.title = myView!.titleField.text
                message?.content = myView!.messageTextView.text
                try context.save()
                navigationController?.popViewController(animated: true)
            } catch { }
        }
    }
    
    @objc private func saveMessage() {
        if validateData() {
            do {
                let item = Message(context: context)
                item.title = myView!.titleField.text
                item.content = myView!.messageTextView.text
                try context.save()
                navigationController?.popViewController(animated: true)
            } catch { }
        }
    }
    
    private func validateData() -> Bool {
        if myView!.titleField.text!.isEmpty {
            let alert = UIAlertController(title:  "", message: LocalizedString.getString(value: "Title-Not-Empty"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        if myView!.messageTextView.text.isEmpty {
            let alert = UIAlertController(title: "", message: LocalizedString.getString(value: "Message-Not-Empty"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    @objc private func dismissKeyboard() {
        myView?.messageTextView.resignFirstResponder()
        myView?.titleField.resignFirstResponder()
    }
}

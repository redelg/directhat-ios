//
//  MessagesViewController.swift
//  Direct Chat
//
//  Created by Renzo Delgado on 11/03/22.
//

import UIKit

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    let context = (UIApplication.shared.delegate
                   as! AppDelegate).persistentContainer.viewContext
    private var myView: MessagesView? { view as? MessagesView }
    private var items: [Message] = []
    private var searchedItems: [Message] = []
    private var searching = false
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func loadView() {
        view = MessagesView(with: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavAppearance()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateItems()
    }
    
    func setup() {
        self.navigationItem.title = LocalizedString.getString(value: "Predefined-Messages")
        myView?.searchBar.delegate = self
        myView?.tableView.delegate = self
        myView?.tableView.dataSource = self
        addButton.target = self
        addButton.action = #selector(addItem)
    }

    //Mark:- TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var tempItems: [Message] = []
        if searching {
            tempItems = searchedItems
        } else {
            tempItems = items
        }
        if tempItems.count == 0 {
            myView?.tableView.setEmptyMessage(LocalizedString.getString(value: "No-History"))
        } else {
            myView?.tableView.restore()
        }
        return tempItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tempItems: [Message] = []
        if searching {
            tempItems = searchedItems
        } else {
            tempItems = items
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as! MessageTableViewCell
        cell.title.text = tempItems[indexPath.row].title
        cell.content.text = tempItems[indexPath.row].content
        cell.share.addTarget(self, action: #selector(shareText(sender:)), for: .touchUpInside)
        cell.share.tag = indexPath.row
        //cell.dial.addTarget(self, action: #selector(openWhatsapp(sender:)), for: .touchUpInside)
        cell.dial.addTarget(self, action: #selector(sendDialMessage(sender:)), for: .touchUpInside)
        cell.dial.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var tempItems: [Message] = []
        if searching {
            tempItems = searchedItems
        } else {
            tempItems = items
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        if let parentVc = self.parent?.parent {
            if let parentVC = parentVc as? ViewController {
                parentVC.gotoAddMessage(message: tempItems[indexPath.row])
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        var tempItems: [Message] = []
        if searching {
            tempItems = searchedItems
        } else {
            tempItems = items
        }
        
        if editingStyle == .delete {
            if searching {
                searchedItems.remove(at: indexPath.row)
            } else {
                items.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            deleteChatHistory(item: tempItems[indexPath.row])
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    //Mark:- SearchBar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedItems = items.filter { $0.title!.lowercased().prefix(searchText.count) == searchText.lowercased() }
        searching = true
        myView?.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        myView?.searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        myView?.searchBar.setShowsCancelButton(false, animated: true)
        myView?.searchBar.resignFirstResponder()
        myView?.tableView.reloadData()
    }
    
    private func updateItems() {
        do {
            self.items = try context.fetch(Message.fetchRequest())
            myView?.tableView.reloadData()
        }
        catch {
            print("error")
        }
    }
    
    private func deleteChatHistory(item: Message) {
        self.context.delete(item)
        do {
            try self.context.save()
        }
        catch {
            print("Error")
        }
        updateItems()
    }
    
    @objc private func shareText(sender: UIButton) {
        let item = self.items[sender.tag]
        let textToShare = "\(item.content ?? "")"
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc private func addItem() {
        if let parentVc = self.parent?.parent {
            if let parentVC = parentVc as? ViewController {
                parentVC.gotoAddMessage()
            }
        }
    }
    
    @objc private func sendDialMessage(sender: UIButton) {
        if let parentVc = self.parent?.parent {
            if let parentVC = parentVc as? ViewController {
                let item = self.items[sender.tag]
                parentVC.gotoDialMessage(message: item)
            }
        }
    }
}

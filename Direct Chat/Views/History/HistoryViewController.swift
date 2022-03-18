//
//  HistoryViewController.swift
//  Direct Chat
//
//  Created by Renzo Delgado on 4/03/22.
//

import UIKit
import GoogleMobileAds
import CoreData

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    let context = (UIApplication.shared.delegate
                   as! AppDelegate).persistentContainer.viewContext
    
    var bannerView: GADBannerView!

    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = LocalizedString.getString(value: "Search")
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.keyboardType = .phonePad
        return sb
    }()
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        let tableNib = UINib(nibName: "HistoryTableViewCell", bundle: nil)
        tv.register(tableNib, forCellReuseIdentifier: "HistoryTableViewCell")
        return tv
    }()
    
    var items: [Chat] = []
    var searchedItems: [Chat] = []
    var searching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LocalizedString.getString(value: "History")
        setup()
        setViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateItems()
    }
    
    func setup() {
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var tempItems: [Chat] = []
        if searching {
            tempItems = searchedItems
        } else {
            tempItems = items
        }
        
        if tempItems.count == 0 {
            self.tableView.setEmptyMessage(LocalizedString.getString(value: "No-History"))
        } else {
            self.tableView.restore()
        }
        return tempItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tempItems: [Chat] = []
        if searching {
            tempItems = searchedItems
        } else {
            tempItems = items
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
        let item = tempItems[indexPath.row]
        cell.number.text = item.numberFormat
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy hh:mm a"
        cell.timestamp.text = dateFormatter.string(from: item.timestamp ?? Date())
        cell.shareButton.addTarget(self, action: #selector(shareChatHistory(sender:)), for: .touchUpInside)
        cell.shareButton.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        openWhatsapp(phoneNumber: self.items[indexPath.row].number ?? "")
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        var tempItems: [Chat] = []
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
        if searchText.isEmpty {
            searching = false
            tableView.reloadData()
            return
        }
        searchedItems = items.filter { $0.number!.contains(searchText.lowercased()) }
        searching = true
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    
    @objc private func shareChatHistory(sender: UIButton) {
        let item = self.items[sender.tag]
        let textToShare = "https://wa.me/\(item.number ?? "")"
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func deleteChatHistory(item: Chat) {
        self.context.delete(item)
        do {
            try self.context.save()
        }
        catch {
            print("Error")
        }
        updateItems()
    }
    
    private func updateItems() {
        do {
            self.items = try context.fetch(Chat.fetchRequest())
            tableView.reloadData()
        }
        catch {
            print("error")
        }
    }
    
    func openWhatsapp(phoneNumber: String) {
        let url = URL(string:"https://api.whatsapp.com/send?phone=\(phoneNumber)")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

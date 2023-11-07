//
//  PremiumViewController.swift
//  Direct Chat
//
//  Created by Renzo Delgado on 20/04/22.
//

import UIKit
import StoreKit

struct PremiumOption {
    let title: String
    let subtitle: String
    let icon: UIImage
}

class PremiumViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    private var options = [PremiumOption]()
    let userDetaults = UserDefaults.standard

    var adProduct: SKProduct?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        SKPaymentQueue.default().add(self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.roundCorners(.allCorners, radius: 8)
        navigationBar.topItem?.title = LocalizedString.getString(value: "Premium-Version")
        setOptions()
        purchaseButton.setTitle("\(adProduct!.priceLocale.currencySymbol ?? "") \( appendString(data: adProduct!.price.doubleValue))", for: .normal)
        purchaseButton.addTarget(self, action: #selector(doPayment), for: .touchUpInside)
    }
    
    func setOptions() {
        options = [
            PremiumOption(title: LocalizedString.getString(value: "Remove-Ads"),
                          subtitle: LocalizedString.getString(value: "Remove-Ads-Detail"),
                          icon: UIImage(systemName: "rectangle.on.rectangle")!),
            PremiumOption(title: LocalizedString.getString(value: "Single-Payment"),
                          subtitle: LocalizedString.getString(value: "Single-Payment-Detail"),
                          icon: UIImage(systemName: "creditcard")!),
            PremiumOption(title: LocalizedString.getString(value: "Support-Developers"),
                          subtitle: LocalizedString.getString(value: "Support-Developers-Detail"),
                          icon: UIImage(systemName: "bolt.heart")!)
        ]
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PremiumCell", for: indexPath)
        var cellConfig = cell.defaultContentConfiguration()
        cellConfig.textProperties.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        cellConfig.textProperties.color = .textColor
        cellConfig.secondaryTextProperties.font = UIFont.systemFont(ofSize: 13, weight: .light)
        cellConfig.secondaryTextProperties.color = .textColor
        cellConfig.text = options[indexPath.row].title
        cellConfig.secondaryText = options[indexPath.row].subtitle
        cellConfig.image = options[indexPath.row].icon.withTintColor(.mainGreen, renderingMode: .alwaysOriginal)
        cell.contentConfiguration = cellConfig
        cell.contentView.layoutMargins = UIEdgeInsets.init(top: 30, left: 15, bottom: 30, right: 15)
        if indexPath.row == options.count - 1 {
            cell.separatorInset = UIEdgeInsets.init(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
        }
        return cell
    }

}


extension PremiumViewController: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach({
            switch $0.transactionState {
            case .purchased:
                showPurchasedAlert()
                SKPaymentQueue.default().finishTransaction($0)
                SKPaymentQueue.default().remove(self)
                break
            case .failed:
                print("Failed")
                break
            default:
                break
            }
        })
    }
    
    @objc func doPayment() {
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: adProduct!)
            SKPaymentQueue.default().add(payment)
        } else {
            showNoPaymentMethodError()
        }
    }
    
    func showPurchasedAlert() {
        userDetaults.set(true, forKey: "premium")
        let alert = UIAlertController(title:  LocalizedString.getString(value: "Purchased"), message: LocalizedString.getString(value: "Purchased-Detail"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showNoPaymentMethodError() {
        let alert = UIAlertController(title:  LocalizedString.getString(value: "No-Payment"), message: LocalizedString.getString(value: "No-Payment-Detail"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func appendString(data: Double) -> String { // changed input type of data
        let value = data
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2 // for float
        formatter.maximumFractionDigits = 2 // for float
        formatter.minimumIntegerDigits = 1
        formatter.paddingPosition = .afterPrefix
        formatter.paddingCharacter = "0"
        return formatter.string(from: NSNumber(floatLiteral: value))! // here double() is not required as data is already double
    }
    
}

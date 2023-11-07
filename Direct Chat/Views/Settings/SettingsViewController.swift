//
//  SettingsViewController.swift
//  Direct Chat
//
//  Created by Renzo Delgado on 18/04/22.
//

import UIKit
import StoreKit
import SafariServices

struct Section {
    let title: String
    var footer: String? = nil
    let options: [SettingOption]
}

struct SettingOption {
    let title: String
    let icon: UIImage
    let handler: (() -> Void)
}

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    private var sections = [Section]()
    private var adProduct: SKProduct?
    private var isLoading = false
    let userDetaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        SKPaymentQueue.default().add(self)
        setNavAppearance()
        self.navigationItem.title = LocalizedString.getString(value: "Settings")
        tableView.delegate = self
        tableView.dataSource = self
        setSettings()
    }

    private func setSettings() {
        sections.append(Section(title: "PREMIUM", options: [
            SettingOption(title: LocalizedString.getString(value: "Get-Premium"), icon: UIImage(systemName: "bag")!, handler: fetchProduct),
            SettingOption(title: LocalizedString.getString(value: "Restore-Premium"), icon: UIImage(systemName: "ticket")!, handler: restorePurchase),
        ]))
        sections.append(Section(title: LocalizedString.getString(value: "About"),
                                footer: LocalizedString.getString(value: "Not-Affiliated"),
                                options: [
            SettingOption(title: LocalizedString.getString(value: "Rate-Us"), icon: UIImage(systemName: "star")!, handler: rateApp),
            SettingOption(title: LocalizedString.getString(value: "Share-App"), icon: UIImage(systemName: "paperplane")!, handler: shareApp),
            SettingOption(title: LocalizedString.getString(value: "Privacy-Policy"), icon: UIImage(systemName: "exclamationmark.shield")!, handler: privacyPolicy),
            SettingOption(title: LocalizedString.getString(value: "Terms"), icon: UIImage(systemName: "info.circle")!, handler: termsConditions)
        ]))
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        var cellConfig = cell.defaultContentConfiguration()
        cellConfig.textProperties.font = UIFont.systemFont(ofSize: 16, weight: .light)
        cellConfig.textProperties.color = .textColor
        cellConfig.text = sections[indexPath.section].options[indexPath.row].title
        cellConfig.image = sections[indexPath.section].options[indexPath.row].icon.withTintColor(.mainGreen, renderingMode: .alwaysOriginal)
        cell.contentConfiguration = cellConfig
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        sections[indexPath.section].options[indexPath.row].handler()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        sections[section].footer
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
    }
    
}

extension SettingsViewController: SKProductsRequestDelegate, SKPaymentTransactionObserver  {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.spinner.isHidden = true
            if let product = response.products.first {
                self.adProduct = product
                self.gotoPremiumVersion()
            }
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.spinner.isHidden = true
        }
    }
    
    func fetchProduct() {
        if isLoading { return }
        if adProduct != nil {
            gotoPremiumVersion()
            return
        }
        let request = SKProductsRequest(productIdentifiers: ["com.codergang.directchat.remove_ads"])
        request.delegate = self
        request.start()
        isLoading = true
        spinner.isHidden = false
    }
    
    func gotoPremiumVersion() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PremiumViewController") as! PremiumViewController
        vc.adProduct = self.adProduct
        self.navigationController?.parent?.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func restorePurchase() {
        if isLoading { return }
        if SKPaymentQueue.canMakePayments() {
            isLoading = true
            spinner.isHidden = false
            SKPaymentQueue.default().restoreCompletedTransactions()
        } else {
            showFailedRestoreAlert()
        }
    }
    
    func rateApp() {
        guard let writeReviewURL = URL(string: "https://apps.apple.com/app/id1613078858?action=write-review")
                else { fatalError("Expected a valid URL") }
            UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
    }
    
    func shareApp() {
        let textToShare = "\(LocalizedString.getString(value: "Share-App-Message"))https://apps.apple.com/app/id1613078858"
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func privacyPolicy() {
        guard let url = URL(string: "https://codergangteam.com/?page_id=3")
                else { fatalError("Expected a valid URL") }
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
    }
    
    func termsConditions() {
        guard let url = URL(string: "https://codergangteam.com/?page_id=10")
                else { fatalError("Expected a valid URL") }
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
    }
    
    // RESTORE
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        isLoading = false
        spinner.isHidden = true
        showFailedRestoreAlert()
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        isLoading = false
        spinner.isHidden = true
        if let transaction = transactions.first {
            switch transaction.transactionState {
            case .restored:
                showRestoredAlert()
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                break
            case .failed:
                showFailedRestoreAlert()
                break
            default:
                showFailedRestoreAlert()
                break
            }
        }
    }
    
    func showRestoredAlert() {
        userDetaults.set(true, forKey: "premium")
        let alert = UIAlertController(title:  LocalizedString.getString(value: "Restored"), message: LocalizedString.getString(value: "Restored-Detail"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showFailedRestoreAlert() {
        let alert = UIAlertController(title:  "Error", message: LocalizedString.getString(value: "Error-Restored"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

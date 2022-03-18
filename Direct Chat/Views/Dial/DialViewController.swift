//
//  DialViewController.swift
//  Direct Chat
//
//  Created by Renzo Delgado on 28/02/22.
//

import UIKit
import CountryPicker
import GoogleMobileAds
import KMPlaceholderTextView

class DialViewController: UIViewController, CountryPickerDelegate, UITextFieldDelegate {
    
    var message: Message? = nil
    
    let userDetaults = UserDefaults.standard

    let context = (UIApplication.shared.delegate
                   as! AppDelegate).persistentContainer.viewContext
    
    lazy var countryPicker: CountryPickerViewController = {
        let vc = CountryPickerViewController()
        if userDetaults.string(forKey: "country") != nil {
            vc.selectedCountry = userDetaults.string(forKey: "country") ?? "US"
        } else {
            vc.selectedCountry = NSLocale.current.regionCode ?? "US"
        }
        return vc
    }()
    
    let messageTextView: KMPlaceholderTextView = {
        let tv = KMPlaceholderTextView()
        tv.placeholder = LocalizedString.getString(value: "Enter-Message")
        tv.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        tv.textContainerInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        tv.backgroundColor = .white
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isEditable = false
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.cornerRadius = 5
        return tv
    }()
    
    lazy var countryButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(showCountryPicker), for: .touchUpInside)
        let phoneCode = CountryManager.shared.getCountries().filter({ $0.isoCode == countryPicker.selectedCountry }).first?.phoneCode ?? "1"
        button.setTitle("\(countryPicker.selectedCountry.getFlag()) \(countryPicker.selectedCountry) +\(phoneCode)", for: .normal)
        return button
    }()
    
    lazy var phoneTextView: UITextField = {
        let tv = UITextField()
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.layer.cornerRadius = 5
        tv.placeholder = "953 314 059"
        tv.textAlignment = .center
        tv.keyboardType = .phonePad
        return tv
    }()

    let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        v.isScrollEnabled = true
        return v
    }()
    
    let scrollContainerView = UIView()
    
    lazy var countryNumberStackView = UIStackView(arrangedSubviews: [countryButton, phoneTextView])

    var bannerView: GADBannerView!
    
    var startChatButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitle(LocalizedString.getString(value: "Start-Chat"), for: .normal)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .mainGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LocalizedString.getString(value: "Chat")
        setNavAppearance()
        createLayout()
        countryPicker.delegate = self
        phoneTextView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func setNavAppearance() {
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
    
    func countryPicker(didSelect country: Country) {
        countryPicker.selectedCountry = country.isoCode
        countryButton.setTitle("\(countryPicker.selectedCountry.getFlag()) \(countryPicker.selectedCountry) +\(country.phoneCode)", for: .normal)
        userDetaults.set(country.isoCode, forKey: "country")
    }
    
    @objc private func dismissKeyboard() {
        phoneTextView.resignFirstResponder()
        messageTextView.resignFirstResponder()
    }
    
    @objc func showCountryPicker() {
        present(countryPicker, animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < 15
    }
    
}

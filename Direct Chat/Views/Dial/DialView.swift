//
//  DialView.swift
//  Direct Chat
//
//  Created by Renzo Delgado on 28/02/22.
//

import GoogleMobileAds
import Foundation
import UIKit
import CountryPicker

extension DialViewController {
    
    func createLayout() {
        addScrollView()
        addStackView()
        addDialButtons()
        
        if message != nil {
            messageTextView.text = message?.content
            startChatButton.setTitle(LocalizedString.getString(value: "Send-Message"), for: .normal)
            startChatButton.addTarget(self, action: #selector(self.openWhatsappWithMessage), for: .touchUpInside)
        } else {
            startChatButton.addTarget(self, action: #selector(self.openWhatsapp), for: .touchUpInside)
        }
    }
    
    func addScrollView() {
        scrollContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContainerView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollContainerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollContainerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        scrollContainerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollContainerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
    }
    
    func addStackView() {
        countryNumberStackView.axis = .horizontal
        countryNumberStackView.distribution = .fill
        countryNumberStackView.spacing = 5
        scrollContainerView.addSubview(countryNumberStackView)
        countryNumberStackView.translatesAutoresizingMaskIntoConstraints = false
        if Subscription.isActive {
            if message != nil {
                addMessageText()
                countryNumberStackView.topAnchor.constraint(equalTo: messageTextView.bottomAnchor, constant: 10).isActive = true
            } else {
                countryNumberStackView.topAnchor.constraint(equalTo: scrollContainerView.topAnchor, constant: 30).isActive = true
            }
        } else {
            addBannerAd()
            if message != nil {
                addMessageText()
                countryNumberStackView.topAnchor.constraint(equalTo: messageTextView.bottomAnchor, constant: 10).isActive = true
            } else {
                countryNumberStackView.topAnchor.constraint(equalTo: bannerView.bottomAnchor, constant: 30).isActive = true
            }
        }
        countryNumberStackView.trailingAnchor.constraint(equalTo: scrollContainerView.trailingAnchor, constant: -20).isActive = true
        countryNumberStackView.leadingAnchor.constraint(equalTo: scrollContainerView.leadingAnchor, constant: 20).isActive = true
        //countryNumberStackView.widthAnchor.constraint(equalTo: scrollContainerView.widthAnchor).isActive = true
        countryButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    func addMessageText() {
        view.addSubview(messageTextView)
        if Subscription.isActive {
            messageTextView.topAnchor.constraint(equalTo: scrollContainerView.topAnchor, constant: 20).isActive = true
        } else {
            messageTextView.topAnchor.constraint(equalTo: bannerView.bottomAnchor, constant: 20).isActive = true
        }
        messageTextView.trailingAnchor.constraint(equalTo: scrollContainerView.trailingAnchor, constant: -20).isActive = true
        messageTextView.leadingAnchor.constraint(equalTo: scrollContainerView.leadingAnchor, constant: 20).isActive = true
        messageTextView.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func addDialButtons() {
        let dialStackView = UIStackView()
        dialStackView.axis = .vertical
        dialStackView.distribution = .fillEqually
        dialStackView.spacing = 20
        
        scrollContainerView.addSubview(dialStackView)
        
        dialStackView.translatesAutoresizingMaskIntoConstraints = false
        dialStackView.topAnchor.constraint(equalTo: countryNumberStackView.bottomAnchor, constant: 40).isActive = true
        dialStackView.trailingAnchor.constraint(equalTo: countryNumberStackView.trailingAnchor, constant: -30).isActive = true
        dialStackView.leadingAnchor.constraint(equalTo: countryNumberStackView.leadingAnchor, constant: 30).isActive = true
        
        addFirstDialRow(dialStackView)
        addSecondDialRow(dialStackView)
        addThirdDialRow(dialStackView)
        addFourthDialRow(dialStackView)
        
        scrollContainerView.addSubview(startChatButton)
        startChatButton.topAnchor.constraint(equalTo: dialStackView.bottomAnchor, constant: 40).isActive = true
        startChatButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        startChatButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        startChatButton.centerXAnchor.constraint(equalTo: scrollContainerView.centerXAnchor).isActive = true
        startChatButton.bottomAnchor.constraint(equalTo: scrollContainerView.bottomAnchor, constant: -20).isActive = true

    }
    
    func addFirstDialRow(_ dialStackView: UIStackView) {
        let button1 = generateDialButton(number: 1)
        let button2 = generateDialButton(number: 2)
        let button3 = generateDialButton(number: 3)
        let firstDialRowStackView = UIStackView(arrangedSubviews: [
            button1,
            button2,
            button3
        ])
        firstDialRowStackView.axis = .horizontal
        firstDialRowStackView.distribution = .equalSpacing
        firstDialRowStackView.translatesAutoresizingMaskIntoConstraints = false
        dialStackView.addArrangedSubview(firstDialRowStackView)
        
        button1.heightAnchor.constraint(equalToConstant: 70).isActive = true
        button1.widthAnchor.constraint(equalToConstant: 70).isActive = true
        button2.heightAnchor.constraint(equalToConstant: 70).isActive = true
        button2.widthAnchor.constraint(equalToConstant: 70).isActive = true
        button3.heightAnchor.constraint(equalToConstant: 70).isActive = true
        button3.widthAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    func addSecondDialRow(_ dialStackView: UIStackView) {
        let button1 = generateDialButton(number: 4)
        let button2 = generateDialButton(number: 5)
        let button3 = generateDialButton(number: 6)
        let firstDialRowStackView = UIStackView(arrangedSubviews: [
            button1,
            button2,
            button3
        ])
        firstDialRowStackView.axis = .horizontal
        firstDialRowStackView.distribution = .equalSpacing
        firstDialRowStackView.translatesAutoresizingMaskIntoConstraints = false
        dialStackView.addArrangedSubview(firstDialRowStackView)
        
        button1.heightAnchor.constraint(equalToConstant: 70).isActive = true
        button1.widthAnchor.constraint(equalToConstant: 70).isActive = true
        button2.heightAnchor.constraint(equalToConstant: 70).isActive = true
        button2.widthAnchor.constraint(equalToConstant: 70).isActive = true
        button3.heightAnchor.constraint(equalToConstant: 70).isActive = true
        button3.widthAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    func addThirdDialRow(_ dialStackView: UIStackView) {
        let button1 = generateDialButton(number: 7)
        let button2 = generateDialButton(number: 8)
        let button3 = generateDialButton(number: 9)
        let firstDialRowStackView = UIStackView(arrangedSubviews: [
            button1,
            button2,
            button3
        ])
        firstDialRowStackView.axis = .horizontal
        firstDialRowStackView.distribution = .equalSpacing
        firstDialRowStackView.translatesAutoresizingMaskIntoConstraints = false
        dialStackView.addArrangedSubview(firstDialRowStackView)
        
        button1.heightAnchor.constraint(equalToConstant: 70).isActive = true
        button1.widthAnchor.constraint(equalToConstant: 70).isActive = true
        button2.heightAnchor.constraint(equalToConstant: 70).isActive = true
        button2.widthAnchor.constraint(equalToConstant: 70).isActive = true
        button3.heightAnchor.constraint(equalToConstant: 70).isActive = true
        button3.widthAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    func addFourthDialRow(_ dialStackView: UIStackView) {
        let button1 = generateDialButton(number: 0)
        let button2 = generateDialButton(number: 0)
        let button3 = generateDeleteButton()
        let firstDialRowStackView = UIStackView(arrangedSubviews: [
            button1,
            button2,
            button3
        ])
        firstDialRowStackView.axis = .horizontal
        firstDialRowStackView.distribution = .equalSpacing
        firstDialRowStackView.translatesAutoresizingMaskIntoConstraints = false
        dialStackView.addArrangedSubview(firstDialRowStackView)
        
        button1.heightAnchor.constraint(equalToConstant: 70).isActive = true
        button1.widthAnchor.constraint(equalToConstant: 70).isActive = true
        button2.heightAnchor.constraint(equalToConstant: 70).isActive = true
        button2.widthAnchor.constraint(equalToConstant: 70).isActive = true
        button3.heightAnchor.constraint(equalToConstant: 70).isActive = true
        button3.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        button1.alpha = 0
        button1.isEnabled = false
    }
    
    
    private func generateDialButton(number: Int) -> UIButton {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .dialBackgroundColor
        button.setTitle(String(number), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 35
        button.addTarget(self, action: #selector(addNumber(sender:)), for: .touchUpInside)
        return button
    }
    
    private func generateDeleteButton() -> UIButton {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setImage(UIImage(systemName: "delete.left.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(deleteNumber), for: .touchUpInside)
        button.imageView?.tintColor = .mainGreen
        return button
    }
    
    private func addBannerAd() {
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = Ads.chat_banner
        bannerView.rootViewController = self
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        scrollContainerView.addSubview(bannerView)
        bannerView.topAnchor.constraint(equalTo: scrollContainerView.topAnchor).isActive = true
        bannerView.centerXAnchor.constraint(equalTo: scrollContainerView.centerXAnchor).isActive = true
        
        // Step 2 - Determine the view width to use for the ad width.
        let frame = { () -> CGRect in
          // Here safe area is taken into account, hence the view frame is used
          // after the view has been laid out.
          if #available(iOS 11.0, *) {
            return view.frame.inset(by: view.safeAreaInsets)
          } else {
            return view.frame
          }
        }()
        let viewWidth = frame.size.width

        // Step 3 - Get Adaptive GADAdSize and set the ad view.
        // Here the current interface orientation is used. If the ad is being preloaded
        // for a future orientation change or different orientation, the function for the
        // relevant orientation should be used.
        bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        
        bannerView.load(GADRequest())
    }
    
    @objc func openWhatsapp() {
        let phoneNumber = phoneTextView.text
        guard let phoneNumber = phoneNumber else {
            return
        }
        let phoneCode = CountryManager.shared.getCountries().filter({ $0.isoCode == countryPicker.selectedCountry }).first?.phoneCode ?? "+1"
        let url = URL(string:"https://api.whatsapp.com/send?phone=\(phoneCode)\(phoneNumber)")!
        UIApplication.shared.open(url, options: [:], completionHandler: ({ success in
            if success {
                self.registerNumber()
            }
        }))
    }
    
    @objc private func openWhatsappWithMessage() {
        let phoneNumber = phoneTextView.text
        guard let phoneNumber = phoneNumber else {
            return
        }
        let phoneCode = CountryManager.shared.getCountries().filter({ $0.isoCode == countryPicker.selectedCountry }).first?.phoneCode ?? "+1"
        let url = URL(string:"https://wa.me/\(phoneCode)\(phoneNumber)?text=\(message!.content!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc private func addNumber(sender: UIButton) {
        if (phoneTextView.text ?? "").count > 14 { return }
        phoneTextView.text = "\(phoneTextView.text ?? "")\(sender.titleLabel?.text ?? "")"
    }
    
    @objc private func deleteNumber() {
        if (phoneTextView.text ?? "").count == 0 { return }
        phoneTextView.text = "\(phoneTextView.text?.dropLast() ?? "")"
    }
    
    func registerNumber() {
        let phoneNumber = phoneTextView.text
        guard let phoneNumber = phoneNumber else {
            return
        }
        let phoneCode = CountryManager.shared.getCountries().filter({ $0.isoCode == countryPicker.selectedCountry }).first?.phoneCode ?? "1"
        let newChat = Chat(context: self.context)
        newChat.number = "\(phoneCode)\(phoneNumber)"
        newChat.numberFormat = "+\(phoneCode) \(phoneNumber)"
        newChat.timestamp = Date()
        
        do {
            try self.context.save()
        }
        catch {
            print("Error")
        }
    }
    
}

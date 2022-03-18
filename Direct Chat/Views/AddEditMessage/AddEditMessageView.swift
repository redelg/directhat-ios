//
//  AddEditMessageView.swift
//  Direct Chat
//
//  Created by Renzo Delgado on 15/03/22.
//

import Foundation
import UIKit
import KMPlaceholderTextView
import GoogleMobileAds

extension AddEditMessageViewController {
    
    final class AddEditMessageView: UIView {
        
        weak var parent: UIViewController? = nil
        
        let titleField: UITextField = {
            let tf = UITextField()
            tf.placeholder = LocalizedString.getString(value: "Enter-Title")
            tf.translatesAutoresizingMaskIntoConstraints = false
            tf.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            tf.setLeftPaddingPoints(20)
            tf.setRightPaddingPoints(20)
            tf.backgroundColor = .white
            return tf
        }()
        
        let messageTextView: KMPlaceholderTextView = {
            let tv = KMPlaceholderTextView()
            tv.placeholder = LocalizedString.getString(value: "Enter-Message")
            tv.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            tv.textContainerInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
            tv.backgroundColor = .white
            tv.translatesAutoresizingMaskIntoConstraints = false
            return tv
        }()
        
        let bannerView: GADBannerView = {
            let banner = GADBannerView(adSize: GADAdSizeBanner)
            banner.adUnitID = Ads.add_edit_banner
            banner.translatesAutoresizingMaskIntoConstraints = false
            return banner
        }()
        
        let addEditButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = 10
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            button.setTitle(LocalizedString.getString(value: "Save"), for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            return button
        }()
        
        required init(with parent: UIViewController) {
            super.init(frame: .zero)
            self.parent = parent
            configureView()
        }
        
        required init?(coder: NSCoder) {
            fatalError("not implemented")
        }
        
        private func configureView() {
            addTitleField()
            addMessageField()
            addAddEditButton()
        }
        
        private func addTitleField() {
            addSubview(titleField)
            NSLayoutConstraint.activate([
                titleField.topAnchor.constraint(equalTo: topAnchor, constant: 20),
                titleField.trailingAnchor.constraint(equalTo: trailingAnchor),
                titleField.leadingAnchor.constraint(equalTo: leadingAnchor),
                titleField.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        
        private func addMessageField() {
            addSubview(messageTextView)
            NSLayoutConstraint.activate([
                messageTextView.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 20),
                messageTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
                messageTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
                messageTextView.heightAnchor.constraint(equalToConstant: 200)
            ])
        }
        
        private func addAddEditButton() {
            addSubview(addEditButton)
            
            if Subscription.isActive {
                addEditButton.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
            } else {
                addBanner()
                addEditButton.bottomAnchor.constraint(equalTo: bannerView.topAnchor, constant: -20).isActive = true
            }
            
            NSLayoutConstraint.activate([
                addEditButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                addEditButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                addEditButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        
        private func addBanner() {
            resizeBanner()
            addSubview(bannerView)
            NSLayoutConstraint.activate([
                bannerView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
                bannerView.leadingAnchor.constraint(equalTo: leadingAnchor),
                bannerView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        }
        
        private func resizeBanner() {
            bannerView.rootViewController = parent
            let frame = { () -> CGRect in
              if #available(iOS 11.0, *) {
                  return self.frame.inset(by: self.safeAreaInsets)
              } else {
                  return self.frame
              }
            }()
            let viewWidth = frame.size.width
            bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
            bannerView.load(GADRequest())
        }
        
    }
    
}

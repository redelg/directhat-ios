//
//  MessagesView.swift
//  Direct Chat
//
//  Created by Renzo Delgado on 11/03/22.
//
import UIKit
import GoogleMobileAds

extension MessagesViewController {
    
    //View
    final class MessagesView: UIView {
        
        weak var parent: UIViewController? = nil
        
        let tableView: UITableView = {
            let tv = UITableView(frame: .zero, style: .plain)
            tv.translatesAutoresizingMaskIntoConstraints = false
            tv.backgroundColor = .white
            let tableNib = UINib(nibName: "MessageTableViewCell", bundle: nil)
            tv.register(tableNib, forCellReuseIdentifier: "MessageTableViewCell")
            return tv
        }()
        
        let searchBar: UISearchBar = {
            let sb = UISearchBar()
            sb.placeholder = LocalizedString.getString(value: "Search")
            sb.translatesAutoresizingMaskIntoConstraints = false
            return sb
        }()
        
        let bannerView: GADBannerView = {
            let banner = GADBannerView(adSize: GADAdSizeBanner)
            banner.adUnitID = Ads.messages_banner
            banner.translatesAutoresizingMaskIntoConstraints = false
            return banner
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
            backgroundColor = .white
            resizeBanner()
            addSubview(searchBar)
            addSubview(tableView)
            if Subscription.isActive {
                searchBar.topAnchor.constraint(equalTo: topAnchor).isActive = true
            } else {
                addSubview(bannerView)
                addBannerConstraints()
                searchBar.topAnchor.constraint(equalTo: bannerView.bottomAnchor).isActive = true
            }
            NSLayoutConstraint.activate([
                searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
                searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
                tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
                tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
        }
        
        private func addBannerConstraints() {
            NSLayoutConstraint.activate([
                bannerView.topAnchor.constraint(equalTo: topAnchor),
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
    
    
    //Extensions
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

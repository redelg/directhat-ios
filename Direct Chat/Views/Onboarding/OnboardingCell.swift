//
//  OnboardingCell.swift
//  Direct Chat
//
//  Created by Renzo Delgado on 25/02/22.
//

import Foundation
import UIKit

class OnboardingCell: UICollectionViewCell {
    
    public var item: OnboardingItem? {
        didSet {
            setupViews()
        }
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private let bottomContainer: UIView = {
        let bottomContainer = UIView()
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        bottomContainer.backgroundColor = .mainGreen
        return bottomContainer
    }()
    
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        descriptionLabel.textAlignment = .center
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private func setupViews() {
        addTitle()
        addImage()
        addDescriptionContainer()
        addDescriptionText()
    }
    
    private func addTitle() {
        addSubview(titleLabel)
        titleLabel.text = item?.title.uppercased()
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 100).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        titleLabel.sizeToFit()
    }
    
    private func addImage() {
        addSubview(imageView)
        imageView.image = UIImage(named: item?.image ?? "")
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: item?.margin ?? 0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: item?.size ?? 100).isActive = true
    }
    
    private func addDescriptionContainer() {
        addSubview(bottomContainer)
        bottomContainer.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bottomContainer.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottomContainer.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomContainer.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    private func addDescriptionText() {
        bottomContainer.addSubview(descriptionLabel)
        descriptionLabel.text = item?.description ?? ""
        descriptionLabel.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: 40).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor, constant: -40).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: bottomContainer.centerXAnchor).isActive = true
        descriptionLabel.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor, constant: -20).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomContainer.roundCorners([.topLeft, .topRight], radius: 20)
    }
}

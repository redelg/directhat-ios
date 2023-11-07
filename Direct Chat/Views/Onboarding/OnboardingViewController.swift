//
//  OnboardingViewController.swift
//  Direct Chat
//
//  Created by Renzo Delgado on 24/02/22.
//

import UIKit

class OnboardingViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let items: [OnboardingItem] = [
        OnboardingItem(image: "onboarding-book", title: LocalizedString.getString(value: "Onboarding-Title-1"), description: LocalizedString.getString(value: "Onboarding-Description-1"), size: 110, margin: 20),
        OnboardingItem(image: "Onboarding-Paper-Jet", title: LocalizedString.getString(value: "Onboarding-Title-2"), description: LocalizedString.getString(value: "Onboarding-Description-2"), size: 150, margin: 0),
        OnboardingItem(image: "Onboarding-Person", title: LocalizedString.getString(value: "Onboarding-Title-3"), description: LocalizedString.getString(value: "Onboarding-Description-3"), size: 200, margin: 20)
    ]
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.numberOfPages = 3
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPageIndicatorTintColor = .pageControlSelectedGreen
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private let nextButton: UIButton = {
        let nextButton = UIButton()
        nextButton.backgroundColor = .white
        let image = UIImage(systemName: "chevron.right")
        image?.withTintColor(.mainGreen)
        nextButton.tintColor = .mainGreen
        nextButton.setImage(image, for: .normal)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.layer.cornerRadius = 20
        return nextButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupPageControl()
        setupNextButton()
    }
    
    private func setupNextButton() {
        view.addSubview(nextButton)
        NSLayoutConstraint.activate([
            nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 40),
            nextButton.widthAnchor.constraint(equalToConstant: 40),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        nextButton.addTarget(self, action: #selector(self.handleNext), for: .touchUpInside)
    }
    
    private func setupCollectionView() {
        collectionView.register(OnboardingCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.backgroundColor = .white
        collectionView.backgroundView = UIImageView(image: UIImage(named: "onboarding-background"))
        collectionView.isPagingEnabled = true
    }
    
    private func setupPageControl() {
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 50),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func handleNext() {
        if pageControl.currentPage + 1 == 3 {
            dismiss(animated: true, completion: nil)
            return
        }
        let nextIndex = min(pageControl.currentPage + 1, items.count - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int(x / view.frame.width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! OnboardingCell
        cell.item = items[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
}

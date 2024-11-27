//
//  OnboardingViewController.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/13.
//

import Foundation
import UIKit

class OnboardingViewController: UIViewController {
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(OnboardingCell.self, forCellWithReuseIdentifier: OnboardingCell.identifier)
        return collectionView
    }()

    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .blue
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()

    lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.isHidden = true // Initially hidden
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        button.isHidden = true // Initially hidden
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let slides = [
        ("Find Jobs", "Personalized job recommendations tailored to your skills."),
        ("Build Your CV", "Generate and download a professional CV with ease."),
        ("Skill Challenges", "Complete gamified tasks to enhance your employability.")
    ]

    private var autoSlideTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        startAutoSlide()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }

    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(signUpButton)
        view.addSubview(signInButton)

        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        pageControl.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -20).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        signUpButton.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 10).isActive = true

        signInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        signInButton.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -10).isActive = true
    }

    @objc private func handleSignUp() {
        self.navigationController?.pushViewController(SignUpViewController(), animated: true)
    }

    @objc private func handleSignIn() {
        self.navigationController?.pushViewController(SignInViewController(), animated: true)
    }

    private func startAutoSlide() {
        autoSlideTimer?.invalidate() // Prevent duplicate timers
        autoSlideTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(autoSlideToNextPage), userInfo: nil, repeats: true)
    }

    private func stopAutoSlide() {
        autoSlideTimer?.invalidate()
        autoSlideTimer = nil
    }

    @objc private func autoSlideToNextPage() {
        guard slides.count > 1, collectionView.frame.width > 0 else { return }
        
        // Calculate the next page
        let nextIndex = (pageControl.currentPage + 1) % slides.count
        let indexPath = IndexPath(item: nextIndex, section: 0) // Define the indexPath
        
        // Scroll to the next item
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage = nextIndex

        print("Content Offset After Scroll: \(collectionView.contentOffset.x)")

        // Show or hide buttons on the last slide
        let isLastPage = nextIndex == slides.count - 1
        signUpButton.isHidden = !isLastPage
        signInButton.isHidden = !isLastPage
    }
}

extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCell.identifier, for: indexPath) as? OnboardingCell else {
            return UICollectionViewCell()
        }
        let slide = slides[indexPath.item]
        cell.configure(title: slide.0, description: slide.1)
        return cell
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopAutoSlide() // Stop auto-sliding when the user interacts
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        startAutoSlide() // Resume auto-sliding after user interaction
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.frame.width > 0 else { return } // Ensure frame width is valid
        let currentPage = Int((scrollView.contentOffset.x / scrollView.frame.width).rounded())
        pageControl.currentPage = currentPage

        // Show or hide buttons on the last slide
        let isLastPage = currentPage == slides.count - 1
        signUpButton.isHidden = !isLastPage
        signInButton.isHidden = !isLastPage
    }
}

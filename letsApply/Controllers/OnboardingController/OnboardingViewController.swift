//
//  OnboardingViewController.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/13.
//

import Foundation
import UIKit

class OnboardingViewController: UIViewController {

    var currentSlide: Int = 1

    lazy var onboardingCollectionView: UICollectionView = {
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
        return ButtonFacade.shared.createButton(
            title: "Sign Up",
            backgroundColor: .systemGray,
            target: self,
            action: #selector(handleSignUp)
        )
    }()

    lazy var signInButton: UIButton = {
        return ButtonFacade.shared.createButton(
            title: "Sign In",
            backgroundColor: .systemBlue,
            target: self,
            action: #selector(handleSignIn)
        )
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

    private func setupUI() {
        view.addSubview(onboardingCollectionView)
        view.addSubview(pageControl)
        view.addSubview(signUpButton)
        view.addSubview(signInButton)

        onboardingCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        onboardingCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        onboardingCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        onboardingCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        pageControl.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -20).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        signUpButton.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 10).isActive = true
        signUpButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        signInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        signInButton.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -10).isActive = true
        signInButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    @objc private func handleSignUp() {
        self.navigationController?.pushViewController(SignUpViewController(), animated: true)
    }

    @objc private func handleSignIn() {
        self.navigationController?.pushViewController(SignInViewController(), animated: true)
    }
}

// MARK: ScrollView + Timer
extension OnboardingViewController: UIScrollViewDelegate {

    private func startAutoSlide() {
        autoSlideTimer?.invalidate() // Prevent duplicate timers
        autoSlideTimer = Timer.scheduledTimer(
            timeInterval: 3.0,
            target: self,
            selector: #selector(autoSlideToNextPage),
            userInfo: nil,
            repeats: true
        )
    }

    @objc private func autoSlideToNextPage() {
        guard slides.count > 1 else { return }

        // Update UI
        onboardingCollectionView.scrollToItem(at: IndexPath(item: currentSlide, section: 0), at: .centeredHorizontally, animated: true)
        pageControl.currentPage = currentSlide

        // Increment Slides
        currentSlide += 1

        // Display/hide Buttons
        signUpButton.isHidden = currentSlide != slides.count
        signInButton.isHidden = currentSlide != slides.count

        // Reset Slide Count
        if currentSlide == slides.count {
            currentSlide = 0
        }
    }

    private func stopAutoSlide() {
        autoSlideTimer?.invalidate()
        autoSlideTimer = nil
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopAutoSlide() // Stop auto-sliding when the user interacts
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        startAutoSlide() // Resume auto-sliding after user interaction
    }
}

// MARK: Collection View
extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 700.0)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCell.identifier, for: indexPath) as? OnboardingCell else {
            return UICollectionViewCell()
        }
        let slide = slides[indexPath.item]
        cell.configure(title: slide.0, description: slide.1)
        return cell
    }
}
    /*
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.frame.width > 0 else { return } // Ensure frame width is valid
        let currentPage = Int((scrollView.contentOffset.x / scrollView.frame.width).rounded())
        pageControl.currentPage = currentPage

        // Show or hide buttons on the last slide
        let isLastPage = currentPage == slides.count - 1
        signUpButton.isHidden = !isLastPage
        signInButton.isHidden = !isLastPage
    }
    */


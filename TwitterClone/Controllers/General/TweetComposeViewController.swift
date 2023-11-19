//
//  TweetComposeViewController.swift
//  TwitterClone
//
//  Created by window1 on 2023/11/17.
//

import UIKit
import Combine

class TweetComposeViewController: UIViewController {
    
    private var viewModel = TweetComposeViewViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
    private let tweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .tweeterButton
        button.setTitle("계시하기", for: .normal)
        button.layer.cornerRadius = 17
        button.clipsToBounds = true
        button.isEnabled = false
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.7), for: .disabled)
        return button
    }()
    
    private let tweetContentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 10
        textView.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        textView.text = "무슨 일이 일어나고 있나요?"
        textView.textColor = .gray
        textView.font = .systemFont(ofSize: 17)
        return textView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(didTapToCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: tweetButton)
        tweetButton.addTarget(self, action: #selector(didTapToTweet), for: .touchUpInside)
        
        view.addSubview(tweetButton)
        view.addSubview(tweetContentTextView)
        tweetContentTextView.delegate = self
        configureConstraints()
        bindViews()
        
    }
    
    private func bindViews() {
        viewModel.$isValidToTweet
            .sink { [weak self] state in
                self?.tweetButton.isEnabled = state
            }
            .store(in: &subscriptions)
        viewModel.$shouldDismissComposer
            .sink { [weak self] success in
                if success {
                    self?.dismiss(animated: true)
                }
            }
            .store(in: &subscriptions)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getUserData()
        
    }
    
    @objc private func didTapToTweet() {
        print("TapTweetButton")
        viewModel.dispatchTweet()
        
    }
    
    @objc private func didTapToCancel() {
        dismiss(animated: true)
    }
    
    
    private func configureConstraints() {
        let tweetButtonConstraints = [
            tweetButton.widthAnchor.constraint(equalToConstant: 80),
            tweetButton.heightAnchor.constraint(equalToConstant: 35)
        ]
        
        let tweetContentTextView = [
            tweetContentTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            tweetContentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tweetContentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tweetContentTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.bottomAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(tweetButtonConstraints)
        NSLayoutConstraint.activate(tweetContentTextView)
    }
}

extension TweetComposeViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray {
            textView.textColor = .label
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "무슨 일이 일어나고 있나요?"
            textView.textColor = .gray
        }
    }
    
    
    
        func textViewDidChange(_ textView: UITextView) {
            viewModel.tweetContent = textView.text
            viewModel.validateToTweet()
        }
}

//
//  OnboardingViewController.swift
//  TwitterClone
//
//  Created by window1 on 2023/11/04.
//

import UIKit

class OnboardingViewController: UIViewController {

    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요 환영합니다"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("계정만들기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.backgroundColor = UIColor.tweeterButton
        button.layer.masksToBounds = true
        button.tintColor = .white
        button.layer.cornerRadius = 30
        return button
    }()
    
    private let promptLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = .gray
        label.text = "계정이 이미 있으신가요??"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.tintColor = UIColor.tweeterButton
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(welcomeLabel)
        view.addSubview(createAccountButton)
        view.addSubview(promptLabel)
        view.addSubview(loginButton)
        
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        
        configureConstrations()
    }
    
    @objc private func didTapLogin() {
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func didTapCreateAccount() {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func configureConstrations() {
        let welcomeLabelConstration = [
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        let createAccountButtonConstratins = [
            createAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createAccountButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            createAccountButton.widthAnchor.constraint(equalTo: welcomeLabel.widthAnchor, constant: -20),
            createAccountButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        let promptLabelConstraints = [
            promptLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            promptLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
        ]
        
        let loginButtonConstraints = [
            loginButton.centerYAnchor.constraint(equalTo: promptLabel.centerYAnchor),
            loginButton.leadingAnchor.constraint(equalTo: promptLabel.trailingAnchor, constant: 10)
        ]
        
        NSLayoutConstraint.activate(welcomeLabelConstration)
        NSLayoutConstraint.activate(createAccountButtonConstratins)
        NSLayoutConstraint.activate(promptLabelConstraints)
        NSLayoutConstraint.activate(loginButtonConstraints)
    }
}


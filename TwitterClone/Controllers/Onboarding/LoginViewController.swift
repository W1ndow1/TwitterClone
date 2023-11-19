//
//  LoginViewController.swift
//  TwitterClone
//
//  Created by window1 on 2023/11/09.
//

import UIKit
import Combine
class LoginViewController: UIViewController {
    
    private var viewModel = AuthenticationViewViewModel()
    private var subscriptions: Set<AnyCancellable> = []

    private let loginTitleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "로그인할 계정을 입력하세요"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    private let emailTextField: UITextField = {
       let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .emailAddress
        textField.attributedPlaceholder = NSAttributedString(
            string: "이메일",
            attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        return textField
    }()
    
    private let passwordTextField: UITextField = {
       let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "암호",
            attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("로그인", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor.tweeterButton
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.isEnabled = false
        return button
    }()
    
    //MARK: - Method
    
    @objc private func didChangeEmailField() {
        viewModel.email = emailTextField.text
        viewModel.validateAuthenticationForm()
    }
    
    @objc private func didChangePasswordField() {
        viewModel.password = passwordTextField.text
        viewModel.validateAuthenticationForm()
    }
    
    
    private func bindViews() {
        emailTextField.addTarget(self, action: #selector(didChangeEmailField), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(didChangePasswordField), for: .editingChanged)
        viewModel.$isAuthenticationFormValid.sink{ [weak self] validationState in
            self?.loginButton.isEnabled = validationState
        }
        .store(in: &subscriptions)
        
        viewModel.$user.sink { [weak self] user in
            guard user != nil else { return }
            guard let vc = self?.navigationController?.viewControllers.first as? OnboardingViewController else { return }
            vc.dismiss(animated: true)
        }
        .store(in: &subscriptions)
        
        viewModel.$error.sink { [weak self]  errorString in
            guard let error = errorString else { return }
            self?.presentAlert(with: error)
        }
        .store(in: &subscriptions)
    }
    
    private func presentAlert(with error: String) {
        let alert = UIAlertController(title: "오류", message: error, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(loginTitleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        configureConstraints()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapDismiss)))
        bindViews()
    }
    
    
    @objc private func didTapDismiss() {
        view.endEditing(true)
    }
    
    @objc private func didTapLogin() {
        viewModel.loginUser()
    }
    
    private func configureConstraints() {
        let loginTitleLabelConstrations = [
            loginTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ]
        
        let emailTextFieldConstrations = [
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.topAnchor.constraint(equalTo: loginTitleLabel.bottomAnchor, constant: 20),
            emailTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        let passwordTextFieldConstrations = [
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15),
            passwordTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        let loginButtonConstraints = [
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.widthAnchor.constraint(equalToConstant: 180),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        NSLayoutConstraint.activate(loginTitleLabelConstrations)
        NSLayoutConstraint.activate(emailTextFieldConstrations)
        NSLayoutConstraint.activate(passwordTextFieldConstrations)
        NSLayoutConstraint.activate(loginButtonConstraints)
    }
}

//
//  HomeViewController.swift
//  TwitterClone
//
//  Created by window1 on 2023/10/26.
//

import UIKit
import FirebaseAuth
import Combine

class HomeViewController: UIViewController {
    
    private var viewModel = HomeViewViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    private lazy var composeTweetButton: UIButton = {
        let button = UIButton(type: .system, primaryAction: UIAction { [weak self] _ in
            print("Tweet is being prepared")
            self?.navigateToTweetComposer()
        })
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .tweeterButton
        button.tintColor = .white
        let plusSign = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .bold))
        button.setImage(plusSign, for: .normal)
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        return button
    }()
    
    
    private func configureNavigationBar() {
        let size = 36
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.image = UIImage(named: "xLogo")
        
        let middleView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        middleView.addSubview(logoImageView)
        navigationItem.titleView = middleView
        
        let profileIamge = UIImage(systemName: "person.circle")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: profileIamge, style: .plain, target: self, action: #selector(didTapProfile))
    }
    @objc private func didTapProfile() {
        let vc = ProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private let timelineTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifer)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(timelineTableView)
        view.addSubview(composeTweetButton)
        timelineTableView.delegate = self
        timelineTableView.dataSource = self
        configureNavigationBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: self, action: #selector(didTapSignOut))
        bindViews()
    }
    @objc private func didTapSignOut() {
        try? Auth.auth().signOut()
        handleAuthentication()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        timelineTableView.frame = view.frame
        consfigureConstraints()
    }
    
    
    private func handleAuthentication() {
        if Auth.auth().currentUser == nil {
            let vc = UINavigationController(rootViewController: OnboardingViewController())
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false)
        }
    }
    
    private func navigateToTweetComposer() {
        let vc = UINavigationController(rootViewController: TweetComposeViewController())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        handleAuthentication()
        viewModel.retreiveUser()
    }
    
    func completeUserOnboarding() {
        let vc = ProfileDataFormViewController()
        present(vc, animated: true)
    }
    
    //정상적으로 로그인이 되었는지 안되었는지 확인하여 그다음으로 처리한다.
    func bindViews() {
        viewModel.$user.sink { [weak self] user in
            guard let user = user else { return }
            print(user)
            if !user.isUserOnboarded {
                self?.completeUserOnboarding()
            }
        }
        .store(in: &subscriptions)
    }
    
    private func consfigureConstraints() {
        let composeTweetButtonConstraints = [
            composeTweetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            composeTweetButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120),
            composeTweetButton.widthAnchor.constraint(equalToConstant: 60),
            composeTweetButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        NSLayoutConstraint.activate(composeTweetButtonConstraints)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifer, for: indexPath) as? TweetTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        return cell
    }
}

extension HomeViewController: TweetTableViewCellDelegate {
    func tweetTableViewCellDidTapReplay() {
        print("Replay")
    }
    
    func tweetTableViewCellDidTapRetweet() {
        print("Retweet")
    }
    
    func tweetTableViewCellDidTapLike() {
        print("Like")
    }
    
    func tweetTableViewCellDidTapShare() {
        print("Share")
    }
    
    func tweetTableViewCellDidTapViews() {
        print("Views")
    }
}

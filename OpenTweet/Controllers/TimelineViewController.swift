//
//  ViewController.swift
//  OpenTweet
//
//  Created by Olivier Larivain on 9/30/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {

    private var viewModels = [TweetCell.ViewModel]()
    private var tweets: [Tweet] = []
    var replyId: String?

    private let tableView: UITableView = {
        let tv = UITableView()
        tv.register(TweetCell.self, forCellReuseIdentifier: TweetCell.identifier)
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "OpenTweet"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupTableView()
        getTimeline()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        if replyId != nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleDismiss))
        }
    }

    private func getTimeline() {
        let group = DispatchGroup()
        group.enter()
        APICaller.shared.getTimeLine(fileName: "timeline") { [weak self] result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let timeline):
                if self?.replyId == "" {
                    self?.tweets = (timeline.timeline?.filter({$0.inReplyTo == ""}))!
                } else {
                    self?.tweets = (timeline.timeline?.filter({$0.inReplyTo
                        == self?.replyId
                    }))!
                    // TODO get rid of !
                }
            case .failure(let error):
                print(error)
            }
        }
        group.notify(queue: .main) { [weak self] in
            self?.createViewModels()
            self?.tableView.reloadData()
        }
    }

    private func createViewModels() {
        var viewModels = [TweetCell.ViewModel]()
        for tweet in tweets {
            viewModels.append(
                .init(model: tweet)
            )
        }
        self.viewModels = viewModels
    }

    @objc fileprivate func handleDismiss() {
        self.dismiss(animated: true)
    }
}

extension TimelineViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetCell.identifier, for: indexPath) as? TweetCell else {
            fatalError()
        }
        viewModels.sort(by: { $0.date < $1.date })
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModels[indexPath.row].height
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tweet = viewModels[indexPath.row]
        let timeLineVC = TimelineViewController()
        timeLineVC.replyId = tweet.id
        let navVC = UINavigationController(rootViewController: timeLineVC)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true)
    }
}

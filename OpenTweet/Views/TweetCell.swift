//
//  TweetCell.swift
//  OpenTweet
//
//  Created by Lawson Kelly on 8/17/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import UIKit
import SDWebImage

protocol TweetCellDelegate: AnyObject {
    func didUpdateHeight()
}

class TweetCell: UITableViewCell {
    static let identifier = "TweetCell"
    weak var delegate: TweetCellDelegate?

    struct ViewModel {
        let author: String
        let content: String
        let avatar: String
        let date: String
        let inReplyTo: String?
        var height: CGFloat

        init(model: Tweet) {
            self.author = model.author ?? ""
            self.content = model.content ?? ""
            self.date = model.date ?? ""
            self.avatar = model.avatar ?? ""
            self.inReplyTo = model.inReplyTo ?? ""
            self.height = model.getHeight(model: model)
        }
    }

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 0
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()

    private let inReplyToLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .light)
        return label
    }()

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage())
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        addSubviews(authorLabel, contentLabel, dateLabel, inReplyToLabel, avatarImageView)
    }

    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
        self.layoutMargins = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = 40
        avatarImageView.frame = CGRect(
            x: 10,
            y: (contentView.height - imageSize)/4,
            width: imageSize,
            height: imageSize
        )
        let availableWidth = contentView.width - separatorInset.right - imageSize - 15
        dateLabel.frame = CGRect(
            x: avatarImageView.right + 10,
            y: contentView.height - 40,
            width: availableWidth - 10,
            height: 40
        )
        authorLabel.sizeToFit()
        authorLabel.frame = CGRect(
            x: avatarImageView.right + 10,
            y: 4,
            width: availableWidth - 10,
            height: authorLabel.height
        )
        if inReplyToLabel.text != "" {
            inReplyToLabel.sizeToFit()
            inReplyToLabel.frame = CGRect(
                x: avatarImageView.right + 10,
                y: authorLabel.bottom + 1,
                width: availableWidth - 10,
                height: inReplyToLabel.height
            )
        }
        contentLabel.frame = CGRect(
            x: avatarImageView.right + 10,
            y: inReplyToLabel.bottom + 1,
            width: availableWidth - 10,
            height: contentView.height - authorLabel.height - dateLabel.height - 10
        )
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        authorLabel.text = nil
        contentLabel.text = nil
        dateLabel.text = nil
        inReplyToLabel.text = nil
        avatarImageView.image = nil
    }

    public func configure(with viewModel: ViewModel) {
        contentLabel.text = viewModel.content
        authorLabel.text = viewModel.author
        dateLabel.text = viewModel.date
        if viewModel.inReplyTo != "" {
            inReplyToLabel.text = "In reply to \(viewModel.inReplyTo ?? "")"
        } else {
            inReplyToLabel.removeFromSuperview()
        }
        guard let imageUrl = URL(string: viewModel.avatar) else {
            return avatarImageView.image = UIImage(named: "twitter-egg.jpg")
        }
        avatarImageView.sd_setImage(with: imageUrl, completed: nil)
    }
}

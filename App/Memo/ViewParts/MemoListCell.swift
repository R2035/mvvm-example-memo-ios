//
//  MemoListCell.swift
//  Memo
//
//  Created by oe on 2021/10/16.
//

import Reusable
import SnapKit
import UIKit

/// A01 メモ一覧画面のセル
final class MemoListCell: UITableViewCell, Reusable {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()

    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 11, weight: .regular)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .default

        contentView.addSubview(titleLabel)
        contentView.addSubview(bodyLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }

        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-16)
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(titleLabel)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(title: String, body: String) {
        titleLabel.text = title
        bodyLabel.text = body
    }
}

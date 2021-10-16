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
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 11, weight: .regular)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .default

        contentView.addSubview(bodyLabel)

        bodyLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(body: String) {
        bodyLabel.text = body
    }
}

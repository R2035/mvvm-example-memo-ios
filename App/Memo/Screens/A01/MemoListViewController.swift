//
//  MemoListViewController.swift
//  Memo
//
//  Created by oe on 2021/10/16.
//

import UIKit

// TODO: 全体的に仮実装なので後で正式な実装に置き換える

/// A01 メモ一覧画面
final class MemoListViewController: UITableViewController {
    private lazy var searchController: UISearchController = {
        UISearchController(searchResultsController: nil)
    }()

    private let viewModel: MemoListViewModel = AppDelegate.assembler.resolver.resolve()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = L10n.A01.title

        navigationItem.searchController = searchController

        tableView.register(cellType: MemoListCell.self)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MemoListCell.self)
        cell.update(body: "本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文")
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: ViewModel経由で画面遷移する
        let editingMemoViewController = EditingMemoViewController()
        navigationController?.pushViewController(editingMemoViewController, animated: true)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        84
    }
}

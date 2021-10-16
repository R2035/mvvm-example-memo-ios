//
//  MemoListViewController.swift
//  Memo
//
//  Created by oe on 2021/10/16.
//

import Combine
import MemoCore
import UIKit

/// A01 メモ一覧画面
final class MemoListViewController: UITableViewController, UISearchBarDelegate {
    private lazy var searchController: UISearchController = {
        UISearchController(searchResultsController: nil)
    }()

    private lazy var addButton: UIBarButtonItem = {
        UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonDidTouchUpInside))
    }()

    private lazy var dataSource: UITableViewDiffableDataSource<MemoListSection, MemoListItem> = {
        let dataSource = UITableViewDiffableDataSource<MemoListSection, MemoListItem>(tableView: tableView) { tableView, indexPath, item -> UITableViewCell? in
            switch item {
            case let .memo(memo: memo):
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MemoListCell.self)
                cell.update(body: memo.body)
                return cell
            }
        }

        return dataSource
    }()

    private let viewModel: MemoListViewModel = AppDelegate.assembler.resolver.resolve()

    private var cancellables = Set<AnyCancellable>()

    private var memos = [Memo]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = L10n.A01.title

        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = addButton

        tableView.register(cellType: MemoListCell.self)
        tableView.dataSource = dataSource

        searchController.searchBar.delegate = self

        viewModel.sections
            .sink { [weak self] sections in
                self?.update(sections: sections)
            }
            .store(in: &cancellables)

        viewModel.destination
            .sink { [weak self] destination in
                self?.transitionTo(destination: destination)
            }
            .store(in: &cancellables)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.tableViewDidSelectRowAt(indexPath: indexPath)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        84
    }

    // MARK: UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchTextFieldTextDidChange(searchText: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchBarCancelButtonClicked()
    }

    @objc func addButtonDidTouchUpInside() {
        viewModel.addButtonDidTouchUpInside()
    }

    private func update(sections: [(MemoListSection, [MemoListItem])]) {
        var snapshot = NSDiffableDataSourceSnapshot<MemoListSection, MemoListItem>()
        sections.forEach { section, items in
            snapshot.appendSections([section])
            snapshot.appendItems(items)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func transitionTo(destination: MemoListDestination) {
        switch destination {
        case let .editingMemo(memo):
            let editingMemoViewController = EditingMemoViewController(memo: memo)
            navigationController?.pushViewController(editingMemoViewController, animated: true)
        }
    }
}

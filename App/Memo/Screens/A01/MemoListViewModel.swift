//
//  MemoListViewModel.swift
//  Memo
//
//  Created by oe on 2021/10/16.
//

import Combine
import MemoCore
import UIKit

final class MemoListViewModel {
    let memos: AnyPublisher<[Memo], Never>

    let destination: AnyPublisher<MemoListDestination, Never>

    private let _memos = CurrentValueSubject<[Memo], Never>([])

    private let _searchText = CurrentValueSubject<String, Never>("")

    private let _destination = PassthroughSubject<MemoListDestination, Never>()

    private let memoRepository: MemoRepository

    private var cancellables = Set<AnyCancellable>()

    init(memoRepository: MemoRepository) {
        memos = _memos
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()

        destination = _destination
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()

        self.memoRepository = memoRepository

        _searchText
            .flatMap { searchText -> AnyPublisher<[Memo], Never> in
                if searchText.isEmpty {
                    return memoRepository.read(input: .all)
                } else {
                    return memoRepository.read(input: .contains(body: searchText))
                }
            }
            .sink { [weak self] memos in
                self?._memos.send(memos)
            }
            .store(in: &cancellables)
    }

    func tableViewDidSelectRowAt(indexPath: IndexPath) {
        let memo = _memos.value[indexPath.row]
        _destination.send(.editingMemo(memo: memo))
    }

    func addButtonDidTouchUpInside() {
        _destination.send(.editingMemo(memo: nil))
    }

    func searchTextFieldTextDidChange(searchText: String) {
        _searchText.send(searchText)
    }

    func searchBarCancelButtonClicked() {
        _searchText.send("")
    }
}

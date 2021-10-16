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

    private let _destination = PassthroughSubject<MemoListDestination, Never>()

    private let memoRepository: MemoRepository

    init(memoRepository: MemoRepository) {
        memos = memoRepository.read(input: .all)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()

        destination = _destination
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()

        self.memoRepository = memoRepository
    }

    func didTableViewSelectRowAt(indexPath: IndexPath) {
        _destination.send(.editingMemo)
    }

    func didAddButtonTouchUpInside() {
        _destination.send(.editingMemo)
    }
}

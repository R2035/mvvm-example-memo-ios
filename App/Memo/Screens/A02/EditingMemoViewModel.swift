//
//  EditingMemoViewModel.swift
//  Memo
//
//  Created by oe on 2021/10/16.
//

import Combine
import MemoCore

final class EditingMemoViewModel {
    let body: AnyPublisher<String, Never>

    let destination: AnyPublisher<EditingMemoDestination, Never>

    let isDeleteButtonEnabled: AnyPublisher<Bool, Never>

    private let _body: CurrentValueSubject<String, Never>

    private let _destination = PassthroughSubject<EditingMemoDestination, Never>()

    private let memoId: MemoId?

    private let memoRepository: MemoRepository

    init(memoRepository: MemoRepository, memo: Memo?) {
        _body = CurrentValueSubject<String, Never>(memo?.body ?? "")

        body = _body
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()

        destination = _destination
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()

        isDeleteButtonEnabled = CurrentValueSubject<Bool, Never>(memo?.id != nil)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()

        memoId = memo?.id

        self.memoRepository = memoRepository
    }

    func textViewDidChange(text: String) {
        _body.send(text)
    }

    func deleteButtonDidTouchUpInside() {
        guard let memoId = memoId else {
            return
        }
        memoRepository.delete(input: .memo(id: memoId))

        _destination.send(.pop)
    }

    func saveButtonDidTouchUpInside() {
        if let memoId = memoId {
            let memo = Memo(id: memoId, body: _body.value)
            memoRepository.update(input: .memo(memo: memo))
        } else {
            memoRepository.create(input: .memo(body: _body.value))
        }

        _destination.send(.pop)
    }
}

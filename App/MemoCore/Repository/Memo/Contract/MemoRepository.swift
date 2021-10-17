//
//  MemoRepository.swift
//  MemoCore
//
//  Created by oe on 2021/10/16.
//

import Combine

/// MemoのRepository
/// - note: funcの数が増えないようにinputをenumにして吸収している
public protocol MemoRepository {
    func create(input: MemoRepositoryInputCreate)

    func delete(input: MemoRepositoryInputDelete)

    func read(input: MemoRepositoryInputRead) -> AnyPublisher<[Memo], Never>

    func update(input: MemoRepositoryInputUpdate)
}

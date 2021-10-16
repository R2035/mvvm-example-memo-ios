//
//  RealmMemoRepository.swift
//  MemoCore
//
//  Created by oe on 2021/10/16.
//

import Combine
import RealmSwift
import UIKit

/// Realmを使ったMemoRepositoryの実装
final class RealmMemoRepository: MemoRepository {
    private let realm: Realm

    private let notified = PassthroughSubject<Void, Never>()

    private lazy var token: NotificationToken = {
        realm.observe { [weak self] notification, realm in
            self?.notified.send(())
        }
    }()

    init(realm: Realm) {
        self.realm = realm
    }

    deinit {
        token.invalidate()
    }

    // MARK: MemoRepository

    func create(input: MemoRepositoryInputCreate) {
        DispatchQueue.main.async { [weak self] in
            do {
                try self?.realm.write {
                    switch input {
                    case let .memo(value):
                        let realmMemoObject = RealmMemoRepository.convert(memo: value)
                        self?.realm.add(realmMemoObject, update: .all)
                    }
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }

    func delete(input: MemoRepositoryInputDelete) {
        DispatchQueue.main.async { [weak self] in
            do {
                try self?.realm.write {
                    switch input {
                    case let .memo(value):
                        let realmMemoObject = RealmMemoRepository.convert(memo: value)
                        self?.realm.delete(realmMemoObject)
                    }
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }

    func read(input: MemoRepositoryInputRead) -> AnyPublisher<[Memo], Never> {
        notified.map { [weak self] in
            self?.readRealm(input: input).map { realmMemoObject in
                RealmMemoRepository.convert(realmMemoObject: realmMemoObject)

            } ?? []
        }
        .eraseToAnyPublisher()
    }

    func update(input: MemoRepositoryInputUpdate) {
        DispatchQueue.main.async { [weak self] in
            do {
                try self?.realm.write {
                    switch input {
                    case let .memo(value):
                        let realmMemoObject = RealmMemoRepository.convert(memo: value)
                        self?.realm.add(realmMemoObject, update: .modified)
                    }
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }

    private func readRealm(input: MemoRepositoryInputRead) -> Results<RealmMemoObject> {
        switch input {
        case .all:
            return realm.objects(RealmMemoObject.self)
        }
    }

    private static func convert(memo: Memo) -> RealmMemoObject {
        let realmMemoObject = RealmMemoObject()
        if case let .registered(value) = memo.id {
            realmMemoObject.id = value
        }
        realmMemoObject.body = memo.body
        return realmMemoObject
    }

    private static func convert(realmMemoObject: RealmMemoObject) -> Memo {
        Memo(id: .registered(value: realmMemoObject.id), body: realmMemoObject.body)
    }
}

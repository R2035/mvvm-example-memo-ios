//
//  RealmMemoRepository.swift
//  MemoCore
//
//  Created by oe on 2021/10/16.
//

import Combine
import RealmSwift
import SwiftUI
import UIKit

/// Realmを使ったMemoRepositoryの実装
final class RealmMemoRepository: MemoRepository {
    private let realm: Realm

    private let notified: PassthroughSubject<Void, Never>

    private var cancellables = Set<AnyCancellable>()

    private let token: NotificationToken

    init(realm: Realm) {
        self.realm = realm

        let notified = PassthroughSubject<Void, Never>()

        self.notified = notified

        token = realm.observe { _, _ in
            notified.send(())
        }
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
                    case let .memo(body):
                        let realmMemoObject = RealmMemoObject()
                        realmMemoObject.body = body
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
                guard let self = self else {
                    return
                }

                try self.realm.write {
                    switch input {
                    case let .memo(id):
                        let realmMemoObject = self.readRealm(id: id)
                        self.realm.delete(realmMemoObject)
                    }
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }

    func read(input: MemoRepositoryInputRead) -> AnyPublisher<[Memo], Never> {
        let initialValue = readRealm(input: input)
        let memos = CurrentValueSubject<Results<RealmMemoObject>, Never>(initialValue)

        notified
            .sink { [weak self] in
                guard let self = self else {
                    return
                }
                memos.send(self.readRealm(input: input))
            }
            .store(in: &cancellables)

        return memos
            .map { realmMemoObjects in
                realmMemoObjects.map { realmMemoObject in
                    RealmMemoRepository.convert(realmMemoObject: realmMemoObject)
                }
            }
            .eraseToAnyPublisher()
    }

    func update(input: MemoRepositoryInputUpdate) {
        DispatchQueue.main.async { [weak self] in
            do {
                guard let self = self else {
                    return
                }
                try self.realm.write {
                    switch input {
                    case let .memo(memo):
                        let realmMemoObject = self.readRealm(id: memo.id)
                        realmMemoObject.body = memo.body
                        self.realm.add(realmMemoObject, update: .modified)
                    }
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }

    private func readRealm(id: MemoId) -> RealmMemoObject {
        let predicate = NSPredicate(format: "id == %@", id.value)
        guard let realmMemoObject = realm.objects(RealmMemoObject.self).filter(predicate).first else {
            fatalError("RealmMemoObject does not exist for id: \(id.value)")
        }
        return realmMemoObject
    }

    private func readRealm(input: MemoRepositoryInputRead) -> Results<RealmMemoObject> {
        switch input {
        case .all:
            return realm.objects(RealmMemoObject.self)
        case let .contains(body):
            let predicate = NSPredicate(format: "body CONTAINS[c] %@", body)
            return realm.objects(RealmMemoObject.self).filter(predicate)
        }
    }

    private static func convert(realmMemoObject: RealmMemoObject) -> Memo {
        Memo(id: MemoId(value: realmMemoObject.id), body: realmMemoObject.body)
    }
}

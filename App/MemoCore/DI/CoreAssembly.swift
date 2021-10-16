//
//  CoreAssembly.swift
//  MemoCore
//
//  Created by oe on 2021/10/16.
//

import RealmSwift
import Swinject

public final class CoreAssembly: Assembly {
    public init() {}

    // MARK: Assembly

    public func assemble(container: Container) {
        do {
            let realm = try Realm()
            container.register(Realm.self) { _ in
                realm
            }.inObjectScope(.container)
        } catch {
            fatalError(error.localizedDescription)
        }

        container.register(MemoRepository.self) { resolver in
            RealmMemoRepository(realm: resolver.resolve())
        }.inObjectScope(.container)
    }
}

//
//  CoreAssembly.swift
//  MemoCore
//
//  Created by oe on 2021/10/16.
//

import Swinject

public final class CoreAssembly: Assembly {
    public init() {}

    // MARK: Assembly

    public func assemble(container: Container) {
        container.register(MemoRepository.self) { _ in
            RealmMemoRepository()
        }
    }
}

//
//  AppAssembly.swift
//  Memo
//
//  Created by oe on 2021/10/16.
//

import Foundation
import MemoCore
import Swinject

final class AppAssembly: Assembly {
    // MARK: Assembly

    public func assemble(container: Container) {
        container.register(MemoListViewModel.self) { resolver in
            MemoListViewModel(memoRepository: resolver.resolve())
        }

        container.register(EditingMemoViewModel.self) { resolver, memo in
            EditingMemoViewModel(memoRepository: resolver.resolve(), memo: memo)
        }
    }
}

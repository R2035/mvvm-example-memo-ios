//
//  Resolver+resolve.swift
//  MemoCore
//
//  Created by oe on 2021/10/16.
//

import Foundation
import Swinject

public extension Resolver {
    /// 型推論を利用して型指定の引数不要かつ非Optionalでresolveする
    func resolve<T>() -> T {
        guard let service = resolve(T.self) else {
            fatalError("\(T.self) is not registered.")
        }
        return service
    }
}

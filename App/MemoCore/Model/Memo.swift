//
//  Memo.swift
//  MemoCore
//
//  Created by oe on 2021/10/16.
//

import Foundation

public struct Memo {
    public let id: MemoId

    public let body: String

    public init(id: MemoId, body: String) {
        self.id = id
        self.body = body
    }
}

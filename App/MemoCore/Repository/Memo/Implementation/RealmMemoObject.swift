//
//  RealmMemoObject.swift
//  MemoCore
//
//  Created by oe on 2021/10/16.
//

import RealmSwift

final class RealmMemoObject: Object {
    @Persisted(primaryKey: true) var id = UUID().uuidString

    @Persisted var body = ""
}

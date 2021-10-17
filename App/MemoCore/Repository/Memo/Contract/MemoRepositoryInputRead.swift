//
//  MemoRepositoryInputRead.swift
//  MemoCore
//
//  Created by oe on 2021/10/16.
//

import Foundation

public enum MemoRepositoryInputRead {
    case all

    case contains(body: String)
}

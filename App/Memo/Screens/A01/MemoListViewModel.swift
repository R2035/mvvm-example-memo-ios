//
//  MemoListViewModel.swift
//  Memo
//
//  Created by oe on 2021/10/16.
//

import Foundation
import MemoCore
import UIKit

final class MemoListViewModel {
    private let memoRepository: MemoRepository

    init(memoRepository: MemoRepository) {
        self.memoRepository = memoRepository
    }
}

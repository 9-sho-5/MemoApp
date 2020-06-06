//
//  MemoToModel.swift
//  MemoApp
//
//  Created by Kusunose Hosho on 2020/06/06.
//  Copyright © 2020 Kusunose Hosho. All rights reserved.
//

import UIKit

class MemoToModel: NSObject {
    var text = ""
    var priority: MemoPriority = .Low
}

enum MemoPriority: Int {
    case Low    = 0
    case Low_Middle = 1
    case Middle = 2
    case High_Middle = 3
    case High   = 4
}

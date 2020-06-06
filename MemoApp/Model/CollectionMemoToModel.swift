//
//  CollectionMemoToModel.swift
//  MemoApp
//
//  Created by Kusunose Hosho on 2020/06/06.
//  Copyright © 2020 Kusunose Hosho. All rights reserved.
//

import UIKit

class CollectionMemoToModel: NSObject {
    static let sharedInstance = CollectionMemoToModel()
    var memoCollectionToModels:[MemoToModel] = []

    func fetchMemos() {
    let memoToModel = MemoToModel()
        memoToModel.text = ""
        self.memoCollectionToModels.append(memoToModel)
    }
    
    func addTodoCollection(memoToModel: MemoToModel){
        self.memoCollectionToModels.append(memoToModel)
    }
}

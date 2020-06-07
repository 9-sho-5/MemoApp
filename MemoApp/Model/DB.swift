//
//  DB.swift
//  MemoApp
//
//  Created by Kusunose Hosho on 2020/06/02.
//  Copyright © 2020 Kusunose Hosho. All rights reserved.
//

import Foundation
import RealmSwift

class Folder: Object {
    @objc dynamic var id: String = NSUUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var date: Date!
    
    //has_many
    let memos = List<Memo>()
}

class Memo: Object {
    @objc dynamic var id: String = NSUUID().uuidString
    @objc dynamic var text: String = ""
    @objc dynamic var folderId: String = NSUUID().uuidString
    @objc dynamic var createdAt: Date!
    //belongs_to
    let folder = LinkingObjects(fromType: Folder.self, property: "memos")
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

class MyRealm {
    func createNewMemo(text: String) {
        
        let memo = Memo()
        memo.text = text
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(memo)
        }
    }
    
}

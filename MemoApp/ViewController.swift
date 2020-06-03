//
//  ViewController.swift
//  MemoApp
//
//  Created by Kusunose Hosho on 2020/06/02.
//  Copyright © 2020 Kusunose Hosho. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var saveButton: UIButton!

    @IBOutlet var searchBar: UISearchBar!
    
    var memos: Results<Memo>!
    var folders: Results<Folder>!
    
    let realm = try! Realm()
    
    var models :[String] = []
    
    var searchMemo = [String]()
    var searching = false
    
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        models = []

        saveButton.layer.cornerRadius = 8
        
        searchBar.delegate = self
        table.delegate = self
        table.dataSource = self
        
        let realm = try! Realm()
        memos = realm.objects(Memo.self)
        folders = realm.objects(Folder.self)
        
        notificationToken = memos.observe { [weak self] _ in
            self?.table.reloadData()
        }
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchMemo.count
        } else {
            return memos.count
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
//            models.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
            let realm = try! Realm()
            try! realm.write {
                realm.delete(self.memos[indexPath.row])
            }
            models.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying: UITableViewCell, forRowAt: IndexPath) {
        if memos.count == 0{
            editButton.title = "Edit"
            table.isEditing = false
        }
    }
        
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
        
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        models.swapAt(sourceIndexPath.row, sourceIndexPath.row)
        
        let moveObjTmp = models[sourceIndexPath.row]
        models.remove(at: sourceIndexPath.row)
        models.insert(moveObjTmp, at: destinationIndexPath.row)
        
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if searching {
            cell.textLabel?.text = searchMemo[indexPath.row]
        } else {
            cell.textLabel?.text = memos[indexPath.row].text
            models.append(memos[indexPath.row].text)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    @IBAction func didTapSort() {
        if table.isEditing {
            editButton.title = "Edit"
            
            //mapメソッドでmodelsの中を順番変更
            models = models.map({$0})
            print(models)
            
            table.isEditing = false
            
        } else {
            editButton.title = "Done"
            table.isEditing = true
        }
            
            table.reloadData()
        }
    
    @IBAction func save() {
//        let folder = Folder()
//            //Folderが0の時
//        if folders.count == 0 {
//            //folderId = 1
//            folderId = 1
//            //folder.id = 1
//            folder.id = folders.count + 1
//            //Folderが1以上の時
//        } else if folders.count >= 1 {
//            //folder.id = 2
//            folder.id = Int(folderId)
//            //folderId = 3   以降繰り返し
//            folderId = folderId + 1
//        }
        
//
//        try! realm.write {
//
//            folder.name = //入力した値
//            //作成日時の追加
//            folder.date = Date()
//        }
        
        
        
        
////        //folderId = 2  //folderId = 3   以降繰り返し
//        folderId = folderId + 1
        
        table.reloadData()
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchMemo = models.filter({$0.prefix(searchText.count) == searchText})
        searching = true
        table.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        table.reloadData()
    }
}

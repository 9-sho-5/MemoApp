//
//  ViewController.swift
//  MemoApp
//
//  Created by Kusunose Hosho on 2020/06/02.
//  Copyright © 2020 Kusunose Hosho. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    @IBOutlet var table: UITableView!
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet weak var priorityFace: UIView!
    
    let memoCollection = CollectionMemoToModel.sharedInstance
    
    @IBOutlet var searchBar: UISearchBar!
    
    var memos: Results<Memo>!
    var folders: Results<Folder>!
    
    let realm = try! Realm()
    
    var models :[String] = []
    
    var sortedMemoModels = [String]()
    
    var searchMemo = [String]()
    var searching = false
    var topSafeAreaHeight: CGFloat = 0
    private var searchBarHeight: CGFloat = 44
    
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.layer.cornerRadius = 8
        
        table.contentOffset = CGPoint(x: 0, y: searchBarHeight)
        
        searchBar.showsCancelButton = false
        
        searchBar.delegate = self
        table.delegate = self
        table.dataSource = self
        
        let realm = try! Realm()
        memos = realm.objects(Memo.self).sorted(byKeyPath: "createdAt", ascending: true)
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
            return self.memoCollection.memoCollectionToModels.count
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
            UIView.animate(withDuration: 1.5, delay: 0.0, options: [.curveLinear], animations: {
                    tableView.deleteRows(at: [indexPath], with: .top)
            }, completion: nil)

        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            return .delete
        }
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying: UITableViewCell, forRowAt: IndexPath) {
        if memos.count == 0{
            editButton.title = "Edit"
            table.isEditing = false
            table.contentOffset = CGPoint(x: 0, y: searchBarHeight+11)
        }
    }
        
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //cell移動設定
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
            let modelsMemo = self.memoCollection.memoCollectionToModels[indexPath.row]
            cell.textLabel!.text = modelsMemo.text
            
//            cell.textLabel?.text = models[indexPath.row]
//            models.append(memos[indexPath.row].text)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    @IBAction func leftBarBtnClicked(sender: UIButton) {
        // 一瞬で切り替わると不自然なのでアニメーションを付与する
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveLinear], animations: {
                self.table.contentOffset = CGPoint(x: 0, y: -self.topSafeAreaHeight)
        }, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        table.contentOffset = CGPoint(x: 0, y: searchBarHeight)
    }
    
    @IBAction func didTapSort() {
        if table.isEditing {
            editButton.title = "Edit"
            
            let orderedSet: NSOrderedSet = NSOrderedSet(array: models)
            var models = orderedSet.array as! [String]
            
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
        searchMemo = models.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        print(searchText.count)
        searching = true
        table.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        table.reloadData()
    }
    
    
}

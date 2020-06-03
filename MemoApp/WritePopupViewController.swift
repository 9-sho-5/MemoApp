//
//  WritePopupViewController.swift
//  MemoApp
//
//  Created by Kusunose Hosho on 2020/06/03.
//  Copyright © 2020 Kusunose Hosho. All rights reserved.
//

import UIKit
import  RealmSwift

class WritePopupViewController: UIViewController, UITextFieldDelegate {

    var models :[String] = []
    
    @IBOutlet var uiView: UIView!
    @IBOutlet var textField: UITextField!
    @IBOutlet var addButton: UIButton!
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.placeholder = "Write Somothing"
        textField.delegate = self
        
        uiView.layer.cornerRadius = 8
        addButton.layer.cornerRadius = 8
        
        uiView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0) // 上向きの影
        uiView.layer.shadowRadius = 3;
        uiView.layer.shadowOpacity = 0.8;
    }
    
//    // ポップアップの外側をタップした時にポップアップを閉じる
//      override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//          var tapLocation: CGPoint = CGPoint()
//          // タッチイベントを取得する
//          let touch = touches.first
//          // タップした座標を取得する
//          tapLocation = touch!.location(in: self.view)
//
//          let popUpView: UIView = self.view.viewWithTag(100)! as UIView
//
//          if !popUpView.frame.contains(tapLocation) {
//              self.dismiss(animated: false, completion: nil)
//          }
//      }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func tappedAddButton_TouchUpInside(_ sender: UIButton){
        dismiss(animated: true)
    }

    @IBAction func add() {
        let memo = Memo()
//        let folder = Folder()
        
        try! realm.write {
            memo.text = textField.text ?? ""
            realm.add(memo)
        }
        
        textField.text = ""
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide() {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            } else {
                let suggestionHeight = self.view.frame.origin.y + keyboardSize.height
                self.view.frame.origin.y -= suggestionHeight
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func dismissAddPopup(_ sender: Any) {
        UIView.animate(withDuration: 0.0, delay: 0.2, options: [.curveLinear], animations: {
            self.uiView.center.y += 100.0
        }, completion: nil)
    }
    
    @IBAction func add() {
        let memo = Memo()
        
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

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}

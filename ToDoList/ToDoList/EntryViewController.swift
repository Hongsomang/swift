//
//  EntryViewController.swift
//  ToDoList
//
//  Created by 홍소망 on 2022/09/07.
//
import RealmSwift
import UIKit

class EntryViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet var textField:UITextField!
    @IBOutlet var datePicker:UIDatePicker!
    
    private let realm=try! Realm() //realm 열기
    public var completionHandler:(()->Void)? //데이터베이스 저장후
  
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.becomeFirstResponder() //키보드 올라오기
        textField.delegate=self
        
        datePicker.setDate(Date(), animated: true)
        
        //상단에 버튼만들기
        navigationItem.rightBarButtonItem=UIBarButtonItem(title: "Save", style: .done, target:self, action: #selector(didTapSaveButton))
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() //상태포기요청이 왔음을 알리는 함수 ->키보드내리기
        return true
    }
    
    //select를 생성할 메서드는 @objc를 붙여야 한다.
    @objc func didTapSaveButton(){
        if let text = textField.text, !text.isEmpty{
            let date=datePicker.date
            
            realm.beginWrite()
            let newItem = TodoListItem()
            newItem.date=date
            newItem.item=text
            realm.add(newItem)
            try! realm.commitWrite()
            
            completionHandler?()
            navigationController?.popViewController(animated: true)
            
        }else{
            print("add something")
        }
    }

}

//
//  ViewViewController.swift
//  ToDoList
//
//  Created by 홍소망 on 2022/09/07.
//
import RealmSwift
import UIKit

class ViewViewController: UIViewController {
    
    public var item: TodoListItem?
    public var deletionHandler: (()->Void)?
    
    @IBOutlet var itemLabel:UILabel!
    @IBOutlet var dateLabel:UILabel!
    
    private let realm=try! Realm()
    
    static let dateFormatter:DateFormatter = {
        let dateFormatter = DateFormatter() //인스턴스 생ㅎ성
        dateFormatter.dateStyle = .medium //날짜 형식지정
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        itemLabel.text=item?.item //TodoListItem클래스에 있는 item 객체를 라벨에 넣는다.
        dateLabel.text=Self.dateFormatter.string(from: item!.date) //TodoListItem클래스에 있는 date 객체를 dateFormatter에 지정형태로 날짜를 라벨에 넣어준다. Self는 타입프로퍼티와 타입 메소드를 가리킬때 사용된다.
        
        navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem: .trash ,target: self, action: #selector(didTapDelete))
    }
    //삭제 하는 부분
    @objc private func didTapDelete(){
        guard let myItem = item else {
            return
        }
        realm.beginWrite()
        realm.delete(myItem)
        try! realm.commitWrite()
        
        deletionHandler?()
        navigationController?.popViewController(animated: true) //뒤로가기
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

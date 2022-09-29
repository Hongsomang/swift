//
//  ViewController.swift
//  ToDoList
//
//  Created by 홍소망 on 2022/09/07.
//
import RealmSwift
import UIKit

class TodoListItem:Object{
    //dinamic var ->swfit런타임 말고 object-c런타임 쓸게
    //dinamic 키워드는 class의 맴버에서만 사용 가능
    //realm 사용할 때 dynamic 필수
    //dynamic은 변수에 대한 변경사항을 realmd에게 알리고 이를 데이터베이스에 반영할 수있도록 허용
    @objc dynamic var item:String=""
    @objc dynamic var date:Date=Date()
}


class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet var table:UITableView! //테이블 뷰와 코드 연동
    private let realm = try! Realm()
    private var data=[TodoListItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = realm.objects(TodoListItem.self).map{($0)}
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell") //cell 재사용하기 위해서
       //UITableView를 정상적으로 작동할려면 필요
        table.delegate=self //컨트롤러/ 테이블 뷰의 세세한 부분 조정가능
        table.dataSource=self //데이터 모델/ 테이블 뷰를 생성하고 수정하는데 필요한 정보를 테이블 뷰 객체에 제공
       
    }
    //행의 개수를 리턴해줌
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    //특정 row에 표시할 cell 리턴
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath ) //cell만들기
        cell.textLabel?.text=data[indexPath.row].item //내용 지정
        return cell
    }
    //테이블 뷰의 셀을 선택했을 때
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //클릭효과
        
        let item = data[indexPath.row] //indexPath는 [section,row]임 indexPath.row하면 row만 찍힘
        guard let vc=storyboard?.instantiateViewController(identifier: "view")as? ViewViewController else{
            return
        }
        vc.item=item      //vc에 데이터 넣어줌
        vc.deletionHandler = { [weak self] in
            self?.refresh()
            
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title=item.item
        navigationController?.pushViewController(vc, animated: true)
        
    }
    //add버튼을 눌렀을 때 이벤트
    @IBAction func didTabAddButton(){
        //guard ->조건문을 걸러 낼때 사용
        //instantiateViewController->이걸 사용해서 뷰컨트롤러를 만들게 되면 데이터는 초기화되고 새로운 인스턴스가 생성 즉 A->B->A가 될때 데이터 초기화가 됨
        //identifier-> storybord id
        //as ->type캐스팅 원래 타입과  변환할 타입이 호환된다면 변환된 타입으로 인스턴스를 리턴한다.
        guard let vc=storyboard?.instantiateViewController(identifier: "enter") as? EntryViewController else {
            return
        }
        //completionHandler는 클로저이다.
        vc.completionHandler={[weak self] in
            self?.refresh()
        }
        vc.title="New Item"
        vc.navigationItem.largeTitleDisplayMode = .never //title 가운데로 이동
        navigationController?.pushViewController(vc, animated: true)//pushViewController는 스택에 vc를 추가하는 메소드 스택 최상위에 있는 vc가 화면에 표시된다.
    }
    func refresh(){
        data = realm.objects(TodoListItem.self).map{($0)} //데이터 불러 올 때
        table.reloadData()
    }

}


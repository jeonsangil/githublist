//
//  GithublistViewController.swift
//  GithubList
//
//  Created by toplogic on 2017. 12. 10..
//  Copyright © 2017년 exam. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class GithublistViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate {
    
    //UI 변수 관련
    var tableview : UITableView!
    var searchBar: UISearchBar!
    var footerView : ListFooterView! //테이블뷰 푸터 인디게이터표시
    //통신 데이타 관련
    let apiList: ApiList = ApiList()
    //searbar 관련
    var searchData : [ApiList.Response] = [ApiList.Response]() //검색데이타 저장
    var inSearchMode = false //서치모드 플래그
    //rx 관련
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setting()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //뷰 UI 및 데이타 셋팅
    func setting(){
        //서치바 셋팅
        self.searchBar = UISearchBar()
        self.searchBar.placeholder = "Search"
        self.searchBar.delegate = self
        self.searchBar.returnKeyType = UIReturnKeyType.done
        self.view.addSubview(self.searchBar)
    
        self.searchBar.snp.makeConstraints { (make) -> Void in
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(0)
            } else {
                make.top.equalTo(self.view.snp.top).offset(0)
            }
            make.height.equalTo(56)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
        }
        //searchbar rx코딩 웹사이트 참조
        /* https://pilgwon.github.io/blog/2017/09/26/RxSwift-By-Examples-1-The-Basics.html */
        self.searchBar
            .rx.text // RxCocoa의 Observable 속성
            .orEmpty // 옵셔널이 아니도록 만듭니다.
            .debounce(0.5, scheduler: MainScheduler.instance) // 0.5초 기다립니다.
            .distinctUntilChanged() // 새로운 값이 이전의 값과 같은지 확인합니다.
            .subscribe(onNext: { [unowned self] query in // 여기서 새로운 값에 대한 구독을 합니다.
                self.tableview.reloadData()
            })
            .disposed(by: disposeBag)
        
        //테이블뷰 셋팅
        self.tableview = UITableView()
        self.tableview.register(ListTableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableview.separatorStyle = .none
        self.tableview.dataSource = self
        self.tableview.delegate = self
        self.tableview.rowHeight = 70
        self.view.addSubview(self.tableview)
        self.tableview.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.searchBar.snp.bottom).offset(0)
            make.bottom.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
        }
        //테이블뷰 푸터 셋팅
        self.footerView = ListFooterView(frame: CGRect(x: 0, y: 0, width: self.tableview.frame.width, height: 50))
        self.tableview.tableFooterView =  self.footerView
        //레포지터리 겟 데이타요청
        self.apiRequest(listId: "since")
    }
}
//network
extension GithublistViewController  {
    //레포지터리 겟 데이타요청!
    func apiRequest(listId : String){
        self.apiList.ApiGet(param: listId) {
            self.footerView.setStart() //인디게이터시작
            self.tableview.reloadData()
            self.footerView.setStop() //인디게이터종료
        }
    }
}
//tableview
extension GithublistViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inSearchMode {
            if searchData.count > 0 {
                //검색데이타가 1개 이상시 검색데이타 반영
                return searchData.count
            }else{
                //검색데이타 없을시 1개 리턴
                return 1
            }
        }
        return self.apiList.response.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListTableViewCell
        
        //검색 데이타 삽입
        if inSearchMode == true {
            if searchData.count > 0 {
                cell.setData(item: self.searchData[indexPath.row])
            }else{
                //검색데이타 없을시
                cell.setEmptyDate()
            }
        }else{
        //Cell 데이타 삽입
            cell.setData(item: self.apiList.response[indexPath.row])
        }
        //더 불러오기
        if self.apiList.response.count - 1 == indexPath.row {
            self.loadMore(item: self.apiList.response[indexPath.row])
        }
        return cell
    }
    //더 불러오기
    func loadMore(item : ApiList.Response ) {
        self.apiRequest(listId: "since=\(item.listId)")
    }
}
//saerchBar 구현
extension GithublistViewController  {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
        } else {
            inSearchMode = true
            self.searchData = self.apiList.response.filter({  $0.name == searchBar.text})
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}


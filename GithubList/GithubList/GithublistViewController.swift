//
//  GithublistViewController.swift
//  GithubList
//
//  Created by toplogic on 2017. 12. 10..
//  Copyright © 2017년 exam. All rights reserved.
//

import UIKit
import SnapKit

final class GithublistViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate {
    
    var tableview : UITableView!
    var searchBar: UISearchBar!
    
    let apiList: ApiList = ApiList()
    
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
        //레포지터리 데이타요청
        self.apiRequest(listId: "since")
    }
}

//network
extension GithublistViewController  {
    func apiRequest(listId : String){
        self.apiList.ApiGet(param: listId) {
            self.tableview.reloadData()
        }
    }
}

//tableview
extension GithublistViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apiList.response.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListTableViewCell
        //Cell 데이타 삽입
        cell.setData(item: self.apiList.response[indexPath.row])
        return cell
    }
}


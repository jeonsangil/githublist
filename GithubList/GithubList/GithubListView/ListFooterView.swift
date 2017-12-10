//
//  ListFooterView.swift
//  GithubList
//
//  Created by toplogic on 2017. 12. 10..
//  Copyright © 2017년 exam. All rights reserved.
//

import UIKit

final class ListFooterView : UIView  {
    let loading : UIActivityIndicatorView = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI() //UI설정
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    ///리스트 셀 푸터 UI 셋팅
    func setUI(){
        self.loading.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray
        self.addSubview(self.loading)
    }
    //인디게이터 시작
    func setStart(){
        self.loading.center = self.center
        self.loading.startAnimating()
        //self.backgroundColor = UIColor.red
    }
    //인디게이터 정지
    func setStop(){
        self.loading.stopAnimating()
        //self.backgroundColor = UIColor.clear
    }
}

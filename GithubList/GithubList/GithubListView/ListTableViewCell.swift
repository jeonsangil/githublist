//
//  ListTableViewCell.swift
//  GithubList
//
//  Created by toplogic on 2017. 12. 10..
//  Copyright © 2017년 exam. All rights reserved.
//

import Foundation

import Kingfisher
import SnapKit
import SwiftyJSON

final class ListTableViewCell: UITableViewCell {
    
    let imageviewAvata:UIImageView  = UIImageView() //유저이미지
    let labelName: UILabel = UILabel() //이름라벨
    let viewLine: UIView = UIView() //백그라운드 라인뷰
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUI()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageviewAvata.image = nil
        self.labelName.text = ""
    }
    //리스트 셀 UI 셋팅
    func setUI(){
        
        self.addSubview(self.viewLine)
        self.viewLine.addSubview(self.imageviewAvata)
        self.viewLine.addSubview(self.labelName)
        
        self.backgroundColor = UIColor.clear
        self.viewLine.layer.borderWidth = 1.0
        self.viewLine.layer.borderColor = UIColor.black.cgColor
        //self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //오토레이아웃설정 백그라운드 라인뷰
        self.viewLine.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
        }
        //오토레이아웃설정 유저이미지
        self.imageviewAvata.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.centerY.equalTo(self.viewLine)
            make.left.equalTo(self.viewLine).offset(10)
        }
        //오토레이아웃설정 유저이름
        self.labelName.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.viewLine)
            make.left.equalTo(self.imageviewAvata.snp.right).offset(10)
            make.right.equalTo(self.viewLine).offset(-10)
        }
    }
    //리스트 셀 Data 셋팅
    func setData(item : ApiList.Response){
        self.imageviewAvata.kf.setImage(with: item.imageURL) //이미지설정
        self.labelName.text = item.name //이름설정
        self.viewLine.layer.borderColor = UIColor.black.cgColor
    }
    //서치 검색없음표시
    func setEmptyDate(){
        self.imageviewAvata.image = nil
        self.labelName.text = "입력한 사용자를 찾을수 없습니다.😭" //검색데이타 없을시
        self.viewLine.layer.borderColor = UIColor.clear.cgColor
    }
}

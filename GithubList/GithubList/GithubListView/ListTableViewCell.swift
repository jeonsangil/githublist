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
    
    let imageviewAvata:UIImageView  = UIImageView()
    let labelName: UILabel = UILabel()
    let viewLine: UIView = UIView()
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUI()
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
        
        self.viewLine.frame = self.frame
        self.imageviewAvata.frame = CGRect(x: 10, y: 5, width: 40, height: 40)
        self.labelName.frame = CGRect(x: 50, y: 5, width: 100, height: 40)
    }
    //리스트 셀 Data 셋팅
    func setData(item : ApiList.Response){
        self.imageviewAvata.kf.setImage(with: item.imageURL) //이미지설정
        self.labelName.text = item.name //이름설정
    }
}

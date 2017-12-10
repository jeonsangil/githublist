//
//  ApiList.swift
//  GithubList
//
//  Created by toplogic on 2017. 12. 10..
//  Copyright © 2017년 exam. All rights reserved.
//

import Foundation

import SwiftyJSON
import Alamofire

final class ApiList : NSObject {
    
    open var response: [Response] = [Response]() //파싱데이터 배열로 저장
    
    struct Response {
        let listId: String //저장소 고유아이디
        let name: String    //유저 이름
        let ownerId: String //유저 고유번호
        let imageURL: URL?  //유저이미지
        
        init(_ json: JSON) {
            self.listId = json["id"].stringValue
            self.name = json["owner"]["login"].stringValue
            self.ownerId = json["owner"]["id"].stringValue
            self.imageURL = URL(string: json["owner"]["avatar_url"].stringValue)
        }
    }
    func ApiGet(param : String, success:@escaping() -> Void){
        Alamofire.request("https://api.github.com/repositories?\(param)").responseJSON { response in
            if let successJson = response.result.value {
                for item in JSON(successJson).arrayValue{
                    self.response.append(Response(item))
                }
                success()
            }
        }
    }
}

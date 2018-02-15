//
//  Task.swift
//  taskapp
//
//  Created by yuji on 2018/01/24.
//  Copyright © 2018年 yuji. All rights reserved.
//

// import Foundation 初期表示　
import RealmSwift

class Task: Object {
    
    //管理用ID プライマリキー
    dynamic var id = 0
    
    //タイトル
    dynamic var title = ""
    
    //内容
    
    dynamic var contents = ""
    
    //日時
    dynamic var date = NSDate()
    
    //カテゴリ
    dynamic var category = ""
    
    //idをプライマリキーとして設定
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

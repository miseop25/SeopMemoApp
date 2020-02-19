//
//  model.swift
//  seopMemo
//
//  Created by Minseop Kim on 2020/02/19.
//  Copyright © 2020 Minseop Kim. All rights reserved.
//

import Foundation

class Memo {
    
    var content: String
    var insertData : Date
    
    init(content: String) {
        self.content = content
        insertData = Date()
        
    }
    
    static var dummyMemoList = [
        Memo(content: "Seop's firsh memo"),
        Memo(content: "test memo")
    ]
}

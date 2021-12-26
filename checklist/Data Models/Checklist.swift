//
//  Checklist.swift
//  checklist
//
//  Created by TRUC TRUONG on 26.12.2021.
//

import UIKit

class Checklist: NSObject, Codable {
    var name = ""
    var items = [ChecklistItem]()
  
    init(name: String) {
        self.name = name
        super.init()
    }
    
    func countUncheckedItems() -> Int {
        return items.reduce(0) {
            cnt,item in cnt + (item.checked ? 0 : 1)
        }
    }
}

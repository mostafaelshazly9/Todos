//
//  Item.swift
//  Todos
//
//  Created by Mostafa Elshazly on 9/16/18.
//  Copyright © 2018 Mostafa Elshazly. All rights reserved.
//

import Foundation

class Item{

    var title = ""
    var done = false
    init(newTitle: String, doneStatus: Bool) {
        title = newTitle
        done = doneStatus
    }
    convenience init(newTitle:String) {
        self.init(newTitle: newTitle, doneStatus: false)
        //title = newTitle
        //done = false
    }
}

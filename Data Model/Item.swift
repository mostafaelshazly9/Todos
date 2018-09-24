//
//  Item.swift
//  Todos
//
//  Created by Mostafa Elshazly on 9/19/18.
//  Copyright © 2018 Mostafa Elshazly. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title = ""
    @objc dynamic var done = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    @objc dynamic var dateCreated : Date?
}

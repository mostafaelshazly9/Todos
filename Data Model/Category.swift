//
//  Category.swift
//  Todos
//
//  Created by Mostafa Elshazly on 9/19/18.
//  Copyright © 2018 Mostafa Elshazly. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name = ""
    let items = List<Item>()
}

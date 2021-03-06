//
//  Item.swift
//  todoey
//
//  Created by Carlos on 10/11/18.
//  Copyright © 2018 Carlos Santillan. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

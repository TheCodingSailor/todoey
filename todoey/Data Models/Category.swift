//
//  Category.swift
//  todoey
//
//  Created by Carlos on 10/11/18.
//  Copyright © 2018 Carlos Santillan. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}

//
//  Task.swift
//  TO DO List
//
//  Created by Ibrahim Salah on 4/9/19.
//  Copyright © 2019 Ibrahim Salah. All rights reserved.
//

import Foundation
import RealmSwift
class Task: Object {
    @objc dynamic var title : String?
    @objc dynamic var category :Int = 0
    @objc dynamic var createdAt: String?
    @objc dynamic var done:Bool = false
    @objc dynamic var uuid = NSUUID().uuidString
 
    
}

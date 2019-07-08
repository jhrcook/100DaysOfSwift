//
//  Person.swift
//  Project10NamesToFaces
//
//  Created by Joshua on 7/5/19.
//  Copyright © 2019 JHC Dev. All rights reserved.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}

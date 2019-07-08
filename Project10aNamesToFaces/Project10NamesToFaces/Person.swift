//
//  Person.swift
//  Project10NamesToFaces
//
//  Created by Joshua on 7/5/19.
//  Copyright © 2019 JHC Dev. All rights reserved.
//

import UIKit

class Person: NSObject, NSCoding {
    var name: String
    var image: String
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    // NScoding initializer
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
    }
    
    // NSCoding method
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "image")
    }
}

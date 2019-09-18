//
//  HWSProject.swift
//  Project32SwiftSearcher
//
//  Created by Joshua on 9/18/19.
//  Copyright © 2019 JHC Dev. All rights reserved.
//

import Foundation

class HWSProject {
    var name: String
    var subtitle: String
    
    init(name: String, subtitle: String) {
        self.name = name
        self.subtitle = subtitle
    }
    
    func asArray() -> [String] {
        return([name, subtitle])
    }
}

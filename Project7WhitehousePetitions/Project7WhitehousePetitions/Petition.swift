//
//  Petition.swift
//  Project7WhitehousePetitions
//
//  Created by Joshua on 7/2/19.
//  Copyright © 2019 JHC Dev. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}

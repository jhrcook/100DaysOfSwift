//
//  PersonCell.swift
//  Project10NamesToFaces
//
//  Created by Joshua on 7/4/19.
//  Copyright © 2019 JHC Dev. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PersonCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var name: UILabel!
}

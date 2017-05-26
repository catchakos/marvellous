//
//  HeroCollectionViewCell.swift
//  Marvellous
//
//  Created by Maria Pons Sanchez on 27/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import UIKit

class HeroCollectionViewCell: UICollectionViewCell {

    static let cellID = "HeroCollectionViewCell"
    
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(_ name: String, imageURL: String) {
        //TODO: add SDWebImage and use it
        let image = UIImage()
        heroImage.image = image
        heroName.text = name
    }
}

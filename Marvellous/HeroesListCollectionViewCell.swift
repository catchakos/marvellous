//
//  HeroesListCollectionViewCell.swift
//  Marvellous
//
//  Created by Maria Pons Sanchez on 27/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    static func nibName() -> String {
        return String(describing: self)
    }
    
    static func nib() -> UINib {
        return UINib.init(nibName: nibName(), bundle: Bundle.main)
    }
}

class HeroesListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var heroNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    func configureView() {
        
    }

}

//
//  HeroesListCollectionViewCell.swift
//  Marvellous
//
//  Created by Alexandros Katsaprakakis on 27/05/2017.
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
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configure(withName: String?, imageUrl: String?) {
        if let name = withName {
            self.heroNameLabel.text = name
        }else{
            self.heroNameLabel.text = "..."
        }
        
        if let urlString = imageUrl {
            let url = URL(string: urlString)
            self.heroImageView.isHidden = false
            self.heroImageView.sd_setImage(with: url, placeholderImage: nil, options: .refreshCached)            
        }else{
            self.heroImageView.isHidden = true
        }
        
    }
    
}

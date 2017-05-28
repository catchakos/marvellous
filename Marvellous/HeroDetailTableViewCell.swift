//
//  HeroDetailTableViewCell.swift
//  Marvellous
//
//  Created by Alexandros Katsaprakakis on 28/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static func nibName() -> String {
        return String(describing: self)
    }
    
    static func nib() -> UINib {
        return UINib.init(nibName: nibName(), bundle: Bundle.main)
    }
}

class HeroDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

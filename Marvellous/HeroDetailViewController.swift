//
//  HeroDetailViewController.swift
//  Marvellous
//
//  Created by Alexandros Katsaprakakis on 26/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import UIKit
import SDWebImage

protocol HeroDetailViewControllerInput {
    func displayCharacterInfo(_ viewModel: HeroModels.Detail.ViewModel)
}

protocol HeroDetailViewControllerOutput {
    func fetchCharacterInfo(_ request: HeroModels.Detail.Request)
}

class HeroDetailViewController: UIViewController, HeroDetailViewControllerInput {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailDescription: UITextView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var configurator: HeroDetailConfigurator = HeroDetailConfigurator()
    var output: HeroDetailViewControllerOutput?

    var heroDetail: HeroModels.Detail.ViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configurator.configure(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    var detailViewModel: HeroModels.Detail.ViewModel? {
        didSet {
            
        }
    }
    
    func displayCharacterInfo(_ viewModel: HeroModels.Detail.ViewModel) {
        heroDetail = viewModel
        if let label = detailDescriptionLabel {
            label.text = viewModel.name
        }
        if let desc = detailDescription {
            desc.text = viewModel.description
        }
        if let image = detailImageView {
            let url = URL(string: viewModel.thumbnailUrl)
            image.sd_setImage(with: url, placeholderImage: nil, options: .refreshCached)
        }
        
        self.title = viewModel.name
        
        spinner.stopAnimating()
    }

}

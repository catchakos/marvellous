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

class HeroDetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailDescription: UITextView!

    func configureView() {
        // Update the user interface for the detail item.
        if let viewModel = detailViewModel {
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
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailViewModel: HeroModels.Detail.ViewModel? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    func displayCharacterInfo(_ viewModel: HeroModels.Detail.ViewModel) {
        configureView()
    }

}

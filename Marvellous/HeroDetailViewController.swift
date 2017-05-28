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

class HeroDetailViewController: UIViewController, HeroDetailViewControllerInput, UITableViewDataSource {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailDescription: UITextView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var singleTableView: UITableView!
    @IBOutlet weak var seriesTableView: UITableView!
    @IBOutlet weak var comicsTableView: UITableView!
    
    var configurator: HeroDetailConfigurator = HeroDetailConfigurator()
    var output: HeroDetailViewControllerOutput?

    var heroDetail: HeroModels.Detail.ViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configurator.configure(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDetailView()
        
        if let info = heroDetail {
            displayCharacterInfo(info)
        }
    }
    
    func setupDetailView() {
        singleTableView.register(HeroDetailTableViewCell.nib(), forCellReuseIdentifier: HeroDetailTableViewCell.nibName())
        comicsTableView.register(HeroDetailTableViewCell.nib(), forCellReuseIdentifier: HeroDetailTableViewCell.nibName())
        seriesTableView.register(HeroDetailTableViewCell.nib(), forCellReuseIdentifier: HeroDetailTableViewCell.nibName())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    var heroID: Int64? {
        didSet {
            if let identifier = heroID { 
                let request = HeroModels.Detail.Request(characterID: identifier)
                output?.fetchCharacterInfo(request)
            }
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
        
        if let spinner = spinner {
            spinner.stopAnimating()
        }
        
        if singleTableView != nil {
            singleTableView.reloadData()
        }
        if seriesTableView != nil {
            seriesTableView.reloadData()
        }
        if comicsTableView != nil {
            comicsTableView.reloadData()
        }
    }

    // MARK - TableViews DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableView == singleTableView ? 2 : 1
    } 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let detail = heroDetail else { return 0 }
        switch tableView {
        case singleTableView:
            switch section {
            case 0:
                return detail.comicsNames.count >= 20 ? 21 : detail.comicsNames.count
            case 1:
                return detail.seriesNames.count >= 20 ? 21 : detail.seriesNames.count 
            default:
                return 0
            }
        case seriesTableView:
            return detail.seriesNames.count >= 20 ? 21 : detail.seriesNames.count
        case comicsTableView:
            return detail.comicsNames.count >= 20 ? 21 : detail.comicsNames.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: HeroDetailTableViewCell.nibName()) as? HeroDetailTableViewCell {
            var text = "..."
            if let detail = heroDetail {
                switch tableView {
                case singleTableView:
                    switch indexPath.section {
                    case 0:
                        if indexPath.row < detail.comicsNames.count {
                            text = detail.comicsNames[indexPath.row]
                        }
                    case 1:
                        if indexPath.row < detail.seriesNames.count {
                            text = detail.seriesNames[indexPath.row]
                        }
                    default:
                        break
                    }
                case seriesTableView:
                    if indexPath.row < detail.seriesNames.count {
                        text = detail.seriesNames[indexPath.row]
                    }
                case comicsTableView:
                    if indexPath.row < detail.comicsNames.count {
                        text = detail.comicsNames[indexPath.row]
                    }
                default: 
                    break
                }
            }
            cell.nameLabel.text = text
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch tableView {
        case singleTableView:
            switch section {
            case 0:
                return "Comics"
            case 1:
                return "Series"
            default:
                return ""
            }
        case seriesTableView:
            return "Series"
        case comicsTableView:
            return "Comics"
        default:
            return ""
        }
    }
    
}

//
//  HeroesListViewController.swift
//  Marvellous
//
//  Created by Alexandros Katsaprakakis on 27/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import UIKit
import SDWebImage

protocol HeroesListViewControllerInput {
    func displayCharacters(_ viewModel: HeroModels.List.ViewModel)
}

protocol HeroesListViewControllerOutput {
    func fetchDefaultCharacters(_ request: HeroModels.List.Request)
    func fetchCharactersStartingWith(_ request: HeroModels.List.SearchRequest)
}

class HeroesListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, HeroesListViewControllerInput {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var configurator: HeroesListConfigurator = HeroesListConfigurator()
    var output: HeroesListViewControllerOutput?
    
    let itemPadding: CGFloat = 8.0
    let itemHeight: CGFloat = 100.0
    let numberOfColumns: Int = 2
    var collectionItemSize: CGSize = CGSize.zero
        
    private var heroesList: [HeroModels.List.ViewModel]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configurator.configure(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        requestCharacters()
    }
    
    func requestCharacters() {
        let request = CharactersRequest()
        let apiHandler = MarvelApiHandler()
        
        apiHandler.get(request) { (json, error) in
            if let jsonFetched = json {
                let charactersParseRequest = CharactersParseRequest()
                let parser = MarvelParser(request: charactersParseRequest)
                
                if let heroes : [Hero] = parser.parse(json: jsonFetched) as? [Hero] {
                    var heroesListModels: [HeroModels.List.ViewModel] = []
                    for hero in heroes {
                        let vm = HeroModels.List.ViewModel(name: hero.name, thumbnailUrl: hero.thumbnailUrl)
                        heroesListModels.append(vm)
                    }
                    self.heroesList = heroesListModels
                    self.collectionView.performBatchUpdates({
                        let set = IndexSet(integer:0)
                        self.collectionView.reloadSections(set)
                    }, completion: nil)
                    let zeroIndexPath = IndexPath(item: 0, section: 0)
                    self.navigateToDetailAt(indexPath: zeroIndexPath)
                }
            }else{
                // TODO: handle
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if collectionItemSize == CGSize.zero {
            updateCollectionViewLayout(with: view.bounds.size)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateCollectionViewLayout(with: size)
    }
    
    private func updateCollectionViewLayout(with size: CGSize) {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionItemSize = CGSize(width: size.width / CGFloat(numberOfColumns) - CGFloat(numberOfColumns - 1)*itemPadding, height: itemHeight)
            layout.invalidateLayout()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func configureView() {
        let nib = HeroesListCollectionViewCell.nib()
        collectionView.register(nib, forCellWithReuseIdentifier: HeroesListCollectionViewCell.nibName())
        collectionView.allowsSelection = true
    }

    // MARK: - Input 
    func displayCharacters(_ viewModel: HeroModels.List.ViewModel) {
        
    }
    
    // MARK: - CollectionView DataSource & Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let heroes = heroesList {
            return heroes.count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let heroCell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroesListCollectionViewCell.nibName(), for: indexPath) as? HeroesListCollectionViewCell else {
            return UICollectionViewCell() 
        }
        if let hero = heroesList?[indexPath.item] {
            heroCell.heroNameLabel.text = hero.name
            let url = URL(string: hero.thumbnailUrl)
            heroCell.heroImageView.sd_setImage(with: url, placeholderImage: nil, options: .refreshCached)
        }
        return heroCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionItemSize
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateToDetailAt(indexPath: indexPath)
    }

    func navigateToDetailAt(indexPath: IndexPath) {
        if let hero = heroesList?[indexPath.item] {
            let detailVM = HeroModels.Detail.ViewModel(name: hero.name, thumbnailUrl: hero.thumbnailUrl, description: "Hero description text..")
            performSegue(withIdentifier: "showDetail", sender: detailVM)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let controller = (segue.destination as! UINavigationController).topViewController as! HeroDetailViewController
            let detailInfo = sender as! HeroModels.Detail.ViewModel
            controller.detailViewModel = detailInfo
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
    
}

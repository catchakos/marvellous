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
    func displayEmpty(_ viewModel: HeroModels.List.EmptyListViewModel)
}

protocol HeroesListViewControllerOutput {
    func fetchDefaultCharacters(_ request: HeroModels.List.DefaultRequest)
    func fetchCharactersStartingWith(_ request: HeroModels.List.SearchRequest)
    
    func characterIdentifierAt(index: Int) -> Int64?
    func changeListType(typeIndex: Int)
    func nextPage()
}

class HeroesListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, HeroesListViewControllerInput, UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var switcher: UISegmentedControl!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var loadingViewToBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var configurator: HeroesListConfigurator = HeroesListConfigurator()
    var output: HeroesListViewControllerOutput?
    
    let itemPadding: CGFloat = 2.0
    let itemHeight: CGFloat = 100.0
    let numberOfColumns: Int = 2
    var collectionItemSize: CGSize = CGSize.zero
        
    private var heroesList: HeroModels.List.ViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configurator.configure(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        requestCharacters(nil)
    }
    
    func requestCharacters(_ text: String?) {
        if let searchText = text {
            let request = HeroModels.List.SearchRequest(startsWith: searchText)
            output?.fetchCharactersStartingWith(request)
        }else{
            let request = HeroModels.List.DefaultRequest(page: 0)
            output?.fetchDefaultCharacters(request)
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
        automaticallyAdjustsScrollViewInsets = false
        let nib = HeroesListCollectionViewCell.nib()
        collectionView.register(nib, forCellWithReuseIdentifier: HeroesListCollectionViewCell.nibName())
        collectionView.allowsSelection = true
    }

    // MARK: - Input 
    func displayCharacters(_ viewModel: HeroModels.List.ViewModel) {
        self.messageLabel.isHidden = true
        UIView.animate(withDuration: 0.4) { 
            self.collectionView.alpha = 1.0
            self.messageLabel.alpha = 0.0
            self.switcher.selectedSegmentIndex = viewModel.type == .AllHeroes ? 0 : 1
        }

        switch viewModel.type {
        case .AllHeroes:
            searchBar.resignFirstResponder()
            searchBar.text = ""
        case .Search:
            break
        }
        
        let firstHeroesDisplayed : Bool = viewModel.type == .AllHeroes && self.heroesList?.items == nil
        
        self.heroesList = viewModel
        self.collectionView.performBatchUpdates({
            let set = IndexSet(integer:0)
            self.collectionView.reloadSections(set)
        }, completion: nil)
        
        if firstHeroesDisplayed && splitViewController?.traitCollection.horizontalSizeClass == .regular {
            let zeroIndexPath = IndexPath(item: 0, section: 0)
            self.navigateToDetailAt(indexPath: zeroIndexPath)            
        }
                
        changeSpinnerState(viewModel.isLoading)
        
        switcher.isUserInteractionEnabled = !viewModel.isLoading
    }
    
    func displayEmpty(_ viewModel: HeroModels.List.EmptyListViewModel) {
        self.messageLabel.text = viewModel.message
        self.messageLabel.isHidden = false
        UIView.animate(withDuration: 0.4) { 
            self.collectionView.alpha = 0.0
            self.messageLabel.alpha = 1.0
            self.switcher.selectedSegmentIndex = viewModel.type == .AllHeroes ? 0 : 1
        }
        changeSpinnerState(viewModel.isLoading)
        
        switcher.isUserInteractionEnabled = !viewModel.isLoading
    }
    
    func changeSpinnerState(_ loading: Bool) {
        if loading {
            spinner.startAnimating()
            UIView.animate(withDuration: 0.3, animations: { 
                self.loadingViewToBottomConstraint.constant = 0.0
            })
        }else{
            spinner.stopAnimating()
            UIView.animate(withDuration: 0.3, animations: { 
                self.loadingViewToBottomConstraint.constant = -50.0
            })
        }
    }
    
    // MARK: - CollectionView DataSource & Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let heroes = heroesList {
            return heroes.items.count
            
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let heroCell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroesListCollectionViewCell.nibName(), for: indexPath) as? HeroesListCollectionViewCell else {
            return UICollectionViewCell() 
        }
        let hero = heroesList?.items[indexPath.item]
        heroCell.configure(withName:hero?.name, imageUrl: hero?.thumbnailUrl)
        return heroCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionItemSize
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateToDetailAt(indexPath: indexPath)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            if (scrollView.contentOffset.y + scrollView.bounds.size.height >= scrollView.contentSize.height) {
                output?.nextPage()
            }
        }
    }
    
    func navigateToDetailAt(indexPath: IndexPath) {
        if let heroID = output?.characterIdentifierAt(index: indexPath.item) {
            performSegue(withIdentifier: "showDetail", sender: heroID)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let controller = (segue.destination as! UINavigationController).topViewController as? HeroDetailViewController, 
                  let detailID = sender as? Int64 
                else{
                    return
                }
            controller.heroID = detailID
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
    
    //MARK - Search
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            if text.characters.count > 0 {
                requestCharacters(text)
            }
            searchBar.resignFirstResponder()
        }
    }
    
    // MARK - List type segmented control Switcher action
    @IBAction func switcherDidChange(_ sender: UISegmentedControl) {
        output?.changeListType(typeIndex: sender.selectedSegmentIndex)
    }
}

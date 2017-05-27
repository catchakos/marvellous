//
//  HeroesListViewController.swift
//  Marvellous
//
//  Created by Alexandros Katsaprakakis on 27/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import UIKit

class HeroesListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var heroDetailViewController: HeroDetailViewController?
    
    let itemPadding: CGFloat = 8.0
    let numberOfColumns: Int = 2
        
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        if let split = splitViewController {
            let controllers = split.viewControllers
            heroDetailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? HeroDetailViewController
            
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func configureView() {
        let nib = HeroesListCollectionViewCell.nib()
        collectionView.register(nib, forCellWithReuseIdentifier: HeroesListCollectionViewCell.nibName())
        collectionView.allowsSelection = true
    }

    // MARK: - CollectionView DataSource & Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let heroCell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroesListCollectionViewCell.nibName(), for: indexPath)
        return heroCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width / CGFloat(numberOfColumns) - CGFloat(numberOfColumns - 1)*itemPadding, height: 100.0)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: indexPath)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let controller = (segue.destination as! UINavigationController).topViewController as! HeroDetailViewController
            let indexPath = sender as! IndexPath
            controller.detailItem = indexPath.description
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
}

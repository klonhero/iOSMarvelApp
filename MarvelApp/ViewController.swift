//
//  ViewController.swift
//  MarvelApp
//
//  Created by effective_macbook_pro on 20.02.2023.
//

import UIKit
import CollectionViewPagingLayout

class ViewController: UIViewController, UICollectionViewDataSource {
    var marvelLogoView: UIImageView!
    var heroesCollectionView: UICollectionView!
    var underLogoText: UITextView!
    var backgroundColor = UIColor(named: "BackgroundColor")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        setupMarvelLogo()
        setupUnderLogoText()
        setupHeroesCollection()
    
    }
    
    private func setupMarvelLogo() {
        marvelLogoView = UIImageView()
        marvelLogoView.translatesAutoresizingMaskIntoConstraints = false
        marvelLogoView.image = UIImage(named: "marvelLogo")
        view.addSubview(marvelLogoView)
        
        NSLayoutConstraint.activate([
            marvelLogoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            marvelLogoView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            marvelLogoView.widthAnchor.constraint(equalToConstant: 200),
            marvelLogoView.heightAnchor.constraint(equalToConstant: 75)
            ])
    }
    
    private func setupUnderLogoText() {
        underLogoText = UITextView()
        underLogoText.translatesAutoresizingMaskIntoConstraints = false
        underLogoText.textColor = UIColor(named: "UnderLogoTextColor")
        underLogoText.text = "Choose your hero"
        underLogoText.isUserInteractionEnabled = false
        underLogoText.textAlignment = .center
        underLogoText.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        underLogoText.backgroundColor = backgroundColor
        view.addSubview(underLogoText)
        
        NSLayoutConstraint.activate([
            underLogoText.topAnchor.constraint(equalTo: marvelLogoView.bottomAnchor),
            underLogoText.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            underLogoText.widthAnchor.constraint(equalToConstant: 400),
            underLogoText.heightAnchor.constraint(equalToConstant: 75)
            ])
    }
    
    private func setupHeroesCollection() {
        let layout = CollectionViewPagingLayout()
        heroesCollectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        heroesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        heroesCollectionView.isPagingEnabled = true
        heroesCollectionView.register(MyCell.self, forCellWithReuseIdentifier: "cell")
        heroesCollectionView.backgroundColor = backgroundColor
        heroesCollectionView.dataSource = self
        view.addSubview(heroesCollectionView)
        
        NSLayoutConstraint.activate([
            heroesCollectionView.topAnchor.constraint(equalTo: underLogoText.bottomAnchor),
            heroesCollectionView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            heroesCollectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            heroesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            10
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
       }

}

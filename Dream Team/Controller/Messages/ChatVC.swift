//
//  ChatVC.swift
//  Dream Team
//
//  Created by Student on 28.05.2020.
//  Copyright © 2020 Alla Kim. All rights reserved.
//


import UIKit

private let reuseIdentifier = "Cell"

class ChatVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var user: User?
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = .systemBackground

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        configureNavBar()
    }
    
    fileprivate func configureNavBar() {
        guard let user = self.user else {return}
        navigationItem.title = "@\(user.username ?? "")"
        
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(handleInfoButtonTapped), for: .touchUpInside)
        
        let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
        navigationItem.rightBarButtonItem = infoBarButtonItem
    }
  
    @objc fileprivate func handleInfoButtonTapped() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        return cell
    }

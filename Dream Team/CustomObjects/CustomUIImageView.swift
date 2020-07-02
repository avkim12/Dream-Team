//
//  CustomUIImageView.swift
//  Dream Team
//
//  Created by Student on 5/26/20.
//  Copyright © 2020 Alla Kim. All rights reserved.
//

import UIKit

class CustomUIImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    private func configure() {
        contentMode = .scaleAspectFill
        backgroundColor = .lightGray
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

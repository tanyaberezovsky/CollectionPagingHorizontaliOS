//
//  SortcutCollectionViewCell.swift
//  SpringboardCollectionPagingHorizontal
//
//  Created by Tanya Berezovsky on 25/02/2019.
//  Copyright © 2019 Tanya Berezovsky. All rights reserved.
//

import UIKit

class SortcutCollectionViewCell: UICollectionViewCell {
    static var identifier: String = "SortcutCollectionViewCell"
    
    var button: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commoninit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commoninit() {
        button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font =   UIFont.boldSystemFont(ofSize: 22)
        button.backgroundColor = UIColor.purple
        
        self.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: self.topAnchor),
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
    }
    
}

//
//  FeedCollectionViewCell.swift
//  DemoTestapp
//
//  Created by Prashanth reddy on 8/26/20.
//  Copyright © 2020 Prashanth reddy. All rights reserved.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var dateFieldLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        self.thumbnailImageView.layer.cornerRadius = 12.0
        self.thumbnailImageView.layer.masksToBounds = true
    }
}


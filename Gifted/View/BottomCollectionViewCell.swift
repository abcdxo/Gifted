//
//  MenuCell.swift
//  Gifted
//
//  Created by Nick Nguyen on 4/24/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

class BottomCollectionViewCell: UICollectionViewCell
{
  
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var menuImage: UIImageView!
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 16
        clipsToBounds = true
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
      
    }
    
   
}

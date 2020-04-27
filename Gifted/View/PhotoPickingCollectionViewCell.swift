//
//  PhotoPickingCollectionViewCell.swift
//  Gifted
//
//  Created by Nick Nguyen on 4/25/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

class PhotoPickingCollectionViewCell: UICollectionViewCell
{
    
    //MARK:- Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var checkMark: UIImageView!
        {
        didSet
        {
            checkMark.layer.masksToBounds = true
            checkMark.layer.cornerRadius = checkMark.frame.size.width / 2
        }
    }
    
 //MARK:- Init
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)

    }
    
    //MARK:- Properties
    
    override var isSelected: Bool
        {
        didSet
        {
            checkMark.image = isSelected ?  UIImage(systemName: "checkmark.circle.fill")!: UIImage(systemName: "")
            checkMark.backgroundColor = isSelected ? .white : .none
        }
    }
    
    override var isHighlighted: Bool
        {
        didSet {  toggleIsHighlighted()  }
    }
    
    private func toggleIsHighlighted()
    {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [.curveEaseOut,.transitionFlipFromLeft],
                       animations: {
                        self.alpha = self.isHighlighted ? 0.9 : 5.0
                        self.transform = self.isHighlighted ? CGAffineTransform.identity.scaledBy(x: 2.0, y: 2.0) : CGAffineTransform.identity
                        
        })
    }
}

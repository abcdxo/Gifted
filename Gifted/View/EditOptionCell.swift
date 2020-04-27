//
//  EditOptionCell.swift
//  Gifted
//
//  Created by Nick Nguyen on 4/26/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

class EditOptionCell: UICollectionViewCell
{
    let optionImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let optionLabel : UILabel = {
       let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 12)
        lb.textAlignment = .center
        lb.textColor = .darkGray
        return lb
    }()
    lazy var optionStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.addArrangedSubview(optionImageView)
        stackView.addArrangedSubview(optionLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViewsForCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViewsForCell()
    }
    
    
    private func setUpViewsForCell()
    {
        addSubview(optionStackView)
        NSLayoutConstraint.activate([
            optionStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            optionStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            optionStackView.topAnchor.constraint(equalTo: topAnchor),
            optionStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        
        ])
    }
    
}

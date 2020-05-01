//
//  FilterCell.swift
//  Gifted
//
//  Created by Nick Nguyen on 4/30/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {
    
    let filterImageView: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.backgroundColor = .black
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.cornerRadius = 6
        return view
    }()
    
    let filterNameLabel: UILabel = {
       let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 12)
        lb.textAlignment = .center
//        lb.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return lb
    }()
    
    
    lazy var verticalStackView: UIStackView = {
        let verticalStackView = UIStackView(arrangedSubviews: [self.filterImageView,self.filterNameLabel])
        verticalStackView.distribution = .fill
        verticalStackView.alignment = .fill
        
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 0
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        return verticalStackView
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    
    private func setUpViews() {
        
        addSubview(verticalStackView)
        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            verticalStackView.topAnchor.constraint(equalTo: topAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        
        ])
    }
}

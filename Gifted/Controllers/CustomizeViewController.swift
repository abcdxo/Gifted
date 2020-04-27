//
//  CustomizeViewController.swift
//  Gifted
//
//  Created by Nick Nguyen on 4/26/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit


class CustomizeViewController: UIViewController
{
    //MARK:- Properties
    
    let options = ["Speed","Boomerang","Canvas","Reorder","Filter","Stickers","Text","Tune"]
    var imagesToMakeGIF: [UIImage]?
    
    //MARK:- Outlets
    
    @IBOutlet weak var gif: UIImageView!
    @IBOutlet weak var optionCollectionView: UICollectionView!
        {
        didSet {
            optionCollectionView.delegate = self
            optionCollectionView.dataSource = self
        }
    }
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let images = imagesToMakeGIF else  { return }
        print("images to make GIF : \(images.count)")
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let images = imagesToMakeGIF else  { return }
        let animatedImage = UIImage.animatedImage(with: images, duration: 1.0)
        
        let imageView = UIImageView(image: animatedImage)
        imageView.animationRepeatCount = 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.startAnimating()
        
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: gif.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: gif.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: gif.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: gif.bottomAnchor)
        ])
        
        DispatchQueue.main.async {   self.gif = imageView  }
        print(gif.animationDuration)
        
    }
 
    //MARK:- Actions
    
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem)
    {
       print("Stopp")
      
        gif.stopAnimating()
    }
    
 

}
extension CustomizeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.editCell.rawValue, for: indexPath) as! EditOptionCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
}

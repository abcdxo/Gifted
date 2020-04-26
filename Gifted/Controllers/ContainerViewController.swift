//
//  ContainerViewController.swift
//  Gifted
//
//  Created by Nick Nguyen on 4/26/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit



class ContainerViewController: UIViewController
{
    
    var images: [UIImage]?
    

    @IBOutlet weak var containerCollectionView: UICollectionView! {
        didSet {
            containerCollectionView.delegate = self
            containerCollectionView.dataSource = self
          
        }
    }
    // MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let flowLayout = self.containerCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(didGetPhotos(_:)), name: NSNotification.Name("NewPhoto"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        
     
    }
    
   
  
    @IBAction func deSelectAllButtonPressed(_ sender: UIButton) {
        print("deselect")
        images?.removeAll()
        containerCollectionView.reloadData()
       NotificationCenter.default.post(name: NSNotification.Name("Close"), object: nil)
    }
    
    
    
    @IBAction func nextStepButtonPressed(_ sender: UIButton) {
        print("nextstep")
    }
    
    
    
    @objc func didGetPhotos(_ notification: Notification) {
        guard let userInfo = notification.userInfo,  let photos = userInfo["Photos"] as? [UIImage] else { return }
        self.images = photos
      
        containerCollectionView.reloadData()
       
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
   

}
//MARK:- Datasource

extension ContainerViewController: UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource
{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5.0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HorizontalBottomCollectionViewCell
        
        let image = images![indexPath.row]
        DispatchQueue.main.async {  cell.imageView.image = image }
        
        return cell
    }
    
}

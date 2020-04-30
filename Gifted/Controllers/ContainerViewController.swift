//
//  ContainerViewController.swift
//  Gifted
//
//  Created by Nick Nguyen on 4/26/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController, HorizontalBottomCollectionViewCellDelegate
{
    func didRemoveItem(for cell: HorizontalBottomCollectionViewCell) {
       
        let item = containerCollectionView.indexPath(for: cell)
       let position =  PhotoPickingCollectionViewController.selectedImages.firstIndex(of:  PhotoPickingCollectionViewController.selectedImages[item!.item])
        let userInfo: [String:Any] = ["IndexPath": item!,"Position":position!]
        PhotoPickingCollectionViewController.selectedImages.remove(at: item!.item)
        countLabel.text = "(\(PhotoPickingCollectionViewController.selectedImages.count))"
    
            NotificationCenter.default.post(name: NSNotification.Name("Zero"), object: nil,userInfo:userInfo )
        
        containerCollectionView.reloadData()
    }
    
    
    var images: [UIImage]?
    
    @IBOutlet weak var countLabel: UILabel! {
        didSet {
            countLabel.text = "\(String(describing: images?.count))"
        }
    }
    
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
 
    @IBAction func deSelectAllButtonPressed(_ sender: UIButton) {
        print("deselect")
        images?.removeAll()
        containerCollectionView.reloadData()
       NotificationCenter.default.post(name: NSNotification.Name("Close"), object: nil)
    }
    
    
    
    @IBAction func nextStepButtonPressed(_ sender: UIButton) {
        print("nextstep \(String(describing: images!.count))")
        let vc = (storyboard!.instantiateViewController(identifier: "sd")) as! CustomizeViewController
        vc.imagesToMakeGIF = images
        navigationController!.pushViewController(vc, animated: true)
    }
    
    
    
    @objc func didGetPhotos(_ notification: Notification) {
        guard let userInfo = notification.userInfo,  let photos = userInfo["Photos"] as? [UIImage] else { return }
        self.images = photos
        
        countLabel.text = "(\(photos.count))"
        containerCollectionView.reloadData()
//        let lastSection = containerCollectionView.numberOfSections - 1
        
        let lastRow = containerCollectionView.numberOfItems(inSection: 0)
        
        let indexPath = IndexPath(row: lastRow - 1, section: 0)
        
        self.containerCollectionView.scrollToItem(at: indexPath, at: .right, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
   

}
//MARK:- Datasource

extension ContainerViewController: UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource
{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        return CGSize(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return PhotoPickingCollectionViewController.selectedImages.count
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.containerCollectionViewCell.rawValue, for: indexPath) as! HorizontalBottomCollectionViewCell
        cell.delegate = self
        let image = PhotoPickingCollectionViewController.selectedImages[indexPath.row]
         cell.imageView.image = image 
        
        return cell
    }
    
}

//
//  ReorderCollectionViewController.swift
//  Gifted
//
//  Created by Nick Nguyen on 4/28/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ReorderCell"

protocol ReorderCollectionViewControllerDelegate: class {
    func didReorder(images: [UIImage])
}

extension ReorderCollectionViewController:UICollectionViewDragDelegate,UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = self.images![indexPath.row]
        let itemProvider = NSItemProvider(object: item as UIImage)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        var destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(item: row - 1 , section: 0)
        }
        if coordinator.proposal.operation == .move {
            self.reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move,intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }
     
}

class ReorderCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIDropInteractionDelegate {
    weak var delegate : ReorderCollectionViewControllerDelegate?
    
    fileprivate func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        if let item = coordinator.items.first, let sourceIndexPath = item.sourceIndexPath {
            collectionView.performBatchUpdates({
                self.images?.remove(at: sourceIndexPath.item)
                self.images?.insert(item.dragItem.localObject as! UIImage, at: destinationIndexPath.item)
                
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            }, completion: nil)
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
    }

    
    var images: [UIImage]?
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.dragInteractionEnabled = true
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self


        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(images!.count)
        collectionView.addInteraction(UIDropInteraction(delegate: self))
        collectionView.addInteraction(UIDropInteraction(delegate: self))
        
        collectionView.dragInteractionEnabled = true
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        self.collectionView!.register(ReorderCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        navigationController?.isToolbarHidden = false
        navigationController?.navigationBar.isHidden = true
        
        let button = UIBarButtonItem(image: UIImage(systemName: "multiply"), style: .done, target: self, action: #selector(handleDone))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let title = UIBarButtonItem(title: "Reorder", style: .plain, target: nil, action: nil)
        title.isEnabled = false
        let flexibleSpace2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let check = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .done, target: self, action: #selector(handleCheck))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleBack))
        
        self.toolbarItems = [button,flexibleSpace,title,flexibleSpace2,check] //
        navigationController?.setToolbarHidden(false, animated: false)
        
    }
    @objc func handleCheck() {
        print("check")
        delegate?.didReorder(images: images!)
         navigationController?.popViewController(animated: true)
    }

 
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return images!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ReorderCollectionViewCell
        cell.imageView.image = images![indexPath.item]
    
        return cell
    }
    @objc func handleDone() {
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func handleBack() {
       navigationController?.popViewController(animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = collectionView.frame.size.width
        return CGSize(width: collectionViewSize / 6, height: collectionViewSize / 6 )
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 10.0)
    }
}

//
//  PhotoSelectorController.swift
//  Theday
//
//  Created by Ali Sanaknaki on 2020-04-13.
//  Copyright © 2020 Ali Sanaknaki. All rights reserved.
//


import UIKit
import Photos

class PhotoSelectorController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var selectedImage: UIImage?
    var images = [UIImage]()
    var assets = [PHAsset]()
    var previousClickIndex = IndexPath()
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        collectionView.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.alwaysBounceVertical = true
        
        setupNavigationButtons()
        
        fetchPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    fileprivate func assetsFetchOptions() -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 10
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        
        return fetchOptions
    }
    
    fileprivate func fetchPhotos() {
        let allPhotos = PHAsset.fetchAssets(with: .image, options: assetsFetchOptions())
        
        // Grabbing of photos will happen in the background as view loads and then fill data in main thread
        DispatchQueue.global(qos: .background).async {
            allPhotos.enumerateObjects { (asset, count, stop) in
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true // Gets better thumbnail image in grid
                
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                    if let image = image {
                        self.images.append(image)
                        self.assets.append(asset)
                        
                        if self.selectedImage == nil {
                            self.selectedImage = image
                        }
                    }
                    
                    if count == allPhotos.count - 1 {
                        // Go back to main thread
                        DispatchQueue.main.async {
                            // Only want to call this when you're done fetching all images
                            self.collectionView.reloadData()
                        }
                    }
                })
            }
        }
    }
    
    fileprivate func setupNavigationButtons() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
    }
    
    @objc func handleCancel() { dismiss(animated: true, completion: nil) }
    @objc func handleNext() {
        let postPhotoController = PostPhotoController()
        
        postPhotoController.selectedImage = selectedImage
        
        navigationController?.pushViewController(postPhotoController, animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoSelectorCell
        
         cell.photoImageView.image = images[indexPath.item]

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    // Vertical spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // Horizontal spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationItem.rightBarButtonItem?.isEnabled = true
        
        if(previousClickIndex.count == 0) { // First item clicked
            previousClickIndex = indexPath
            let cell = collectionView.cellForItem(at: indexPath) as! PhotoSelectorCell
            cell.photoImageView.alpha = 0.5
                
            let selectedAsset = self.assets[indexPath.item]
            let imageManager = PHImageManager.default()
            let targetSize = CGSize(width: view.frame.width, height: view.frame.height)
            imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .aspectFit , options: nil) { (image, info) in
                self.selectedImage = image
            }
            
            // rselectedImage = cell.photoImageView.image
        
        } else { // Picking another image instead
            let cell = collectionView.cellForItem(at: previousClickIndex) as! PhotoSelectorCell
            cell.photoImageView.alpha = 1
            
            let newCell = collectionView.cellForItem(at: indexPath) as! PhotoSelectorCell
            newCell.photoImageView.alpha = 0.5
            
            selectedImage = newCell.photoImageView.image
            
            let selectedAsset = self.assets[indexPath.item]
            let imageManager = PHImageManager.default()
            let targetSize = CGSize(width: view.frame.width, height: view.frame.height)
            imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .aspectFill , options: nil) { (image, info) in
                self.selectedImage = image
            }
            
            previousClickIndex = indexPath
        }
    }
}

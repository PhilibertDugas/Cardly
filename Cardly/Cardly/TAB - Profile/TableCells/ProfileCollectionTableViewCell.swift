//
//  CollectionTableViewCell.swift
//  Cardly
//
//  Created by Guillaume Lalande on 2016-09-27.
//  Copyright © 2016 QH4L. All rights reserved.
//

import UIKit
import AVFoundation

class ProfileCollectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var CollectionTitle: UILabel!
    @IBOutlet weak var CollectionInfo: UILabel!
    @IBOutlet weak var CollectionContentView: UICollectionView!
    
    var photos = Photo.allPhotos()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Set the CollectionLayout delegate
        if let layout = CollectionContentView?.collectionViewLayout as? CollectionLayout {
            layout.delegate = self
        }
        
        CollectionContentView.delegate = self
        CollectionContentView.dataSource = self
        
        CollectionContentView.backgroundColor = UIColor.clear
        CollectionContentView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ProfileCollectionTableViewCell: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnotatedPhotoCell", for: indexPath as IndexPath) as! AnnotatedPhotoCell
        cell.photo = photos[indexPath.item]
        return cell
    }
}

extension ProfileCollectionTableViewCell: UICollectionViewDelegate
{
}

extension ProfileCollectionTableViewCell: CollectionLayoutDelegate
{
    func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath, withWidth: CGFloat) -> CGFloat
    {
        let photo = photos[indexPath.item]
        let boundingRect =  CGRect(x: 0, y: 0, width: withWidth, height: CGFloat(MAXFLOAT))
        let rect = AVMakeRect(aspectRatio: photo.image.size, insideRect: boundingRect)
        return rect.size.height
    }
    
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        let annotationPadding = CGFloat(4)
        let annotationHeaderHeight = CGFloat(17)
        
        let photo = photos[indexPath.item]
        let font = UIFont(name: "AvenirNext-Regular", size: 10)!
        let commentHeight = photo.heightForComment(font: font, width: width)
        let height = annotationPadding + annotationHeaderHeight + commentHeight + annotationPadding
        return height
    }
}

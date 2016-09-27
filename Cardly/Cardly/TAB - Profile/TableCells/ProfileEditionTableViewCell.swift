//
//  ProfileEditionTableViewCell.swift
//  Cardly
//
//  Created by Guillaume Lalande on 2016-09-27.
//  Copyright © 2016 QH4L. All rights reserved.
//

import UIKit

class ProfileEditionTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ProfileEditionTableViewCell: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //TODO
        
        return UICollectionViewCell()
    }
}

extension ProfileEditionTableViewCell: UICollectionViewDelegate
{
}

extension ProfileEditionTableViewCell: CollectionLayoutDelegate
{
    func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath, withWidth: CGFloat) -> CGFloat
    {
        //TODO
        
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        
        //TODO
        
        return 0
    }
}

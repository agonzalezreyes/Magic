//
//  BackgroundsTableViewCell.swift
//  FinalProject
//
//  Created by Alejandrina Gonzalez on 12/9/17.
//  Copyright © 2017 Alejandrina Gonzalez. All rights reserved.
//

import UIKit

protocol BackgroundCellDelegate: NSObjectProtocol {
    func didSelectCellFrom(_ backgroundsTableViewCell: BackgroundsTableViewCell, at index: Int)
}

class BackgroundsTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var backgroundsCollectionView: UICollectionView! {
        didSet {
            backgroundsCollectionView.dataSource = self
            backgroundsCollectionView.delegate = self
        }
    }
    var colors = [UIColor]()
    public weak var delegate: BackgroundCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // MARK - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BackgroundColorCell", for: indexPath) as! BackgroundCollectionViewCell
        cell.colorImageView.backgroundColor = colors[indexPath.row]
        return cell
    }
    
    // MARK - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelectCellFrom(self, at: indexPath.row)
    }
    
    // MARK - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.bounds.width - 20) / 5
        return CGSize(width: cellWidth, height: self.frame.size.height - 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0.0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0.0)
    }
    
}

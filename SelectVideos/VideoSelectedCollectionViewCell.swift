//
//  VideoSelectedCollectionViewCell.swift
//  SelectVideos
//
//  Created by đào sơn on 16/05/2022.
//

import UIKit
import Photos

protocol VideoSelectedCollectionViewCellDelegate
{
    func videoSelectedCollectionViewCell(_ cell: UICollectionViewCell, _ deletedAsset: PHAsset)
}
class VideoSelectedCollectionViewCell: UICollectionViewCell {
    var delegate: VideoSelectedCollectionViewCellDelegate?
    var asset: PHAsset!
    @IBOutlet weak var deleteSelectedVideoButton: UIButton!
    @IBOutlet weak var selectedVideoImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func deleteSelectedVideo(_ sender: UIButton) {
        delegate?.videoSelectedCollectionViewCell(self, asset)
    }
}

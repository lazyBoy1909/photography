//
//  CollectionViewCell.swift
//  SelectVideos
//
//  Created by đào sơn on 13/05/2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    var imageArray: [UIImage]!
    func initGUI()
    {
//        self.countLabel.layer.borderWidth = 3
//        self.countLabel.layer.borderColor = CGColor(red: 255, green: 0, blue: 0, alpha: 1)
//        self.videoImageView.layer.borderColor = CGColor(red: 255, green: 0, blue: 0, alpha: 1)
//        self.videoImageView.layer.borderWidth = 3
            self.layer.cornerRadius = 4
        self.countLabel.isHidden = true

        let view = UIView(frame: CGRect(x: 0, y: 0, width: 140, height: 140))
        let gradient = CAGradientLayer()

        gradient.frame = view.frame

        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]

        gradient.locations = [0.7, 1.0]

        view.layer.insertSublayer(gradient, at: 0)
        videoImageView.addSubview(view)
//



    }
    override func awakeFromNib() {
        super.awakeFromNib()
        initGUI()
        // Initialization code
    }

}

//
//  ViewController.swift
//  SelectVideos
//
//  Created by đào sơn on 13/05/2022.
//

import UIKit
import Photos
class ViewController: UIViewController {

    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var selectVideosLabel: UILabel!
    @IBOutlet weak var detailSelectVideosLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var videoCollectionView: UICollectionView!
    
    @IBOutlet weak var imageContainerSrollView: UIScrollView!
    @IBOutlet weak var addVideoView: UIView!
    var assetImages: [PHAsset] = []
    var videos = ["video", "video", "video", "video", "video", "video", "video", "video", "video", "video", "video", "video", "video", "video", "video", "video","video", "video", "video", "video"]
    var selectedVideos: [Int] = []
    func initGUI()
    {
        videoCollectionView.insertSubview(addVideoView, aboveSubview: self.videoCollectionView)
        addButton.layer.cornerRadius = 4
    }
    
    
    private func loadData()
    {
        PHPhotoLibrary.requestAuthorization
        {
            status in
            if(status == .authorized)
            {
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.video, options: nil)
                assets.enumerateObjects{
                (object,_,_) in
                    print(object.duration)
                    self.assetImages.append(object)
                }
                self.assetImages.reverse()
                DispatchQueue.main.async {
                    self.videoCollectionView.reloadData()
                }
            }
        }
    }
    func onSelectedMode()
    {
        addVideoView.isHidden = false
    }
    func offSelectedMode()
    {
        addVideoView.isHidden = true
    }
    func updateVideosSelection()
    {
        if(selectedVideos.count == 0)
        {
            offSelectedMode()
        }
        else
        {
            onSelectedMode()
            var i = 1
            for value in selectedVideos
            {
                let indexpath = IndexPath(row: value, section: 0)
                let cell = videoCollectionView.cellForItem(at: indexpath) as! CollectionViewCell
                cell.countLabel.text = "\(i)"
                i += 1
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initGUI()
        loadData()
        videoCollectionView.delegate = self
        videoCollectionView.dataSource = self
        videoCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CollectionViewCell")
        // Do any additional setup after loading the view.
    }
    //convert time
    func durationTransfer(duration: Double) -> String
    {
        var res: String
        let interval = Int(duration)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        res = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        if(interval < 60)
        {
            let index = res.index(res.endIndex, offsetBy: -5)
            res = String(res.suffix(from: index))
        }
        return res
    }

}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assetImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = videoCollectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let asset = self.assetImages[indexPath.row]
        let manager = PHImageManager.default()
//        manager.requestPlayerItem(forVideo: asset, options: nil)
        manager.requestImage(for:  asset, targetSize: CGSize(width: 500,height: 500), contentMode: .aspectFit, options: nil)
        {
            image,_ in
            DispatchQueue.main.async {
                cell.videoImageView.image = image
            }
        }
        cell.durationLabel.text = durationTransfer(duration: asset.duration)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (videoCollectionView.bounds.width - 12)/3
        let height = width
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        //video is not selected
        if(selectedVideos.firstIndex(of: indexPath.row) ==  nil)
        {
            
            cell.countLabel.layer.borderWidth = 3
            cell.countLabel.layer.borderColor = CGColor(red: 255, green: 0, blue: 0, alpha: 1)
            cell.countLabel.text = "\(selectedVideos.count)"
            cell.videoImageView.layer.borderColor = CGColor(red: 255, green: 0, blue: 0, alpha: 1)
            cell.videoImageView.layer.borderWidth = 3
            cell.countLabel.isHidden = false
            selectedVideos.append(indexPath.row)
            let selectedImageView = UIImageView(frame: CGRect(x: imageContainerSrollView.frame.width/5*CGFloat(selectedVideos.count-1), y: 10, width: imageContainerSrollView.frame.width/5, height: imageContainerSrollView.frame.height-20))
            selectedImageView.image = cell.videoImageView.image
            imageContainerSrollView.addSubview(selectedImageView)
        }
        else
        {
            cell.videoImageView.layer.borderWidth = 0
            cell.videoImageView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0)
            cell.countLabel.isHidden = true
            selectedVideos = selectedVideos.filter{
                $0 != indexPath.row
            }
        }
        updateVideosSelection()
    }
}


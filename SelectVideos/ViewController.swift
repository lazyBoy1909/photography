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
    @IBOutlet weak var addVideoView: UIView!
    @IBOutlet weak var selectedVideoCollectionView: UICollectionView!
    var assetImages: [(PHAsset,Int)] = []
    func selectedAssetImages() -> [(PHAsset,Int)]
    {
        return assetImages.filter{
            $0.1 >= 0
        }.sorted{
            $0.1 < $1.1
        }
    }
    func unSelectedAssetImages() -> [(PHAsset,Int)]
    {
        return assetImages.filter{
            $0.1 ==  -1
        }
    }
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
                    self.assetImages.append((object,-1))
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
        var selectedVideos = selectedAssetImages()
        if(selectedVideos.count == 0)
        {
            offSelectedMode()
        }
        else
        {
            onSelectedMode()
//            var i = 1
//            for value in selectedVideos
//            {
//                let index = assetImages.firstIndex(where: {$0.0 == value.0})!
//                let indexpath = IndexPath(row: index, section: 0)
//                let cell = videoCollectionView.cellForItem(at: indexpath) as! CollectionViewCell
//                cell.countLabel.text = "\(i)"
//                i += 1
//            }
        }
        for index in 0...assetImages.count-1
        {
            let cell = videoCollectionView.cellForItem(at: IndexPath(row: index, section: 0)) as! CollectionViewCell
            if(assetImages[index].1 >= 0)
            {
                
                cell.countLabel.layer.borderWidth = 3
                cell.countLabel.layer.borderColor = CGColor(red: 255, green: 0, blue: 0, alpha: 1)
                cell.countLabel.text = "\(assetImages[index].1)"
                cell.videoImageView.layer.borderColor = CGColor(red: 255, green: 0, blue: 0, alpha: 1)
                cell.videoImageView.layer.borderWidth = 3
                cell.countLabel.isHidden = false
            }
            else
            {
                cell.videoImageView.layer.borderWidth = 0
                cell.videoImageView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0)
                cell.countLabel.isHidden = true
            }
        }
        selectedVideoCollectionView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initGUI()
        loadData()
        videoCollectionView.delegate = self
        videoCollectionView.dataSource = self
        selectedVideoCollectionView.delegate = self
        selectedVideoCollectionView.dataSource = self
        selectedVideoCollectionView.register(UINib(nibName: "VideoSelectedCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "VideoSelectedCollectionViewCell")
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
        if(collectionView ==  videoCollectionView)
        {
            return assetImages.count
        }
        else
        {
            return selectedAssetImages().count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == videoCollectionView)
        {
            let cell = videoCollectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            let asset = self.assetImages[indexPath.row].0
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
            if(assetImages[indexPath.row].1 >= 0)
            {
                
                cell.countLabel.layer.borderWidth = 3
                cell.countLabel.layer.borderColor = CGColor(red: 255, green: 0, blue: 0, alpha: 1)
                cell.countLabel.text = "\(assetImages[indexPath.row].1)"
                cell.videoImageView.layer.borderColor = CGColor(red: 255, green: 0, blue: 0, alpha: 1)
                cell.videoImageView.layer.borderWidth = 3
                cell.countLabel.isHidden = false
            }
            else
            {
                cell.videoImageView.layer.borderWidth = 0
                cell.videoImageView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0)
                cell.countLabel.isHidden = true
            }
            return cell
        }
        else
        {
            var selectedVideos = selectedAssetImages()
            let cell = selectedVideoCollectionView.dequeueReusableCell(withReuseIdentifier: "VideoSelectedCollectionViewCell", for: indexPath) as! VideoSelectedCollectionViewCell
            let index = assetImages.firstIndex(where: {$0.0 == selectedVideos[indexPath.row].0})!
            let asset = self.assetImages[index].0
            cell.asset = asset
            cell.delegate = self
            let manager = PHImageManager.default()
            manager.requestImage(for:  asset, targetSize: CGSize(width: 10,height: 10), contentMode: .aspectFill, options: nil)
            {
                image,_ in
                DispatchQueue.main.async {
                    cell.selectedVideoImageView.image = image
                }
            }
            return cell;
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(collectionView == videoCollectionView)
        {
            let width = (videoCollectionView.bounds.width - 12)/3
            let height = width
            return CGSize(width: width, height: height)
        }
        else
        {
            let width = 10
            let height = 10
            return CGSize(width: width, height: height)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if(collectionView == videoCollectionView)
        {
            return UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        }
        else
        {
            return UIEdgeInsets(top: 0, left: 0, bottom: 3, right: 0)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var selectedVideos = selectedAssetImages()
        if(collectionView == videoCollectionView)
        {
            let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
            //video is not selected
            if(assetImages[indexPath.row].1 == -1)
            {
                
                cell.countLabel.layer.borderWidth = 3
                cell.countLabel.layer.borderColor = CGColor(red: 255, green: 0, blue: 0, alpha: 1)
                cell.countLabel.text = "\(selectedVideos.count)"
                cell.videoImageView.layer.borderColor = CGColor(red: 255, green: 0, blue: 0, alpha: 1)
                cell.videoImageView.layer.borderWidth = 3
                cell.countLabel.isHidden = false
                assetImages[indexPath.row].1 = selectedAssetImages().count+1
            }
            else
            {
                cell.videoImageView.layer.borderWidth = 0
                cell.videoImageView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0)
                cell.countLabel.isHidden = true
                for (i,value) in assetImages.enumerated()
                {
                    if(value.1 > assetImages[indexPath.row].1)
                    {
                        assetImages[i].1 -= 1
                    }
                }
                assetImages[indexPath.row].1 = -1
            }
        }
        updateVideosSelection()
    }
}

extension ViewController: VideoSelectedCollectionViewCellDelegate
{
    func videoSelectedCollectionViewCell(_ cell: UICollectionViewCell, _ deletedAsset: PHAsset) {
        var index = assetImages.firstIndex(where: {$0.0 == deletedAsset})!
        for (i,value) in assetImages.enumerated()
        {
            if(value.1 > assetImages[index].1)
            {
                assetImages[i].1 -= 1
            }
        }
        assetImages[index].1 = -1
        print(selectedAssetImages().count)
        updateVideosSelection()
        videoCollectionView.reloadData()
        
        selectedVideoCollectionView.reloadData()
        
    }
    
    
}

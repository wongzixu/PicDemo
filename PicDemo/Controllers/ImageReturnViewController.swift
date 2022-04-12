//
//  ImageReturnViewController.swift
//  PicDemo
//
//  Created by 王梓旭 on 2022/4/11.
//

import UIKit

class ImageReturnViewController: UIViewController {
    
    var text = ""
    var color = ""
    
    @IBOutlet weak var resultImageScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var pictureManager = PictureManager()
    var imagesURLString = [String]()
    var frame = CGRect.zero

    override func viewDidLoad() {
        super.viewDidLoad()
        pictureManager.delegate = self
        pageControl.numberOfPages = 5
        resultImageScrollView.isPagingEnabled = true
        resultImageScrollView.delegate = self
        pictureManager.fetchPicture(text: text, color: color)
    }
    
    func setURLStringToArray(pictureURLStringArray: [String]) {
        for index in 0...4 {
            imagesURLString.append(pictureURLStringArray[index])
        }
    }
    
    func setImage(from url: String, for ImageView: UIImageView) {
        // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageURL = URL(string: url) else { return }
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                ImageView.image = image
            }
        }
    }

}

// MARK: - Extention of PictureManagerDelegate

extension ImageReturnViewController: PictureManagerDelegate {
    func didUpdatePicture(_ pictureManager: PictureManager, picture: PictureURL) {
        DispatchQueue.main.async {
            let imageUrlStringArray = picture.url
            self.setURLStringToArray(pictureURLStringArray: imageUrlStringArray)
            self.setupScreens()
            // self.setImage(from: imageUrlString)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}


// MARK: - UIScrollView & UIPageControl method

extension ImageReturnViewController: UIScrollViewDelegate {
    
    func setupScreens() {
        for index in 0..<5 {
            frame.origin.x = resultImageScrollView.frame.size.width * CGFloat(index)
            frame.size = resultImageScrollView.frame.size
            
            let view = UIImageView(frame: frame)
            setImage(from: imagesURLString[index], for: view)
            self.resultImageScrollView.addSubview(view)
        }
        
        resultImageScrollView.contentSize = CGSize(width: (resultImageScrollView.frame.size.width * CGFloat(5)), height: resultImageScrollView.frame.size.height)
        
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControl.Event.valueChanged)
    }
    
    @objc func changePage(sender: AnyObject) -> () {
            let x = CGFloat(pageControl.currentPage) * resultImageScrollView.frame.size.width
            resultImageScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
    
}

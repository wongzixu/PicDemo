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
    
    var pictureURL = ""
    
    @IBOutlet weak var resultImageView: UIImageView!
    
    var pictureManager = PictureManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        pictureManager.delegate = self
        pictureManager.fetchPicture(text: text, color: color)
        // Do any additional setup after loading the view.
    }
    
    func setImage(from url: String) {

            // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageURL = URL(string: url) else { return }
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.resultImageView.image = image
            }
        }
    }

}

// MARK: - Extention of PictureManagerDelegate

extension ImageReturnViewController: PictureManagerDelegate {
    func didUpdatePicture(_ pictureManager: PictureManager, picture: PictureURL) {
        DispatchQueue.main.async {
            let imageUrlString = picture.url
            self.setImage(from: imageUrlString)
        }
    }
    
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}

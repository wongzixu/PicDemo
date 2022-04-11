//
//  PictureManager.swift
//  PicDemo
//
//  Created by 王梓旭 on 2022/4/11.
//

import Foundation

protocol PictureManagerDelegate {
    func didUpdatePicture(_ pictureManager: PictureManager, picture: PictureURL)
    func didFailWithError(error: Error)
}

struct PictureManager {
    
    let pictureURL = "https://serpapi.com/search.json?tbm=isch&ijn=0"
    
    var delegate: PictureManagerDelegate?
    
    func fetchPicture(text: String, color: String) {
        let urlString = "\(pictureURL)&api_key=\(K.privateKey)&q=\(text)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                } else {
                    if let safeData = data {
                        if let dataString = String(data: safeData, encoding: .utf8){print(dataString)}
                        if let picture = self.parseJSON(safeData) {
                            self.delegate?.didUpdatePicture(self, picture: picture)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ pictureData: Data) -> PictureURL? {
        let decoder = JSONDecoder()
        
        do {
            let decodeData = try decoder.decode(PictureData.self, from: pictureData)
            let url = decodeData.images_results[1].original
            
            let decodeModel = PictureURL(url: url)
            return decodeModel
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}

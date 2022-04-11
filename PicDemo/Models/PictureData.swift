//
//  PictureData.swift
//  PicDemo
//
//  Created by 王梓旭 on 2022/4/11.
//

import Foundation

struct PictureData: Decodable {
    let search_metadata: Search_metadata
    let images_results: [Image]
}

struct Search_metadata: Decodable {
    let id: String
}

struct Image: Decodable {
    let original: String
}

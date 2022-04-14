//
//  IdentifierStandard.swift
//  PicDemo
//
//  Created by 王梓旭 on 2022/4/14.
//

import Foundation

struct IdentifierStandard {
    func getStandardIdentifier(_ OriginalIdentifier: String) -> String {
        let input = OriginalIdentifier
        var output = ""
        
        let space: Character = " "
        let comma: Character = ","
        
        for letter in input {
            if letter != space && letter != comma {
                output.append(letter)
            } else if letter == space {
                continue
            } else {
                break
            }
        }
        
        return output
    }
}

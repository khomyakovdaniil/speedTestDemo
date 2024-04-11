//
//  NSMutableData+Append.swift
//  speedtest
//
//  Created by  Даниил Хомяков on 08.04.2024.
//

import Foundation

extension NSMutableData {
    // Easy syntax to modify data, used in createDataUploadRequest
    func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
    
}

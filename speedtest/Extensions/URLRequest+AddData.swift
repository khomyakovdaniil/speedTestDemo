//
//  URLRequest+AddData.swift
//  speedtest
//
//  Created by  Даниил Хомяков on 08.04.2024.
//

import Foundation

extension URLRequest {
    
    // Helper function to get proper syntax for data upload. Actually a lot more reusable than needed for this app, since fileName and mimeType are stored constants 

    func createDataUploadRequest(fileName name: String,
                               data: Data,
                               mimeType: String) -> URLRequest? {
        
        let boundary: String = UUID().uuidString
        let httpBody = NSMutableData()
        
        httpBody.append("--\(boundary)\r\n")
        httpBody.append("Content-Disposition: form-data; name=\"\(name)\"\r\n")
        httpBody.append("Content-Type: \(mimeType)\r\n")
        httpBody.append("\r\n")
        httpBody.append(data)
        httpBody.append("\r\n")
        httpBody.append("--\(boundary)--")
        
        guard let url = self.url else {
            return nil
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpBody = httpBody as Data
        
        return request
    }
    
}

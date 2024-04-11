//
//  Constants.swift
//  speedtest
//
//  Created by  Даниил Хомяков on 09.04.2024.
//

import Foundation

struct Constants { // Used to store all the literals
    
    static let standartTimeout = 100.0
    static let testImageName = "Image"
    static let testImageMimeType = "img/jpeg"
    
    struct SettinsKeys {
        static let theme = "themeSettingsKey"
        static let downloadURL = "downloadURLSettingKey"
        static let uploadURL = "uploadURLSettingKey"
        static let skipDownloadSpeed = "skipDownloadSpeedSettingKey"
        static let skipUploadSpeed = "skipUploadSpeedSettingKey"
    }
    
    struct DefaultServerUrls {
        static let download = "http://moscow.speedtest.rt.ru:8080/speedtest/random7000x7000.jpg"
        static let upload = "http://moscow.speedtest.rt.ru:8080/speedtest/upload.php"
    }
}

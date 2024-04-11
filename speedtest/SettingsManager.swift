//
//  SettingsManager.swift
//  speedtest
//
//  Created by  Даниил Хомяков on 09.04.2024.
//

import Foundation

final class SettingsManager {
    
    // Since the class only has functions and doesn't store any changable properties itself, we can declare all the functions static and use them without creating an object of the class
    
    // Only used for simpler syntax
    static let setting = UserDefaults.standard
    
    
    // This is a helper class, and it has set of functions used for easier access to UserDefaults where we store all the user setting, all of them are just pairs of getting and setting values for keys
    
    static func saveTheme(_ theme: Int) {
        self.setting.set(theme, forKey: Constants.SettinsKeys.theme)
    }
    
    static func getTheme() -> Int {
        return self.setting.integer(forKey: Constants.SettinsKeys.theme)
    }
    
    static func saveDownloadURL( url: URL) {
        self.setting.set(url, forKey: Constants.SettinsKeys.downloadURL)
    }
    
    static func getDownloadURL() -> URL? {
        // Here we provide a default value
        guard let url = URL(string: Constants.DefaultServerUrls.download) else { return nil }
        return self.setting.url(forKey: Constants.SettinsKeys.downloadURL) ?? url
    }
    
    static func saveUploadURL( url: URL) {
        self.setting.set(url, forKey: Constants.SettinsKeys.uploadURL)
    }
    
    static func getUploadURL() -> URL? {
        // Here we provide a default value
        guard let url = URL(string: Constants.DefaultServerUrls.upload) else { return nil }
        return self.setting.url(forKey: Constants.SettinsKeys.uploadURL) ?? url
    }
    
    static func saveSkipDownloadSpeed(_ skip: Bool) {
        self.setting.set(skip, forKey: Constants.SettinsKeys.skipDownloadSpeed)
    }
    
    static func getSkipDownloadSpeed() -> Bool {
        return self.setting.bool(forKey: Constants.SettinsKeys.skipDownloadSpeed)
    }
    
    static func saveSkipUploadSpeed(_ skip: Bool) {
        self.setting.set(skip, forKey: Constants.SettinsKeys.skipUploadSpeed)
    }
    
    static func getSkipUploadSpeed() -> Bool {
        return self.setting.bool(forKey: Constants.SettinsKeys.skipUploadSpeed)
    }

}

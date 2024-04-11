//
//  SettingsViewController.swift
//  speedtest
//
//  Created by  Даниил Хомяков on 09.04.2024.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var themePickerSegmentedControl: UISegmentedControl!
    @IBOutlet weak var downloadUrlTextField: UITextField!
    @IBOutlet weak var uploadUrlTextField: UITextField!
    @IBOutlet weak var downloadSpeedCheckBox: UIButton!
    @IBOutlet weak var uploadSpeedCheckBox: UIButton!
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Actions
    
    @IBAction func themePickerValueChanged(_ sender: UISegmentedControl) {
        
        // Saving input to settings
        SettingsManager.saveTheme(sender.selectedSegmentIndex)
        
        // Changing the appearance accordingly
        changeTheme(to: sender.selectedSegmentIndex)
    }
    @IBAction func downloadUrlTextFieldChanged(_ sender: UITextField) {
        
        // Checking if user input is correct and saving to settings
        guard let url = URL(string: sender.text ?? "") else { return }
        SettingsManager.saveDownloadURL(url: url)
    }
    @IBAction func uploadUrlTextFieldChanged(_ sender: UITextField) {
        
        // Checking if user input is correct and saving to settings
        guard let url = URL(string: sender.text ?? "") else { return }
        SettingsManager.saveUploadURL(url: url)
    }
    @IBAction func downloadSpeedCheckBoxTapped(_ sender: UIButton) {
        
        // Emulate checkbox behaviour
        sender.isSelected = !sender.isSelected
        
        // Saving input to settings
        SettingsManager.saveSkipDownloadSpeed(!sender.isSelected)
    }
    @IBAction func uploadSpeedCheckBoxTapped(_ sender: UIButton) {
        
        // Emulate checkbox behaviour
        sender.isSelected = !sender.isSelected
        
        // Saving input to settings
        SettingsManager.saveSkipUploadSpeed(!sender.isSelected)
    }
    
    private func setupViews() {
        // Retrieving actual settings and settings the views accordingly
        themePickerSegmentedControl.selectedSegmentIndex = SettingsManager.getTheme()
        downloadUrlTextField.text = SettingsManager.getDownloadURL()?.absoluteString
        uploadUrlTextField.text = SettingsManager.getUploadURL()?.absoluteString
        downloadSpeedCheckBox.isSelected = !SettingsManager.getSkipDownloadSpeed()
        uploadSpeedCheckBox.isSelected = !SettingsManager.getSkipUploadSpeed()
    }
    
    private func changeTheme(to theme: Int) {
        switch theme {
        case 1:
            UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = .light
        case 2:
            UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = .dark
        default:
            return
        }
    }

}

//
//  ViewController.swift
//  speedtest
//
//  Created by  Даниил Хомяков on 07.04.2024.
//

import UIKit

final class SpeedTestViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var downloadSpeedCurrentLabel: UILabel!
    @IBOutlet weak var downloadSpeedMeasuredLabel: UILabel!
    @IBOutlet weak var uploadSpeedCurrentLabel: UILabel!
    @IBOutlet weak var uploadSpeedMeasuredLabel: UILabel!
    
    // MARK: - Actions
    
    @IBAction func userDidTapTestSpeedButton(_ sender: Any) {
        checkSpeed()
    }
    
    // MARK: - Properties
    
    // Used to show result speed and launch upload test if needed
    var downloadCompletionBlock: (() -> Void)?
    
    // Used to track progress
    var startTime: CFAbsoluteTime!
    var stopTime: CFAbsoluteTime!
    var bytesReceived: Int!
    
    // Shared URL session
    var session: URLSession?
    
    // Test image to get data for uploading
    let image = UIImage(named: Constants.testImageName)!
    
    // Is either downloaded data or test image data
    var data = NSMutableData()
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        // Conguring URLSession, no cache storage and long timeout, delegate to self to read actual speed
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForResource = Constants.standartTimeout
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        session = URLSession.init(configuration: configuration, delegate: self, delegateQueue: nil)
    }
    
    // MARK: - Private functions
    
    private func checkSpeed() {
        // Checking if the user wants to check download and upload speed
        let checkState: (Bool, Bool) = (!SettingsManager.getSkipDownloadSpeed(), !SettingsManager.getSkipUploadSpeed())
        
        switch checkState {
        case (true, false):
            // Running testDownload and showing results in completion
            testDownload { [weak self] in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.downloadSpeedMeasuredLabel.text = self.downloadSpeedCurrentLabel.text
                    self.downloadSpeedCurrentLabel.text = String(0.0)
                }
            }
        case (false, true):
            // If no data was downloaded previously then we use data from test image
            if data.isEmpty {
                data.append(image.pngData()!)
            }
            // Running test upload with given data
            self.testUpload(with: data as Data)
        case (true, true):
            // Running testDownload and testUpload afterwards
            testDownload { [weak self] in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.downloadSpeedMeasuredLabel.text = self.downloadSpeedCurrentLabel.text
                    self.downloadSpeedCurrentLabel.text = String(0.0)
                }
                self.testUpload(with: self.data as Data)
            }
        case (false, false):
            return
        }
    }
    
    private func testDownload(completionBlock: @escaping () -> Void) {
        
        // Retrieving server URL which is either default or user provided
        guard let url = SettingsManager.getDownloadURL() else { return }
        
        // Resetting the timestamps and data count to calculate speed
        startTime = CFAbsoluteTimeGetCurrent()
        bytesReceived = 0
        
        // Saving the completion block to run it from delegate later
        downloadCompletionBlock = completionBlock
        
        // Running the download task
        session?.dataTask(with: url).resume()
    }
    
    private func testUpload(with data: Data) {
        
        // Retrieving server URL which is either default or user provided
        guard let url = SettingsManager.getUploadURL() else { return }
        
        // Creating a upload request with proper body syntax
        guard let urlRequest = URLRequest(url: url).createDataUploadRequest(fileName: Constants.testImageName, data: data, mimeType: Constants.testImageMimeType) else {
            return
        }
        
        // Resetting the timer
        self.startTime = CFAbsoluteTimeGetCurrent()
        
        // Creating upload task with showing results in completion
        let uploadTask = session?.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            
            // Just basic debugging, can be removed
            guard let self else { return }
            if let error {
                print("error \(error.localizedDescription)")
            }
            else if let response {
                print("response \(response)")
            }
            print("finished uploading data \(data)")
            
            // Showing the results
            DispatchQueue.main.async {
                self.uploadSpeedMeasuredLabel.text = self.uploadSpeedCurrentLabel.text
                self.uploadSpeedCurrentLabel.text = String(0.0)
            }
        }
        
        // Running the upload task
        uploadTask?.resume()
    }
}

    // MARK: - URLSessionDelegate

extension SpeedTestViewController: URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        // Calculate the size of data downloaded
        bytesReceived! += data.count
        
        // Saving the data to use it for upload test in the future
        self.data.append(data)
        
        // Calculating speed by dividing size by time
        stopTime = CFAbsoluteTimeGetCurrent()
        let elapsed = stopTime - startTime
        let speed = elapsed != 0 ? (Double(bytesReceived) / elapsed).bytesToMbit() : 0
        
        // Showing current speed
        DispatchQueue.main.async {
            self.downloadSpeedCurrentLabel.text = String(format: "%.2f", speed)
        }
        
        print("download speed \(speed)")
    }
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        // Running the completion block for download task which is either just showing
        downloadCompletionBlock?()
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
        // Calculating speed by dividing size by time
        self.stopTime = CFAbsoluteTimeGetCurrent()
        let elapsed = self.stopTime - self.startTime
        let speed = (Double(totalBytesSent) / elapsed ).bytesToMbit()
        
        // Showing current speed
        DispatchQueue.main.async {
            self.uploadSpeedCurrentLabel.text = String(format: "%.2f", speed)
        }
        
        print("upload speed \(speed)")
    }
}

//
//  ViewController.swift
//  speedtest
//
//  Created by  Даниил Хомяков on 07.04.2024.
//

import UIKit

class ViewController: UIViewController, URLSessionDelegate, URLSessionDataDelegate {
    
    
    typealias speedTestCompletionHandler = (_ megabytesPerSecond: Double? , _ error: Error?) -> Void
    
    var speedTestCompletionBlock : speedTestCompletionHandler?
    
    var startTime: CFAbsoluteTime!
    var stopTime: CFAbsoluteTime!
    var bytesReceived: Int!
    var downloadTask: URLSessionDataTask!
    
    var session: URLSession?
    var ___obs: NSKeyValueObservation?
    
    var timer: Timer?
    var uploadTask: URLSessionDataTask!
    var data = NSMutableData()
    var previousBytesSent: Int64 = 0
    var previousBytesSentFraction: Int64 = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        checkForSpeedTest()
    }
    
    func checkForSpeedTest() {
        
        testDownloadSpeedWithTimout(timeout: 100.0) { (speed, error) in
            print("Download Speed:", speed ?? "NA")
            print("Speed Test Error:", error ?? "NA")
            DispatchQueue.main.async {
                self.startTime = CFAbsoluteTimeGetCurrent()
                self.testUpload(with: self.data as Data)
                self.speedTestCompletionBlock = nil
            }
        }
        
    }
    
    func testDownloadSpeedWithTimout(timeout: TimeInterval, withCompletionBlock: @escaping speedTestCompletionHandler) {
        
        guard let url = URL(string: "http://moscow.speedtest.rt.ru:8080/speedtest/random7000x7000.jpg") else { return }
        
        startTime = CFAbsoluteTimeGetCurrent()
        stopTime = startTime
        bytesReceived = 0
        
        speedTestCompletionBlock = withCompletionBlock
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForResource = timeout
        session = URLSession.init(configuration: configuration, delegate: self, delegateQueue: nil)
        session!.dataTask(with: url).resume()
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        bytesReceived! += data.count
        self.data.append(data)
        stopTime = CFAbsoluteTimeGetCurrent()
        let elapsed = stopTime - startTime
        let speed = elapsed != 0 ? (Double(bytesReceived) / elapsed).bytesToMbit() : 0
        print("download speed \(speed)")
    }
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        let elapsed = stopTime - startTime
        
        if let aTempError = error as NSError?, aTempError.domain != NSURLErrorDomain && aTempError.code != NSURLErrorTimedOut && elapsed == 0  {
            speedTestCompletionBlock?(nil, error)
            return
        }
        
        let speed = elapsed != 0 ? Double(bytesReceived) / elapsed / 1024.0 / 1024.0 : -1
        speedTestCompletionBlock?(speed, nil)
    }
    
    func testUpload(with data: Data) {
        let urlString = "http://moscow.speedtest.rt.ru:8080/speedtest/upload.php"
        guard let url = URL(string: urlString) else {
            return
        }
        
        
        
        guard let urlRequest = URLRequest(url: url).createDataUploadRequest(fileName: "Test", data: data, mimeType: "img/jpeg") else {
            return
        }
        
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.timeoutIntervalForResource = 100.0
        
        session!.dataTask(with: url).resume()
        uploadTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let err = error {
                //There's an error
            }
            else if let response = response {
                print("response \(response)")
                //check for response status
            }
            
            //Stop the timer here
            self.timer?.invalidate()
            print("finished uploading data \(data)")
        }
        ___obs = uploadTask.progress.observe(\.fractionCompleted) { prog, _ in
            let bytesSent = Double(data.count) * prog.fractionCompleted
            guard Double(bytesSent) > Double(self.previousBytesSentFraction) else {
                return
            }
            self.stopTime = CFAbsoluteTimeGetCurrent()
            let elapsed = self.stopTime - self.startTime
            let speed = (Double(bytesSent) / elapsed ).bytesToMbit()
            print("upload speed fraction: \(speed)")
            //Here you get the speed in Bytes/sec
            self.previousBytesSentFraction = Int64(bytesSent)
        }
        uploadTask.resume()
    }
}


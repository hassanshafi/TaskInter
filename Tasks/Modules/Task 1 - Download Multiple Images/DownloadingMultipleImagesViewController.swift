//
//  DownloadingMultipleImagesViewController.swift
//  Tasks
//
//  Created by Muhammad Hassan Shafi on 12/05/2021.
//

import UIKit

class DownloadingMultipleImagesViewController: UIViewController {

    // MARK: - OUTLETS
    @IBOutlet var imageViews: [UIImageView]!
    @IBOutlet var labelsProgress: [UILabel]!
    
    // MARK: - VARIABLES
    
    var imageURLs: [String] = [
        "https://picsum.photos/seed/picsum/200/300",
        "https://picsum.photos/200/300",
        "https://picsum.photos/200/300/"
    ]
    
    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    // MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - SETUP VIEW
    
    
    // MARK: - BUTTON ACTIONS
    
    @IBAction func didTapDownloadButton(_ sender: UIButton) {
        imageURLs.forEach { (url) in
            session.downloadTask(with: URL.init(string: url)!).resume()
        }
    
        sender.isUserInteractionEnabled = false
    }
    
    // MARK: - HELPER METHODS

}

extension DownloadingMultipleImagesViewController: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("downloadTask.taskIdentifier: \(downloadTask.taskIdentifier)")
        print("Original URL: \(String(describing: downloadTask.originalRequest!.url))")
        print("new location url: \(location)")
        DispatchQueue.main.async {
            if let imageData = NSData(contentsOf: location) {
                let image = UIImage(data: imageData as Data)
                self.imageViews[downloadTask.taskIdentifier-1].image = image
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let percent = Double(totalBytesWritten)/Double(totalBytesExpectedToWrite)
        DispatchQueue.main.async {
            self.labelsProgress[downloadTask.taskIdentifier-1].text = String(Float(percent))
        }
        print("downloadTask.taskIdentifier: \(downloadTask.taskIdentifier), Progress: \(Float(percent))")
    }
    
    
}

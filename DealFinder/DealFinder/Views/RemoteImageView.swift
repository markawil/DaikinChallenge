//
//  RemoteImageView.swift
//  DealFinder
//
//  Created by Mark Wilkinson on 9/26/18.
//  Copyright © 2018 markw. All rights reserved.
//
//  An abstracted way to load a remote image inside a UIImageView

import UIKit

class RemoteImageView: UIImageView {
    
    static var configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        return config
    }()
    
    static var session: URLSession = {
        let session = URLSession(
            configuration: RemoteImageView.configuration,
            delegate: nil,
            delegateQueue: nil)
        session.delegateQueue.maxConcurrentOperationCount = 2
        return session
    }()
    
    var imageTask: URLSessionDataTask?
    
    func updateImage(withUrl url: URL, placeholder: UIImage? = nil) {
        
        if ConnectionManager.shared.isNetworkAvailable == false {
            return;
        }
        
        imageTask?.cancel()
        
        imageTask = type(of: self).session.dataTask(with: url) { (data, response, error) in
            if error == nil {
                if let http = response as? HTTPURLResponse {
                    if http.statusCode == 200 {
                        
                        assert(!Thread.isMainThread, "called on main thread!")
                        
                        if (self.imageTask!.state == URLSessionTask.State.canceling) {
                            return
                        }
                        self.loadImageWithData(data: data!)
                    } else {
                        print("received an HTTP \(http.statusCode) downloading \(String(describing: url))")
                    }
                } else {
                    print("Not an HTTP response")
                }
            } else {
                print("Error downloading image: \(url.path) -- \(error!.localizedDescription)")
            }
        }
        
        if let placeholderImage = placeholder {
            image = placeholderImage
        }
        
        imageTask?.resume()
    }
    
    private func loadImageWithData(data: Data) {
        if let image = UIImage(data: data) {
            DispatchQueue.main.async {
                self.image = image
                let transition = CATransition()
                transition.duration = 0.25
                transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
                transition.type = CATransitionType.fade
                self.layer.add(transition, forKey: nil)
            }
        }
    }
    
    func cancelImageLoading() {
        imageTask?.cancel()
    }
}

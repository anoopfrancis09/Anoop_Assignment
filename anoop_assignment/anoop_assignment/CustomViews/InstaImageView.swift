//
//  InstaImageView.swift
//  Instagram
//
//  Created by Apple on 26/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

var smallImageCache = NSCache<AnyObject, AnyObject>()
var mediumImageCache = NSCache<AnyObject, AnyObject>()


@IBDesignable
class InstaImageView: UIImageView {
    
    // MARK: - Gradient
    
    @IBInspectable var firstColor: UIColor = UIColor.white {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var secondColor: UIColor = UIColor.white {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var horizontalGradient: Bool = false {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    func updateView() {
        guard let layer = self.layer as? CAGradientLayer else {
            return
        }
        layer.colors = [ firstColor.cgColor, secondColor.cgColor ]
        
        if horizontalGradient {
            layer.startPoint = CGPoint(x: 0.0, y: 0.5)
            layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        } else {
            layer.startPoint = CGPoint(x: 0, y: 0)
            layer.endPoint = CGPoint(x: 0, y: 1)
        }
    }
    
    // MARK: - Border
    
    @IBInspectable public var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    // MARK: - Shadow
    
    @IBInspectable public var shadowOpacity: CGFloat = 0 {
        didSet {
            layer.shadowOpacity = Float(shadowOpacity)
        }
    }
    
    @IBInspectable public var shadowColor: UIColor = UIColor.clear {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable public var shadowOffsetWidth: CGFloat = 0 {
        didSet {
            layer.shadowOffset.width = shadowOffsetWidth
        }
    }
    
    @IBInspectable public var shadowOffsetHeight: CGFloat = 0 {
        didSet {
            layer.shadowOffset.height = shadowOffsetHeight
        }
    }
    
    //MARK:- Download
    
    var smallImageUrl: String? {
        didSet {
            loadSmallImage(urlString: smallImageUrl ?? "")
        }
    }
    
    var mediumImageUrl: String? {
        didSet {
            loadMediumImage(urlString: mediumImageUrl ?? "")
        }
    }
    
    var defaultImage: UIImage?
    
    fileprivate var smallDownloadTask: URLSessionDataTask?
    fileprivate var mediumDownloadTask: URLSessionDataTask?
    
    
    fileprivate func setImage(_ imageToSet: UIImage?) {
        DispatchQueue.main.async {[weak self] in
            self?.image = imageToSet
        }
    }
    
    private func loadSmallImage(urlString: String) {
        
        // setting image from cache if its available...
        if let cacheImage = smallImageCache.object(forKey: urlString as AnyObject) as? UIImage {
            if !isBigImageDownloaded() {
                setImage(cacheImage)
            }
            return
        }
        
        // If Url is wrong, setting default image if available...
        guard let url = URL(string: urlString) else {
            setImage(defaultImage)
            return
        }
        
        
        // Downloading the smal image from the url...
        smallDownloadTask = URLSession.shared.dataTask(with: url) {[weak self] (data, response, error) in
            
            guard error == nil, let data = data, let image = UIImage(data: data), let responseURL = response?.url?.absoluteString else {
                // Some error occured, hence going back to default image...
                if self?.smallImageUrl  == response?.url?.absoluteString {
                    if !(self?.isBigImageDownloaded() ?? false) {
                        self?.setImage(self?.defaultImage)
                    }
                    
                }
                return
            }
            
            // Saving the image cache, maping image with its url...
            smallImageCache.setObject(image, forKey: responseURL as AnyObject)
            
            // Finally setting the image if urlString is same as what we asked to download. In case urlString is changed, we dont need to set it(eg: in case of cells getting scrolled).
            if self?.smallImageUrl == response?.url?.absoluteString {
                if !(self?.isBigImageDownloaded() ?? false) {
                    self?.setImage(image)
                }
            }
        }
        smallDownloadTask?.resume()
    }
    
    private func loadMediumImage(urlString: String) {
        // setting image from cache if its available...
        if let cacheImage = mediumImageCache.object(forKey: urlString as AnyObject) as? UIImage {
            removeLoading()
            setImage(cacheImage)
            return
        }
        
        // If Url is wrong, setting default image if available...
        guard let url = URL(string: urlString) else {
            setImage(defaultImage)
            return
        }
        
        addLoading()
        // Downloaging the image from the url...
        mediumDownloadTask = URLSession.shared.dataTask(with: url) {[weak self] (data, response, error) in
            self?.removeLoading()
            guard error == nil, let data = data, let image = UIImage(data: data), let responseURL = response?.url?.absoluteString else {
                // Some error occured, hence going back to default image...
                if self?.mediumImageUrl == response?.url?.absoluteString {
                    self?.setImage(self?.defaultImage)
                }
                return
            }
            
            // Saving the image cache, maping image with its url...
            mediumImageCache.setObject(image, forKey: responseURL as AnyObject)
            
            // Finally setting the image if urlString is same as what we asked to download. In case urlString is changed, we dont need to set it(eg: in case of cells getting scrolled).
            if self?.mediumImageUrl == response?.url?.absoluteString {
                self?.setImage(image)
            }
        }
        mediumDownloadTask?.resume()
    }
    
    fileprivate func isBigImageDownloaded() -> Bool {
        if (mediumImageCache.object(forKey: mediumImageUrl as AnyObject) as? UIImage) != nil {
            return true
        }
        return false
    }
    
    //TODO:- Can add better loading screen...
    fileprivate func addLoading() {
        DispatchQueue.main.async {[weak self] in
            self?.alpha = 0.3
        }
    }
    
    fileprivate func removeLoading() {
        DispatchQueue.main.async {[weak self] in
            self?.alpha = 1.0
        }
    }
}

//
//  ImageDetailViewController.swift
//  SmashTag
//
//  Created by Ziliang Zhu on 10/24/15.
//  Copyright (c) 2015 Austurela. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController, UIScrollViewDelegate {
    
    private let myImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myScrollView.addSubview(myImageView)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    func orientationChanged() {
        adjustImageSize()
    }
    
    private struct StoryBoard {
        static let backSegue = "backSegue"
    }
    
    func goBack() {
        performSegueWithIdentifier(StoryBoard.backSegue, sender: self)
    }
    
    private func adjustImageSize() {
        let imageViewSize = myImageView.bounds.size
        var viewSize = UIScreen.mainScreen().bounds.size
        if let navigationBarHeight = navigationController?.navigationBar.frame.size.height {
            viewSize = CGSize(width: viewSize.width, height: viewSize.height - navigationBarHeight)
        }
        
        let widthScale = viewSize.width / imageViewSize.width
        let heightScale = viewSize.height / imageViewSize.height
        
        let minZoomScale = min(widthScale, heightScale)
        myScrollView.minimumZoomScale = minZoomScale
        
        let maxZoomScale = max(widthScale, heightScale)
        myScrollView.maximumZoomScale = maxZoomScale
        
        myScrollView.zoomScale = maxZoomScale
    }
    
    @IBOutlet var myScrollView: UIScrollView! {
        didSet {
            myScrollView.contentSize = myImageView.frame.size
            myScrollView.delegate = self
            adjustImageSize()
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return myImageView
    }
    
    internal var image: UIImage? {
        get {
            return myImageView.image
        }
        set {
            myImageView.image = newValue
            myImageView.sizeToFit()
        }
    }
}

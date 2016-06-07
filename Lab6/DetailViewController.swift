//
//  DetailViewController.swift
//  Lab6
//
//  Created by Bekah Suttner on 6/3/16.
//  Copyright © 2016 Bekah Suttner. All rights reserved.
//

import UIKit
import TUSafariActivity

class DetailViewController: UIViewController {

    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var videoDescription: UITextView!
    
    var video: Dictionary<String,AnyObject>?
    
    var detailItem: Dictionary<String, AnyObject>? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // handle text (without crashing Xcode...yay!)
        if let v = self.video!["snippet"] as? Dictionary<String,AnyObject> {
            self.videoTitle.text! = (v["title"] as? String)!
            self.videoDescription.text! = (v["description"] as? String)!
            self.videoImage.image = UIImage(named:"YouTube")
            
            // fetch image
            if let images = video!["snippet"]!["thumbnails"] as? Dictionary<String, AnyObject> {
                if let highRes = images["medium"] as? Dictionary<String, AnyObject> {
                    if let imageUrl : String = highRes["url"] as? String {
                        self.videoImage.loadImageFromURL(NSURL(string: imageUrl), placeholderImage: self.videoImage.image, cachingKey: imageUrl)
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        let safari : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: #selector(DetailViewController.share))
        
        self.navigationItem.rightBarButtonItems = [safari]
        
        navigationController!.navigationBar.barTintColor = UIColor.redColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func share()
    {
        if let video = self.video {
            if let ytId = video["id"] as? NSDictionary {
                if let videoId = ytId["videoId"] as? String {
                    let url = NSURL(string: "http://www.youtube.com/watch?v=" + videoId )
                    let msg = "Check out my college basketball video on YouTube"
                    let items = [ msg, url! ]
                    
                    let activity = TUSafariActivity()
                    
                    //let avc = UIActivityViewController(activityItems: items, applicationActivities: nil)
                    let avc = UIActivityViewController(activityItems: items, applicationActivities: [activity])
                    
                    self.navigationController?.presentViewController(avc, animated: true, completion: nil)
                }
            }
        }
    }


}


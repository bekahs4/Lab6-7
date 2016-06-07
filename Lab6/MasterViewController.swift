//
//  MasterViewController.swift
//  Lab6
//
//  Created by Bekah Suttner on 6/3/16.
//  Copyright © 2016 Bekah Suttner. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: VideosTableViewController? = nil
//    var objects = [AnyObject]()
    var channels = [AnyObject]()
    
    func loadChannels() {
        // get ready to fetch the list of videos
        let url = NSURL(string: "https://www.googleapis.com/youtube/v3/search?part=snippet&channelType=any&maxResults=30&q=College+basketball&type=channel&key=AIzaSyDiP7psist2CIBWmrwpALVSXNt-ELcscGA")
        let session = NSURLSession.sharedSession()
        let task = session.downloadTaskWithURL(url!) {
            (loc:NSURL?, response:NSURLResponse?, error: NSError?) in
            if error != nil {
                print(error)
                return
            }
            
            // print out the fetched string for debug purposes
            let d = NSData(contentsOfURL: loc!)!
                        print("got data")
                        let datastring = NSString(data: d, encoding: NSUTF8StringEncoding)
                        print(datastring)
            
            // parse the top level JSON object
            let parsedObject: AnyObject?
            do {
                parsedObject = try NSJSONSerialization.JSONObjectWithData(d, options: NSJSONReadingOptions.AllowFragments)
            } catch let error as NSError {
                print(error)
                return
            } catch {
                fatalError()
            }
            
            // retrieve the individual channels from the JSON document
            if let topLevelObj = parsedObject as? Dictionary<String,AnyObject> {
                if let items = topLevelObj["items"] as? Array<Dictionary<String,AnyObject>> {
                    for i in items {
                        self.channels.append(i)
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        //(UIApplication.sharedapplication().delegate as! AppDelegate).decrementNetworkActivity()
                        self.tableView.reloadData()
                    }
                }
                
            }
        }
        
        //(UIApplication.sharedapplication().delegate as! AppDelegate).incrementNetworkActivity()
        task.resume()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//        self.navigationItem.leftBarButtonItem = self.editButtonItem()
//
//        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(insertNewObject(_:)))
//        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? VideosTableViewController
        }
        
        navigationController!.navigationBar.barTintColor = UIColor.redColor()
        
        self.loadChannels()
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    func insertNewObject(sender: AnyObject) {
////        objects.insert(NSDate(), atIndex: 0)
//        channels.insert(NSDate(), atIndex: 0)
//        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
//        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
//                let object = objects[indexPath.row] as! NSDate
                let object = channels[indexPath.row] as! Dictionary<String,AnyObject>
//                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! VideosTableViewController
                controller.channel = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return objects.count
        return channels.count
    }

//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
//
//        let object = objects[indexPath.row] as! NSDate
//        cell.textLabel!.text = object.description
//        return cell
//    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("you are here")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ChannelsTableViewCell
        
        if let object = channels[indexPath.row] as? Dictionary<String, AnyObject> {
            if let snippet = object["snippet"] as? Dictionary<String, AnyObject> {
                
                // handle text
//                cell.textLabel!.text = snippet["title"] as? String
                cell.channelLabel.text = snippet["title"] as? String
//                cell.channelLabel.text = "Hello, world"
                
                
                // fetch image
//                cell.imageView?.image = UIImage(named:"YouTube")
                cell.channelImage.image = UIImage(named:"YouTube")
                if let images = snippet["thumbnails"] as? Dictionary<String, AnyObject> {
                    if let firstImage = images["default"] as? Dictionary<String, AnyObject> {
                        if let imageUrl : String = firstImage["url"] as? String {
//                            cell.imageView?.loadImageFromURL(NSURL(string: imageUrl), placeholderImage: cell.imageView?.image, cachingKey: imageUrl)
                            cell.channelImage.loadImageFromURL(NSURL(string: imageUrl), placeholderImage: cell.channelImage.image, cachingKey: imageUrl)
                        }
                    }
                }
            }
        }
        
        return cell
    }

//    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
//
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
////            objects.removeAtIndex(indexPath.row)
//            channels.removeAtIndex(indexPath.row)
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        } else if editingStyle == .Insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//        }
//    }


}


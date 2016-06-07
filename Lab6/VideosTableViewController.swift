//
//  VideosTableViewController.swift
//  Lab6
//
//  Created by Bekah Suttner on 6/3/16.
//  Copyright © 2016 Bekah Suttner. All rights reserved.
//

import UIKit

class VideosTableViewController: UITableViewController {

    var videos = [AnyObject]()
    var channel: Dictionary<String,AnyObject>?
    
    func loadVideos(channelID: String) {
        // get ready to fetch the list of videos
        let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=\(channelID)&maxResults=50&type=video&key=AIzaSyDiP7psist2CIBWmrwpALVSXNt-ELcscGA"
        let url = NSURL(string: urlString)
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
            
            // retrieve the individual videos from the JSON document
            if let topLevelObj = parsedObject as? Dictionary<String,AnyObject> {
                if let items = topLevelObj["items"] as? Array<Dictionary<String,AnyObject>> {
                    for i in items {
                        self.videos.append(i)
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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if let c = self.channel {
            let channelID = c["id"]!["channelId"] as! String
            self.loadVideos(channelID)
        }
        
        navigationController!.navigationBar.barTintColor = UIColor.redColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return videos.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // Configure the cell...
        let video = self.videos[indexPath.row] as! Dictionary<String,AnyObject>
        
        cell.textLabel!.text = video["snippet"]!["title"]! as? String
        cell.detailTextLabel!.text = video["snippet"]!["description"]! as? String

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "show" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = videos[indexPath.row] as! Dictionary<String,AnyObject>
                let controller = segue.destinationViewController as! DetailViewController
//                    as! UINavigationController).topViewController as! DetailViewController
                controller.video = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}

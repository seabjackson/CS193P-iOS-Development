//
//  TweetsTableViewController.swift
//  Smashtag
//
//  Created by lily on 8/25/16.
//  Copyright © 2016 Seab Jackson. All rights reserved.
//

import UIKit
import Twitter

class TweetsTableViewController: UITableViewController, UITextFieldDelegate
{

    // get an array of tweets
    var tweets = [Array<Twitter.Tweet>]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var searchText: String? {
        didSet {
            tweets.removeAll()
            searchForTweets()
            title = searchText
        }
    }
    
    private var twitterRequest: Twitter.Request? {
        if let query = searchText where !query.isEmpty {
            return Twitter.Request(search: query + " -filter:retweets", count: 100)
        }
        return nil
    }
    
    // keep track of the last twitter request
    private var lastTwitterRequest: Twitter.Request?
    
    private func searchForTweets()
    {
        if let request = twitterRequest {
            lastTwitterRequest = request
            request.fetchTweets { [weak weakSelf = self] newTweets in
                dispatch_async(dispatch_get_main_queue()) {
                    if request == weakSelf?.lastTwitterRequest {
                        if !newTweets.isEmpty {
                            weakSelf?.tweets.insert(newTweets, atIndex: 0)
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    // MARK: - UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }
    
    private struct Storyboard {
        static let TweetCellIdentifier = "Tweet"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TweetCellIdentifier, forIndexPath: indexPath)
        
        let tweet = tweets[indexPath.section][indexPath.row]
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }
        
        return cell
    }
    
    @IBOutlet weak var twitterSearchString: UITextField! {
        didSet {
            twitterSearchString.delegate = self
            twitterSearchString.text = searchText
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchText = textField.text
        return true
    }
    
    

       /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

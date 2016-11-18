//
//  TweetersTableViewController.swift
//  Smashtag
//
//  Created by lily on 8/26/16.
//  Copyright © 2016 Seab Jackson. All rights reserved.
//

import UIKit
import CoreData

class TweetersTableViewController: CoreDataTableViewController {
    
    var mention: String? { didSet { updateUI() } }
    var managedObjectContext: NSManagedObjectContext? { didSet { updateUI()} }
    
    private func tweetCountWithMentionByTwitterUser(user: TwitterUser) -> Int?
    {
        var count: Int?
        user.managedObjectContext?.performBlockAndWait {
            let request = NSFetchRequest(entityName: "Tweet")
            request.predicate = NSPredicate(format: "text contains[c] %@ and tweeter = %@", self.mention!, user)
            count = user.managedObjectContext?.countForFetchRequest(request, error: nil)
        }
        return count
    }
    
    private func updateUI() {
        if let context = managedObjectContext where mention?.characters.count > 0 {
            let request = NSFetchRequest(entityName: "TwitterUser")
            request.predicate = NSPredicate(format: "any tweets.text contains[c] %@ and !screenName beginswith[c] %@", mention!, "darkside")
            request.sortDescriptors = [NSSortDescriptor(
                key: "screenName",
                ascending: true,
                selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                )]
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
        } else {
            fetchedResultsController = nil
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TwitterUserCell", forIndexPath: indexPath)
        
        if let twitterUser = fetchedResultsController?.objectAtIndexPath(indexPath) as? TwitterUser {
            var screenName: String?
            var name: String?
            twitterUser.managedObjectContext?.performBlockAndWait  {
               screenName = twitterUser.screenName!
            }
            cell.textLabel?.text = screenName
            if let count = tweetCountWithMentionByTwitterUser(twitterUser) {
                cell.detailTextLabel?.text = (count == 1) ? "1 Tweet" : "\(count) Tweets"
            } else {
                cell.detailTextLabel?.text = ""
            }
        }


        return cell
    }
}

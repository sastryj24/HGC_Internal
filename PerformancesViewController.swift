//
//  PerformancesViewController.swift
//  HGC Internal
//
//  Created by user161027 on 11/28/19.
//  Copyright © 2019 Jay Sastry. All rights reserved.
//

import UIKit

class PerformancesViewController: UITableViewController {
    
    // create a variable to contain the all performances instances of a given song passed from PLoadingView
    var finalWorks: [subwork]!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // sort the array containing performance instances chronologically
        self.finalWorks = self.finalWorks.sorted {$0.year > $1.year}
//        print(finalWorks.count)
        
        PLoadingView.navig = true
        
    }
    
    // set the TableView to only have one column
    override func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }
    
    // set the TableView to have as many rows as there are elements in finalWorks
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finalWorks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // set the title of each individual cell to be the the album name of the performance
        let cell = tableView.dequeueReusableCell(withIdentifier: "performance", for: indexPath)
        
        // set the subtitle of each cell to be the artist and the year of performance
        cell.textLabel?.text = finalWorks[indexPath.row].album
        var artist = String(finalWorks[indexPath.row].artist)
        var year = String(finalWorks[indexPath.row].year.prefix(4))

        cell.detailTextLabel?.text = "\(year) | \(artist)"

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // pass the performance instance that was selected by the user to the PlayerViewController
        if segue.identifier == "PlayerSegue" {
            if let destination = segue.destination as? PlayerViewController {
                destination.song = finalWorks[tableView.indexPathForSelectedRow!.row]
                }
        }
    }
    
}

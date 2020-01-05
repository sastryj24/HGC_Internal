//
//  ViewController.swift
//  Pokedex
//
//  Created by user161027 on 11/16/19.
//  Copyright © 2019 CS50. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate {
    
    // create a searchBar
    @IBOutlet var searchBar: UISearchBar?
    
    // receive a list of works garnered from the API request passed from LoadingView
    
    var searchList: [work] = []
    var works: [work] = []
    
    // track whether the search bar is in use to prevent problems with seguing to the next view controller
    var searching = false
    var transition: Bool = false
    
    // create a global variable to hold the cookies from the URL request
    static var cookie: [HTTPCookie]?
    
    // create a function to capitalize the titles of songs
    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        self.navigationController?.setNavigationBarHidden(true, animated: animated)

        // if a segue has taken place, don't initialize a search bar
        if searchBar?.delegate == nil && transition == true {
            return
        }
        
        // otherwise delegate the search function to searchBar
        searchBar?.delegate = self
        
        // reload the TableView data
        DispatchQueue.main.async {
            
            if LoadingView.firstTime == "yes" {
                LoadingView.firstTime = "no"
                UserDefaults.standard.set(LoadingView.firstTime, forKey: "first")
                print(LoadingView.firstTime)
            }
            
            self.tableView.reloadData()
        }
    }
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        LoadingView.update = true
        navigationController?.popViewController(animated: true)
        sender.endRefreshing()
    }
    
    // set the number of columns in the TableView equal to 1
    override func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }
    
    // set the number of rows in the TableView equal to the number of elements in searchList
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // for cell type "Piece" set the title equal to the the title of an element in searchList
        let cell = tableView.dequeueReusableCell(withIdentifier: "Piece", for: indexPath)
        var newTitle = capitalize(text: searchList[indexPath.row].title)
        
        // clean the title passed from the API to remove extraneous text
        let numb = String(newTitle.suffix(4))
        var numb2: String = ""
        
        for char in numb {
            if char != "(" || char != ")" || char != " " {
                numb2 += String(char)
            }
        }
        searchList[indexPath.row].performances = Int(numb2)
        newTitle.removeLast(4)
        
        // set the title of the cell equal to newTitle
        cell.textLabel?.text = newTitle
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // indicate whether a segue is taking place to end the searchBar function
        transition = true
        
        // pass the information about the song selected to the PLoadingView
        if segue.identifier == "PLoadSegue" {
            if let destination = segue.destination as? PLoadingView {
                destination.piece = searchList[tableView.indexPathForSelectedRow!.row]
                }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) { //search bar funtion
        
        if searchText.count != 0 { // if the search is not blank
        self.searchList = works.filter {($0.title.lowercased().contains(searchText.lowercased()))} // then check to see if any part of the lowercased name of a pokemon matches with the search text
            }
        else {
            searchList = works // return the full pokemon list if nothing has been searched
        }

        searching = true
        tableView.reloadData()
    }
    
    func initialLoad() {
        
    }
    
}


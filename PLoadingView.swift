//
//  LoadingView.swift
//  HGC Internal
//
//  Created by Apple on 12/4/19.
//  Copyright © 2019 Jay Sastry. All rights reserved.
//

import Foundation
import UIKit

class PLoadingView: UIViewController {
    
    // create segue indication variable
    static var navig: Bool!
    
    // create array of subworks to contain API data
    var finalWorks: [subwork]!
    
    // create a work optional to store information received upon segue from ViewcController
    var piece: work!
    
    // create sworks variable to manipulate data taken from API before passing to next view
    var sworks: [subwork]!
    
    @IBOutlet var loading: UILabel! // create UILabel for loading screen
    
    var preloaded: [String: Bool] = ["initial": true]
    
    var encoded1: Data!
    static var pfirstTime: String? = "yes"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        if PLoadingView.navig == true {
            navigationController?.popViewController(animated: true)
            PLoadingView.navig = !PLoadingView.navig
            return
        }
                
        try? PLoadingView.pfirstTime = UserDefaults.standard.string(forKey: "pfirst")
        print(PLoadingView.pfirstTime)
        
        if PLoadingView.pfirstTime == nil {
            PLoadingView.pfirstTime = "yes"
        }
        
        if PLoadingView.pfirstTime == "no" {
            preloaded = try! UserDefaults.standard.dictionary(forKey: "preload") as! [String : Bool]
        }
        
        if preloaded[piece.title] == nil {
            preloaded[piece.title] = false
        }
        print(preloaded)
        
        if preloaded[piece.title] == true {
            nextView()
            return
        }

        else {
    //      create URL type and check if it exists
            print("hi3")
            let url = URL(string: "https://wrapapi.com/use/sastryj24/cs50/hgcperforms/0.0.2?titleurl=\(piece.url.dropFirst(4))&stateToken=\(LoadingView.keys)&wrapAPIKey=QoUv0L22KUQYHSKo7LfSOHsVQcmglUJW")
            guard let u = url else {
                print("Cannot access URL")
                return
            }
            
            // Begin URL session
            URLSession.shared.dataTask(with: u) { (data, response, error) in
                guard let data = data else {
                    return
                }
                
                // begin the process of decoding the JSON file returned from the API
                do {
                    
                    // navigate through the structs created by the API
                    let datum = try JSONDecoder().decode(outsidePerforms.self, from: data)
                    let temp = datum.data
                    // simplify to an array of subworks
                    var tempWorks = temp.collection
                    
                    // remove any subworks without a name or download link
                    tempWorks = tempWorks!.filter {($0.suburl != nil)}
                    tempWorks = tempWorks!.filter {($0.stitle != nil)}
                    let counting = tempWorks!.count
                    
                    // iterate through tempWorks for an individual API request to each performances instance to pull metadata
                    for song in tempWorks! {
                        
                        // check URL exists
                        let url = URL(string: "https://wrapapi.com/use/sastryj24/cs50/hgcmetadata/0.0.7?titleurl=abc&node=\(String(song.suburl.dropFirst(4)))&stateToken=\(LoadingView.keys)&wrapAPIKey=QoUv0L22KUQYHSKo7LfSOHsVQcmglUJW")
                        guard let u = url else {
                            return
                        }
                        
                        // Begin URL session
                        URLSession.shared.dataTask(with: u) { (data, response, error) in
                        guard let data = data else {
                            return
                        }
                        print("hi4")

                        // Access information from API and decode JSON
                        do {
                            
                            // navigate through structs created by API
                            let datums = try JSONDecoder().decode(outsidePerforms.self, from: data)
                            let temp = datums.data
                            var tempMdata = temp.collection
                            tempMdata![0].nodeurl = song.suburl

                            // check whether sworks has been appended to previously
                            if self.sworks == nil {
                                
                                // if not, set sworks equal to temp metadata
                                self.sworks = tempMdata!
    //                            print(self.sworks)
                            }
                                             
                            else {
                                
                                // otherwise append the metadata to the sworks array
                                self.sworks += tempMdata!
    //                            print(self.sworks)
                            }

                            // if no year is provided from the website indicate as such
                            if let row = self.sworks.firstIndex(where: {$0.year == nil}) {
                                self.sworks[row].year = "N/A "
                            }
                                            
                        }
                        catch let error {
                            print("\(error)")
                        }
    //                    print(self.sworks)
    //                        print(tempWorks!.count)
                            print("1. \(self.sworks.count)")

                        
                            if self.sworks.count == counting {
    //                            print("2. \(self.sworks.count)")
                                DispatchQueue.main.async {
                                    print("3. \(self.sworks.count)")
                                    
                                    // set finalWorks equal to sworks after modifications
                                    self.finalWorks = self.sworks
                                    
                                    // change the label on the loading page
                                    self.loading.text = " "
                                    
                                    // segue to the next ViewController
                                    self.nextView()
                                }
                            }
                    }.resume()
                    }
            }
            catch let error {
                print("\(error)")
            }
                
            }.resume()
        }
    }
    
    func nextView() {
        
        // segue to the performances view controller
        self.performSegue(withIdentifier: "PerformsSegue", sender: self)
        return
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // pass finalWorks data to the next view controller
        if segue.identifier == "PerformsSegue" {
            if let destination = segue.destination as? PerformancesViewController {
                var pdata: [String: [subwork]] = [:]

                if PLoadingView.pfirstTime == "no" {
                    try? encoded1 = UserDefaults.standard.object(forKey: "pdata") as? Data
                    try? pdata = PropertyListDecoder().decode([String: [subwork]].self, from: encoded1)
                }
                
                else {
                    PLoadingView.pfirstTime = "no"
                    UserDefaults.standard.set(PLoadingView.pfirstTime, forKey: "pfirst")
                }
                
                if preloaded[piece.title] == false {
                    destination.finalWorks = self.finalWorks
                    pdata[self.piece.title] = self.finalWorks
                    try? UserDefaults.standard.set(PropertyListEncoder().encode(pdata), forKey: "pdata")
                }
            
                else {
                    destination.finalWorks = pdata[piece.title]
                }
                
                // indicate that this piece has been looked at before
                self.preloaded[self.piece.title] = true
                UserDefaults.standard.set(self.preloaded, forKey: "preload")
                
                print(PLoadingView.pfirstTime)
                print(pdata)
                print(preloaded)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            // Show the Navigation Bar
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    
}

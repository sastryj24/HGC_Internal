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
    
    @IBOutlet var PullDown: UILabel! // create UILabel for loading screen
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)

//
//        print("hi2")
//        print(piece)
//
//      create URL type and check if it exists
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
//                        print("1. \(self.sworks.count)")

                    
                        if self.sworks.count == counting {
//                            print("2. \(self.sworks.count)")
                            DispatchQueue.main.async {
//                                print("3. \(self.sworks.count)")
                                
                                // set finalWorks equal to sworks after modifications
                                self.finalWorks = self.sworks
                                
                                // change the label on the loading page
                                self.PullDown.text =
                                " "
                                
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
        
        if PLoadingView.navig == true {
            navigationController?.popViewController(animated: true)
            PLoadingView.navig = !PLoadingView.navig
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
                destination.finalWorks = self.finalWorks
                }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            // Show the Navigation Bar
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    
}

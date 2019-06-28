//
//  ViewController.swift
//  Project1StormViewer
//
//  Created by Joshua on 6/27/19.
//  Copyright © 2019 JHC Dev. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    // list of paths to pictures
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // title of view
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Storm Viewer"
        
        // file managment
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        // load pictures
        for item in items {
            if item.hasPrefix("nssl") {
                // add item to `pictures`
                pictures.append(item)
            }
        }
        pictures.sort()
    }
    
    // get number of rows to display
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    // specify what each row should look like
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    // add image to detail view controller
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // try loading the "Detail" view controller
        // type caste it as a DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // set selectedImage property of the `DetailViewController` object
            vc.selectedImage = pictures[indexPath.row]
            
            vc.title = "Picture \(indexPath.row + 1) of \(pictures.count)"
            // puish it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}


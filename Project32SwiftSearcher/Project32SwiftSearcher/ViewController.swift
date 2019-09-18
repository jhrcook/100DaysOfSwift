//
//  ViewController.swift
//  Project32SwiftSearcher
//
//  Created by Joshua on 9/18/19.
//  Copyright © 2019 JHC Dev. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var projects = [HWSProject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Hacking with Swift projects"
        
        fillWithDemoProjects()
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("number of projects: \(projects.count)")
        return projects.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let project = projects[indexPath.row]
        print("(\(indexPath.row)) filling in project \(project.name)")
        cell.textLabel?.attributedText = makeAttributedStringFrom(project: project)
        
        return cell
    }


}



extension ViewController {
    func makeAttributedStringFrom(project: HWSProject) -> NSAttributedString {
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.preferredFont(forTextStyle: .headline),
            .foregroundColor: UIColor.purple
        ]
        
        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.preferredFont(forTextStyle: .subheadline)
        ]
        
        let titleString = NSMutableAttributedString(string: "\(project.name)\n", attributes: titleAttributes)
        let subtitleString = NSAttributedString(string: project.subtitle, attributes: subtitleAttributes)
        
        titleString.append(subtitleString)
        
        return titleString
    }
}




extension ViewController {
    
    func fillWithDemoProjects() {
        print("Making demonstration projects.")
        
        let demoProjects = [
            ["Project 1: Storm Viewer", "Constants and variables, UITableView, UIImageView, FileManager, storyboards"],
            ["Project 2: Guess the Flag", "@2x and @3x images, asset catalogs, integers, doubles, floats, operators (+= and -=), UIButton, enums, CALayer, UIColor, random numbers, actions, string interpolation, UIAlertController"],
            ["Project 3: Social Media", "UIBarButtonItem, UIActivityViewController, the Social framework, URL"],
            ["Project 4: Easy Browser", "loadView(), WKWebView, delegation, classes and structs, URLRequest, UIToolbar, UIProgressView., key-value observing"],
            ["Project 5: Word Scramble", "Closures, method return values, booleans, NSRange"],
            ["Project 6: Auto Layout", "Get to grips with Auto Layout using practical examples and code"],
            ["Project 7: Whitehouse Petitions", "JSON, Data, UITabBarController"],
            ["Project 8: 7 Swifty Words", "addTarget(), enumerated(), count, index(of:), property observers, range operators."]
        ]
        
        for demo in demoProjects {
            let demoProject = HWSProject(name: demo[0], subtitle: demo[1])
            projects.append(demoProject)
        }
    }
}

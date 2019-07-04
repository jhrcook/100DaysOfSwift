//
//  ViewController.swift
//  Project7WhitehousePetitions
//
//  Created by Joshua on 7/2/19.
//  Copyright © 2019 JHC Dev. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    // array of petitions
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // credits button in the top right
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credit", style: .plain, target: self, action: #selector(creditPopup))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterPetitionsPrompt))

        
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        } else {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    self?.parse(json: data)
                    return
                }
            }
            DispatchQueue.main.async {
                self?.showError()
            }
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        } else {
            showError()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func showError() {
        DispatchQueue.main.async { [weak self] in
            let alertController = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed. Please try again later.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alertController, animated: true)
        }
    }
    
    @objc func creditPopup() {
        let alertController = UIAlertController(title: "Credit", message: "This petition is from the \"We the People\" API of the Whitehouse.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    @objc func filterPetitionsPrompt() {
        let alertController = UIAlertController(title: "Filter", message: "Filter petition titles", preferredStyle: .alert)
        alertController.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak alertController] _ in
            guard let filter = alertController?.textFields?[0].text else { return }
            self?.filterPetitions(filter)
        }
        
        alertController.addAction(submitAction)
        present(alertController, animated: true)
        
    }
    
    func filterPetitions(_ filterTerm: String) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            let terms = filterTerm.split(separator: " ").map { $0.lowercased() }
            if terms.isEmpty {
                self?.filteredPetitions = self!.petitions
            } else {
                self?.filteredPetitions.removeAll()
                petitionLoop: for petition in self!.petitions {
                    for term in terms {
                        if petition.title.lowercased().contains(term) {
                            self?.filteredPetitions.append(petition)
                            continue petitionLoop
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}


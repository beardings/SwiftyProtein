//
//  ProteinListViewController.swift
//  SwiftyProtein
//
//  Created by Nikolas Ponomarov on 06.07.2018.
//  Copyright © 2018 Nikolas Ponomarov. All rights reserved.
//

import UIKit

class ProteinListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    @IBOutlet weak var tableVIew: UITableView!
    var listProteins = [String]()
    var filterProteins = [String]()
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let str = self.LoadFileAsString()

        listProteins = str.components(separatedBy: CharacterSet.newlines)
        
        self.tableVIew.delegate = self
        self.tableVIew.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Proteins"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: - Search Result Updating Delegate
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBarIsEmpty() -> Bool {
        
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        filterProteins.removeAll()
        
        for protein in listProteins {
            if (protein.lowercased().contains(searchText.lowercased())) {
                filterProteins.append(protein);
            }
        }

        tableVIew.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    //MARK: - Table View Delegate, Datasourse
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering() {
            getPDBdata(filterProteins[indexPath.row])
        } else {
             getPDBdata(listProteins[indexPath.row])
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            return filterProteins.count
        }
        
        return listProteins.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        if isFiltering() {
            cell.textLabel?.text = filterProteins[indexPath.row]
        } else {
             cell.textLabel?.text = listProteins[indexPath.row]
        }
        return cell
    }

    // MARK: - Load data from file
    
    func LoadFileAsString() -> (String)
    {
        if let path = Bundle.main.path(forResource: "ligands", ofType: "txt")
        {
            let fm = FileManager()
            let exists = fm.fileExists(atPath: path)
            if(exists){
                let content = fm.contents(atPath: path)
                let contentAsString = String(data: content!, encoding: String.Encoding.utf8)
                return contentAsString!
            }
        }
        return ""
    }
    
    func getPDBdata(_ title: String) -> Void {
        
        let str = "https://files.rcsb.org/ligands/view/" + title + "_model.pdb"
        
        let url = URL(string: str)
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            
            let pdb = String(data: data!, encoding: String.Encoding.utf8)
            
            let pdbByRow = pdb?.components(separatedBy: CharacterSet.newlines)
            
            // open next view controller
            
        }
        
        task.resume()
        
    }

}

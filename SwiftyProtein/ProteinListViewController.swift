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
    var str: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if str == nil
        {
            str = self.LoadFileAsString()
            listProteins = (str?.components(separatedBy: CharacterSet.newlines))!
        }
        
        self.tableVIew.delegate = self
        self.tableVIew.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Proteins"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        if let index = self.tableVIew.indexPathForSelectedRow {
            self.tableVIew.deselectRow(at: index, animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
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
                filterProteins.append(protein)
            }
        }

        tableVIew.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    //MARK: - Table View Delegate, Datasourse
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isFiltering() {
            getPDBdata(filterProteins[indexPath.row], tableView.cellForRow(at: indexPath) as! CustomTableViewCell)
        } else {
            getPDBdata(listProteins[indexPath.row], tableView.cellForRow(at: indexPath) as! CustomTableViewCell)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let index = self.tableVIew.indexPathForSelectedRow {
            self.tableVIew.deselectRow(at: index, animated: true)
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
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "Custom Cell") as! CustomTableViewCell?
        
        if (cell == nil) {
            tableVIew.register(UINib.init(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "Custom Cell")
            cell = tableView.dequeueReusableCell(withIdentifier: "Custom Cell") as! CustomTableViewCell?
        }
        
        if isFiltering() {
            cell?.textLbl.text = filterProteins[indexPath.row]
        } else {
            cell?.textLbl.text = listProteins[indexPath.row]
        }
        
        return cell!
    }

    // MARK: - Custom methods
    
    func showAlertController(_ message: String, _ title: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Load data
    
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
    
    func getPDBdata(_ title: String, _ cell: CustomTableViewCell) -> Void {
        
        DispatchQueue.main.async {
            cell.indicator.startAnimating()
        }
        
        let str = "https://files.rcsb.org/ligands/view/" + title + "_model.pdb"
        
        let url = URL(string: str)
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            
            if (error != nil) {
                
                DispatchQueue.main.async {
                    cell.indicator.stopAnimating()
                    self.showAlertController((error?.localizedDescription)!, "Warning")
                }
                return ;
            }
            
            DispatchQueue.main.async {
                let pdb = String(data: data!, encoding: String.Encoding.utf8)
                
                let proteinVC = ProteinViewController.init(nibName: nil, bundle: nil)
                proteinVC.title = "Protein: " + title
                proteinVC.proteinData = (pdb?.components(separatedBy: CharacterSet.newlines))!
                
                self.navigationController?.pushViewController(proteinVC, animated: true)
                
                cell.indicator.stopAnimating()
            }
        }
        task.resume()
    }
}

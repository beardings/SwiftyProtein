//
//  ProteinListViewController.swift
//  SwiftyProtein
//
//  Created by Nikolas Ponomarov on 06.07.2018.
//  Copyright © 2018 Nikolas Ponomarov. All rights reserved.
//

import UIKit

class ProteinListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableVIew: UITableView!
    var listProteins = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let str = self.LoadFileAsString()

        listProteins = str.components(separatedBy: CharacterSet.newlines)
        
        self.tableVIew.delegate = self
        self.tableVIew.dataSource = self
        //print(listProteins.count)
        //print(str)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
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
    
    //MARK: - Table View delegate, datasourse
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listProteins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = listProteins[indexPath.row]
        
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

}

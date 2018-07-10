//
//  ProteinViewController.swift
//  SwiftyProtein
//
//  Created by Nikolas Ponomarov on 09.07.2018.
//  Copyright © 2018 Mykola Ponomarov. All rights reserved.
//

import UIKit
import SceneKit

class ProteinViewController: UIViewController {

    @IBOutlet weak var sceneView: SCNView!
    var proteinData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let rightBtn = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(shareButtonPressed))
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Action methods
    
    @objc func shareButtonPressed() {
        
        DispatchQueue.main.async {
            
            let urlString = "https://www.google.com"
            let linkToShare = [urlString]
            let activityController = UIActivityViewController(activityItems: linkToShare, applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
        
        }
    }
}

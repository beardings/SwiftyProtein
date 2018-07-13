//
//  CustomTableViewCell.swift
//  SwiftyProtein
//
//  Created by Nikolas Ponomarov on 09.07.2018.
//  Copyright © 2018 Mykola Ponomarov. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var textLbl: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

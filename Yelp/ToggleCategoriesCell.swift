//
//  ToggleCategoriesCell.swift
//  Yelp
//
//  Created by Olga Azarova on 2/15/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class ToggleCategoriesCell: UITableViewCell {

    @IBOutlet weak var toggleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(labelText: String) {
        toggleLabel.text = labelText
    }}

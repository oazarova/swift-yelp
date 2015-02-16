//
//  SortCell.swift
//  Yelp
//
//  Created by Olga Azarova on 2/15/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class SortCell: UITableViewCell {

    @IBOutlet weak var sortLabel: UILabel!
    
    var delegate : SortCellDelegate?
    var sortSwitch : UISwitch?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup(delegate: SortCellDelegate, labelText: String, initialValue: Bool = false) {
        self.sortSwitch = UISwitch(frame: CGRectZero)
        sortSwitch?.on = initialValue
        
        if sortSwitch!.on {
            self.accessoryView = UIImageView(image: UIImage(named: "SortSelected"))
        } else {
            self.accessoryView = UIImageView(image: UIImage(named: "SortDeselected"))
        }
        
        sortLabel.text = labelText
        
        self.delegate = delegate
    }
    
    func toggleSwitch() {
        sortSwitch!.on = !sortSwitch!.on
        
        if sortSwitch!.on {
            self.accessoryView = UIImageView(image: UIImage(named: "SortSelected"))
        } else {
            self.accessoryView = UIImageView(image: UIImage(named: "SortDeselected"))
        }
        
        delegate?.sortCell(self, valueUpdated: sortSwitch!.on)
    }
}

protocol SortCellDelegate : class {
    func sortCell(sc: SortCell, valueUpdated: Bool)
}
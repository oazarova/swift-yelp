//
//  DealsCell.swift
//  Yelp
//
//  Created by Olga Azarova on 2/15/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class DealsCell: UITableViewCell {

    var delegate : DealCellDelegate?
    
    @IBOutlet weak var dealSwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func dealToggled(sender: UISwitch) {
        delegate?.dealCell(self, didUpdateValue: sender.on)
    }
    
    func setup(delegate: DealCellDelegate, state: Bool = false) {
        self.delegate = delegate
        dealSwitch.on = state
    }
}

protocol DealCellDelegate : class {
    func dealCell(dc: DealsCell, didUpdateValue: Bool)
}
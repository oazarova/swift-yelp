//
//  SwitchCell.swift
//  Yelp
//
//  Created by Olga Azarova on 2/15/15.
//

import UIKit

class SwitchCell: UITableViewCell {

    var delegate : SwitchCellDelegate?
    
    @IBOutlet weak var filterSwitch: UISwitch!
    @IBOutlet weak var switchLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func switchValueChanged(sender: UISwitch) {
        delegate?.switchCell(self, didUpdateValue: sender.on)
    }

    func setup(delegate: SwitchCellDelegate, labelText: String, initialState: Bool = false) {
        self.delegate = delegate
        switchLabel.text = labelText
        filterSwitch.on = initialState
    }
}

protocol SwitchCellDelegate : class {
    func switchCell(sc: SwitchCell, didUpdateValue: Bool)
}

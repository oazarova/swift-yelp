//
//  DistanceCell.swift
//  Yelp
//
//  Created by Olga Azarova on 2/15/15.
//

import UIKit

class DistanceCell: UITableViewCell {

    var delegate : DistanceCellDelegate?
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceSlider: UISlider!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func sliderChanged(sender: UISlider) {
        setDistance(sender.value)
        delegate?.distanceCell(self, valueChanged: Int(sender.value))
    }
    
    func setup(delegate: DistanceCellDelegate, distance: Float) {
        setDistance(distance)

        self.delegate = delegate
    }
    
    func setDistance(var distance: Float) {
        distance = floor(distance)
        distanceSlider.value = distance
        let suffix = distance > 1 ? "miles" : "mile"
        distanceLabel.text = "< \(Int(distance)) \(suffix)"
    }
}

protocol DistanceCellDelegate : class {
    func distanceCell(dc: DistanceCell, valueChanged: Int)
}
//
//  MarkerTableViewCell.swift
//  ProyectoSideMenuMapasJC
//
//  Created by gabatx on 27/1/23.
//

import UIKit

class MarkerTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var markerTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

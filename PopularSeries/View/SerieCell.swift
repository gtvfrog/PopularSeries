//
//  SerieCell.swift
//  PopularSeries
//
//  Created by Fernando Koyanagi on 19/02/20.
//  Copyright © 2020 crmall. All rights reserved.
//

import UIKit

class SerieCell: UITableViewCell {
    
    @IBOutlet weak var imageSerieView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

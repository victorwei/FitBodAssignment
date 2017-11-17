//
//  ExerciseCell.swift
//  FitBodAssignment
//
//  Created by Victor Wei on 11/15/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import UIKit

class ExerciseCell: UITableViewCell {

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var weightLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

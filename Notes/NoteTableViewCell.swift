//
//  NoteTableViewCell.swift
//  Notes
//
//  Created by Manas on 11/07/17.
//  Copyright © 2017 Manas. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var priority: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var updatedAt: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

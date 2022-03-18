//
//  MessageTableViewCell.swift
//  Direct Chat
//
//  Created by Renzo Delgado on 13/03/22.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var share: UIButton!
    @IBOutlet weak var dial: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        content.lineBreakMode = .byTruncatingTail
        content.adjustsFontSizeToFitWidth = false
        content.numberOfLines = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

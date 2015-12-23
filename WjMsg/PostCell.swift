//
//  PostCell.swift
//  WjMsg
//
//  Created by jiangchuan on 15/12/22.
//  Copyright © 2015年 jiangchuan. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var postImage : UIImageView!
    @IBOutlet weak var showCaseImage : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func drawRect(rect: CGRect) {
        postImage.layer.cornerRadius = postImage.frame.size.width/2.0
        postImage.clipsToBounds = true
        
        showCaseImage.clipsToBounds = true

    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

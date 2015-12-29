//
//  ContactCell.swift
//  WjMsg
//
//  Created by jiangchuan on 15/12/23.
//  Copyright © 2015年 jiangchuan. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var checkBtn : UIButton!
    @IBOutlet weak var photoImagView : UIImageView!
    @IBOutlet weak var nameLbl : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.checkBtn.hidden = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func checkBtnClicked(sender: UIButton) {
        
        if sender.tag == 0 {
            let image = UIImage(named: "checked-cycle")
            sender.setImage(image!, forState: UIControlState.Normal)
            sender.tag = 1
        } else {
            sender.tag = 0
            let image = UIImage(named: "empty-cycle")
            sender.setImage(image!, forState: UIControlState.Normal)
        }
    }
    
    override func drawRect(rect: CGRect) {
       
        photoImagView.layer.cornerRadius = photoImagView.frame.size.width/2.0
        photoImagView.clipsToBounds  = true
    }
}

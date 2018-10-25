//
//  productTableViewCell.swift
//  CoredAtaDemo
//
//  Created by Mac User on 10/3/18.
//  Copyright © 2018 Mac User. All rights reserved.
//

import UIKit

var systemVersion = UIDevice.current.systemVersion;
var count:NSInteger=0
class productTableViewCell: UITableViewCell {

    var count:NSNumber!
    @IBOutlet weak var ItemName: UILabel!
    @IBOutlet weak var lblNo: UILabel!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}

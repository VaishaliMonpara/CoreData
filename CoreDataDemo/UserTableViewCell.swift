//
//  UserTableViewCell.swift
//  CoreDataDemo
//
//  Created by MAC0008 on 07/02/20.
//  Copyright © 2020 MAC0008. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setData(data: UserDetail)
    {
        lblUserName.text = data.userName
        lblMobileNumber.text = data.mobileNumber
        lblPassword.text = data.password
        let image: Data = data.photoUrl 
        imgProfile.image = UIImage(data: image)
    }
    
}

//
//  TaskTableViewCell.swift
//  TO DO List
//
//  Created by Ibrahim Salah on 4/10/19.
//  Copyright © 2019 Ibrahim Salah. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    @IBOutlet weak var taskTitle : UILabel!
    @IBOutlet weak var createdAt : UILabel!
    @IBOutlet weak var details :UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure (task:Task){
        taskTitle.text = task.title
        details.text = task.details
        createdAt.text = task.createdAt
    }

}

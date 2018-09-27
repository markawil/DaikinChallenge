//
//  LoadingTableViewCell.swift
//  DealFinder
//
//  Created by Mark Wilkinson on 9/27/18.
//  Copyright © 2018 markw. All rights reserved.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {

    @IBOutlet weak var containingView: UIView! {
        didSet {
            containingView.clipsToBounds = true
            containingView.layer.cornerRadius = 5.0
        }
    }
}

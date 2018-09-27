//
//  ViewController.swift
//  DealFinder
//
//  Created by Mark Wilkinson on 9/25/18.
//  Copyright © 2018 markw. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailImageView: RemoteImageView!
    @IBOutlet weak var itemSalePriceLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemMSRPLabel: UILabel!
    @IBOutlet weak var itemLongDescTextView: UITextView!
    
    var selectedItem: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let validItem = selectedItem {
            if let validSalePrice = validItem.salePrice {
                let salesPrice = String(format: "$%.02f", validSalePrice)
                itemSalePriceLabel.text = "\(salesPrice)"
            } else if let validMSRP = validItem.msrp {
                let msrp = String(format: "MSRP $%.02f", validMSRP)
                itemMSRPLabel.text = "\(msrp)"
            }
            
            itemNameLabel.text = validItem.name
            itemLongDescTextView.text = validItem.longDescription.removingPercentEncoding
            
            if let validItem = selectedItem, let validUrl = URL(string: validItem.largeImage) {
                detailImageView.updateImage(withUrl: validUrl, placeholder: UIImage(named: "walmart-logo"))
            }
        }
    }
}


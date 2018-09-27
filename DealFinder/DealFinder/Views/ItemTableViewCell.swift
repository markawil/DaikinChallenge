//
//  ItemTableViewCell.swift
//  DealFinder
//
//  Created by Mark Wilkinson on 9/26/18.
//  Copyright © 2018 markw. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    static let storyboardCellId = "ItemTableViewCell"
    
    @IBOutlet weak var containingView: UIView! {
        didSet {
            containingView.clipsToBounds = true
            containingView.layer.cornerRadius = 5.0
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemImageView: RemoteImageView!
    
    func updateWithItem(item: Item) {
        
        nameLabel.text = item.name
        descriptionLabel.text = item.shortDescription.removingPercentEncoding
        if let validSalePrice = item.salePrice {
            let salesPrice = String(format: "$%.02f", validSalePrice)
            priceLabel.text = "\(salesPrice)"
        } else if let validMSRP = item.msrp {
            let msrp = String(format: "$%.02f", validMSRP)
            priceLabel.text = "\(msrp)"
        }
        if let validUrl = URL(string: item.thumbnailImage) {
            itemImageView.updateImage(withUrl: validUrl, placeholder: UIImage(named: "walmart-logo"))
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.cancelImageLoading()
        itemImageView.image = nil
    }
}

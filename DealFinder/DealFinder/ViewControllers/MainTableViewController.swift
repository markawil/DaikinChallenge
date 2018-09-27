//
//  MainTableViewController.swift
//  DealFinder
//
//  Created by Mark Wilkinson on 9/25/18.
//  Copyright © 2018 markw. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController, ErrorMessageViewController, LoadingViewController {

    var activitySpinner: ActivitySpinnerView?
    var items = [Item]()
    var dataSource: DataSource?
    var outOfMemory: Bool = false
    var didNavigateToDetailsView: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = DataSource(client: WebClient())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        outOfMemory = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if didNavigateToDetailsView {
            didNavigateToDetailsView = false
            return
        }
        
        if ConnectionManager.shared.isNetworkAvailable {
            loadNextPageOfItems()
        } else {
            showNoConnectionAlert(forViewController: self)
        }
    }
    
    func loadNextPageOfItems() {
        
        if outOfMemory {
            self.showError(errorMessage: "Device out of Memory", forViewController: self)
            return
        }
        
        showSpinner()
        dataSource?.itemsForNextPage(withCompletion: { (items, errorMessage) in
            self.stopSpinner()
            
            if let validItems = items {
                self.items.append(contentsOf: validItems)
                self.tableView.reloadData()
            } else if let validErrorMessage = errorMessage {
                self.showError(errorMessage: validErrorMessage, forViewController: self)
            }
        })
    }
    
    func loadStubbedItems() {
        
        if let validStubbedItems = dataSource?.stubbedItemsForTesting() {
            items = validStubbedItems
            tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if items.count > 0 {
            return items.count + 1
        }
        
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == items.count) {
            
            return tableView.dequeueReusableCell(withIdentifier: "LoadingTableViewCell", for: indexPath)
        }
        
        if let itemCell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.storyboardCellId, for: indexPath) as? ItemTableViewCell {
            
            itemCell.updateWithItem(item: items[indexPath.row])
            
            return itemCell
        }
        
        return UITableViewCell()
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if items.count == indexPath.row {
            loadNextPageOfItems()
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let selectedRow = self.tableView.indexPathForSelectedRow?.row {
            if let detailViewController = segue.destination as? DetailViewController {
                detailViewController.selectedItem = items[selectedRow]
                didNavigateToDetailsView = true
            }
        }
    }
    
    // MARK: - LoadingViewController
    
    func showSpinner() {
        activitySpinner = Bundle.main.loadNibNamed("ActivitySpinnerView", owner: self, options: nil)?.first as? ActivitySpinnerView
        let size = self.tableView.frame.size
        activitySpinner?.center = CGPoint(x: size.width/2, y: size.height/2)
        self.tableView.addSubview(activitySpinner!)
    }
    
    func stopSpinner() {
        self.activitySpinner?.removeFromSuperview()
    }
}

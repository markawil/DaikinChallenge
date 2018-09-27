//
//  BaseViewController.swift
//  DealFinder
//
//  Created by Mark Wilkinson on 9/26/18.
//  Copyright © 2018 markw. All rights reserved.
//

import Foundation
import UIKit

protocol LoadingViewController {
    
    func showSpinner()
    func stopSpinner()
}

protocol ErrorMessageViewController {
    
    func showNoConnectionAlert(forViewController: UIViewController)
    func showError(errorMessage: String, forViewController: UIViewController)
}

extension ErrorMessageViewController {
    
    func showNoConnectionAlert(forViewController viewController: UIViewController) {
        
        let alertController = UIAlertController(title: nil, message: "No Network Connection Available", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func showError(errorMessage: String, forViewController viewController: UIViewController) {
        
        let alertController = UIAlertController(title: "Error", message: "something went wrong: " + errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}


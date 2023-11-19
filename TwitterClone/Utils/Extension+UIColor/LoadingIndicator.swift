//
//  LoadingIndicator.swift
//  TwitterClone
//
//  Created by window1 on 2023/11/19.
//

import Foundation
import UIKit

class LoadingIndicator: UIViewController {
    var spinner = UIActivityIndicatorView(style: .large)
    
    override func loadView() {
        view = UIView()
        //view?.backgroundColor = UIColor(white: 0, alpah: 0.7)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
}

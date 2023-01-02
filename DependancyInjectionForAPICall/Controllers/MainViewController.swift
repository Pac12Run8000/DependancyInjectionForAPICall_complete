//
//  ViewController.swift
//  DependancyInjectionForAPICall
//
//  Created by Michelle Grover on 1/1/23.
//

import UIKit

class MainViewController: UIViewController {
    
    var viewModel = MainViewModel()
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var searchField:UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
    @IBAction func searchButtonTapped(_ sender:UIButton) {
        viewModel.fetchListForTableView(searchFieldInput: searchField.text)
    }


}


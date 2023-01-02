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
        tableView.delegate = self
        tableView.dataSource = self
        setupBindings()
       
    }
    
    @IBAction func searchButtonTapped(_ sender:UIButton) {
        viewModel.fetchListForTableView(searchFieldInput: searchField.text)
    }


}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.list.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.list.value[indexPath.row]
        return cell
    }
    
    
}

extension MainViewController {
    
    func setupBindings() {
        viewModel.list.bind { [weak self] list in
            DispatchQueue.main.async {
                guard let strongself = self else {return}
                strongself.tableView.reloadData()
            }
        }
    }
}


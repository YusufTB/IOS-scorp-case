//
//  ViewController.swift
//  Scorp Case
//
//  Created by YUSUF TALHA BALIKCIN on 13.12.2023.
//

import UIKit

class MainViewController: UIViewController {

    let tableView = UITableView()
    let noDataLabel = UILabel()
    
    var isRefreshEnable = true
    let refreshControl = UIRefreshControl()
    var timer = Timer()
    
    lazy var viewModel = {
        MainViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initViewModel()
    }
    
    func initView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "personCell")
        
        self.view.addSubview(tableView)
        self.view.addSubview(noDataLabel)
        tableView.addSubview(refreshControl)
        
        refreshControl.addTarget(self, action: #selector(self.refreshData(_:)), for: .valueChanged)
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        noDataLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        noDataLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        noDataLabel.font = UIFont.systemFont(ofSize: 16)
        noDataLabel.textAlignment = .center
        noDataLabel.text = "no one here :)"
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        noDataLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func initViewModel() {
        viewModel.delegate = self
        viewModel.getData(requestType: .getPeople)
    }
    
    @objc func refreshData(_ sender: AnyObject) {
        if isRefreshEnable {
            viewModel.getData(requestType: .getPeople)
            viewModel.inserted = false
            startTimer()
        } else if viewModel.isLoading {
            refreshControl.endRefreshing()
            self.showToast(message: "Loading in progress.")
        } else {
            refreshControl.endRefreshing()
            self.showToast(message: "You cannot refresh before 5 seconds have passed.")
        }
    }
    
    func startTimer() {
        isRefreshEnable = false
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { timer in
            self.isRefreshEnable = true
        }
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.responseModel.people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.responseModel.people[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)
        cell.textLabel?.text = "\(model.fullName) (\(String(model.id)))"
        cell.selectionStyle = .none
        
        if indexPath.row == viewModel.responseModel.people.count - 1 && !viewModel.isLoading && !viewModel.inserted {
            viewModel.getData(requestType: .insertPeople)
            self.showActivityIndicator()
        }
        
        return cell
    }
}

extension MainViewController: MainViewModelDelegate {
    func fetchedData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        self.noDataLabel.isHidden = self.viewModel.responseModel.people.count > 0
        
        self.refreshControl.endRefreshing()
        self.hideActivityIndicator()
    }
    
    func handleError(_ errorMessage: String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        self.refreshControl.endRefreshing()
        self.hideActivityIndicator()
    }
}

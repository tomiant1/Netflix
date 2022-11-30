//
//  UpcomingViewController.swift
//  Nextflix-Clone-App
//
//  Created by Tomi Antoljak on 11/26/22.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    private var titles: [Title] = [Title]()
    
    private let upcomingTable: UITableView = {
       
        let tableView = UITableView()
        
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        
        return tableView
        
    }()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.addSubview(upcomingTable)
        
        upcomingTable.dataSource = self
        
        upcomingTable.delegate = self

        view.backgroundColor = .systemBackground
        
        title = "Upcoming"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        fetchUpcoming()
        
    }

}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titles.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        
        let title = titles[indexPath.row]
        
        // Configure function sets the image and text
        
        cell.configure(with: TitleViewModel(titleName: title.original_name ?? title.original_title ?? "Unknown", posterURL: title.poster_path ?? ""))
         
        return cell
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        upcomingTable.frame = view.bounds
        
    }
    
    private func fetchUpcoming() {
        
        // Controller updates all its pieces when new data arrives so ofc it makes sense to drop prev versions of it. Remember the wrist analogy: you want to remove any strong references when you update the controller. All of the prev stuff should be deleted and gone.
        
        APICaller.shared.getUpcomingMovies { [weak self] result in
            
            switch result {
                
            case .success(let titles):
                
                self?.titles = titles
                
                DispatchQueue.main.async {
                    
                    self?.upcomingTable.reloadData()
                    
                }
                
            case .failure(let error):
                
                print(error)
                
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 140
        
    }
    
}

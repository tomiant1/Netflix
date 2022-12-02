//
//  DownloadsViewController.swift
//  Nextflix-Clone-App
//
//  Created by Tomi Antoljak on 11/26/22.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    private var titleItems: [TitleItem] = [TitleItem]()
    
    private let downloadTableView: UITableView = {
        
        let tableView = UITableView()
        
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        
        return tableView
        
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        title = "Downloads"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(downloadTableView)
        
        downloadTableView.delegate = self
        
        downloadTableView.dataSource = self
        
        fetchFromLocalStorage()
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        downloadTableView.frame = view.bounds
        
    }
    
    public func fetchFromLocalStorage() {
        
        DataPersistenceManager.shared.fetchingData { [weak self] result in
            
            switch result {
                
            case .success(let titleItems):
                
                self?.titleItems = titleItems
                
                DispatchQueue.main.async {
                    
                    self?.downloadTableView.reloadData()
                    
                }
                
            case .failure(let error):
                
                print(error)
                
            }
            
        }
        
    }
    
}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titleItems.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        
        let title = titleItems[indexPath.row]
        
        // Configure function sets the image and text
        
        let model = TitleViewModel(titleName: title.original_name ?? title.original_title ?? "Unknown", posterURL: title.poster_path ?? "")
        
        cell.configure(with: model)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
        
    }
    
}

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
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("Downloaded"), object: nil, queue: nil) { _ in
            
            self.fetchFromLocalStorage()
            
        }
        
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        tableView.beginUpdates()
        
        switch editingStyle {
            
        case .delete:
            
            DataPersistenceManager.shared.deleteTitle(with: titleItems[indexPath.row]) { [weak self] result in
                
                switch result {
                    
                case .success():
                    
                    print("Deleted from database")
                    
                case .failure(let error):
                    
                    print(error)
                    
                }
                
                self?.titleItems.remove(at: indexPath.row)
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                tableView.endUpdates()
                
            }
            
        default:
            
            break
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titleItems[indexPath.row]
        
        guard let titleName = title.original_title ?? title.original_name else { return }
        
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            
            switch result {
                
            case .success(let videoElement):
                
                DispatchQueue.main.async {
                    
                    let vc = TitlePreviewViewController()
                    
                    let titlePreviewModel = TitlePreviewViewModel(titleName: titleName, youtubeView: videoElement, titleOverview: title.overview ?? "")
                    
                    vc.configure(with: titlePreviewModel)
                    
                    self?.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
            case .failure(let error):
                
                print(error)
                
            }
            
        }
        
    }
    
}

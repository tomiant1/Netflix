//
//  UpcomingViewController.swift
//  Nextflix-Clone-App
//
//  Created by Tomi Antoljak on 11/26/22.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    private var titles: [Title] = [Title]()
    
    private let upcomingTableView: UITableView = {
       
        let tableView = UITableView()
        
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        
        return tableView
        
    }()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.addSubview(upcomingTableView)
        
        upcomingTableView.dataSource = self
        
        upcomingTableView.delegate = self

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
        
        let model = TitleViewModel(titleName: title.original_name ?? title.original_title ?? "Unknown", posterURL: title.poster_path ?? "")
        
        cell.configure(with: model)
         
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_title ?? title.original_name else { return }
        
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            
            switch result {
                
            case .success(let videoElement):
                
                DispatchQueue.main.async {
                    
                    let vc = TitlePreviewViewController()
                    
                    let titlePreviewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? "")
                    
                    vc.configure(with: titlePreviewModel)
                    
                    self?.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
            case .failure(let error):
                
                print(error)
                
            }
            
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        upcomingTableView.frame = view.bounds
        
    }
    
    private func fetchUpcoming() {
        
        // Controller updates all its pieces when new data arrives so ofc it makes sense to drop prev versions of it. Remember the wrist analogy: you want to remove any strong references when you update the controller. All of the prev stuff should be deleted and gone.
        
        APICaller.shared.getUpcomingMovies { [weak self] result in
            
            switch result {
                
            case .success(let titles):
                
                self?.titles = titles
                
                DispatchQueue.main.async {
                    
                    self?.upcomingTableView.reloadData()
                    
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

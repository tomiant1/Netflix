//
//  SearchViewController.swift
//  Nextflix-Clone-App
//
//  Created by Tomi Antoljak on 11/26/22.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var titles: [Title] = [Title]()
    
    private let discoverTableView: UITableView = {
        
        let tableView = UITableView()
        
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        
        return tableView
        
    }()
    
    private let searchController: UISearchController = {
        
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        
        controller.searchBar.placeholder = "Search"
        
        controller.searchBar.searchBarStyle = .default
        
        return controller
        
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = "Search"
        
        discoverTableView.delegate = self
        
        discoverTableView.dataSource = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.searchController = searchController
        
        navigationController?.navigationBar.tintColor = .white
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(discoverTableView)
        
        fetchDiscoverMovies()
        
        searchController.searchResultsUpdater = self
        
    }
    
    private func fetchDiscoverMovies() {
        
        APICaller.shared.getDiscoverMovies { [weak self] result in
            
            switch result {
                
            case .success(let titles):
                
                self?.titles = titles
                
                DispatchQueue.main.async {
                    
                    self?.discoverTableView.reloadData()
                    
                }
                
            case .failure(let error):
                
                print(error)
                
            }
            
            
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        discoverTableView.frame = view.bounds
        
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 140
        
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
    
}

// Getting query from search bar -- so we can get results when we type something and hit enter

extension SearchViewController: UISearchResultsUpdating, SearchResultsViewControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
            
            return
            
        }
        
        resultsController.delegate = self
        
        APICaller.shared.searchMovies(with: query) { result in
            
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let titles):
                    
                    resultsController.titles = titles
                    
                    resultsController.searchResultsCollectionView.reloadData()
                    
                case .failure(let error):
                    
                    print(error)
                    
                }
                
            }
            
        }
        
    }
    
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel) {
        
        DispatchQueue.main.async { [weak self] in 
            
            let vc = TitlePreviewViewController()
            
            vc.configure(with: viewModel)
            
            self?.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
}

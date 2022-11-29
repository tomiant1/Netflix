//
//  HomeViewController.swift
//  Nextflix-Clone-App
//
//  Created by Tomi Antoljak on 11/26/22.
//

import UIKit

enum Sections: Int {
    
    case TrendingMovies = 0
    case TrendingTV = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
    
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let sectionTitles = ["Trending Movies", "Popular", "Trending TV", "Upcoming Movies", "Top Rated"]
    
    private let homeTableView: UITableView = {
     
        // style .grouped gives small spacing between sections right above each section
        
        let tableView = UITableView(frame: .zero, style: .grouped)
        
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        
        return tableView
        
    }()

    override func viewDidLoad() {
        
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        homeTableView.delegate = self
        
        homeTableView.dataSource = self
        
        let headerView = HeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        
        homeTableView.tableHeaderView = headerView
        
        view.addSubview(homeTableView)
        
        configureNavbar()
                
    }
    
    private func configureNavbar() {
        
        var logoImage = UIImage(named: "netflixLogo")
        
        logoImage = logoImage?.withRenderingMode(.alwaysOriginal)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoImage, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
        
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        
        ]
        
        navigationController?.navigationBar.tintColor = .white
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        // So that table view displays over the entire screen (0 margins relative to the default view right below the controller in the hierarchy)
        
        homeTableView.frame = view.bounds
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sectionTitles.count
        
    }
    
    // Putting collection view inside the table view as a table view cell
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            
            return UITableViewCell()
            
        }
        
        
        
        switch indexPath.section {
            
        case Sections.TrendingTV.rawValue:
            
            APICaller.shared.getTrendingTVs { result in
                
                switch result {
                    
                case .success(let titles):
                    
                    cell.configure(with: titles)
                    
                case .failure(let error):
                    
                    print(error)
                    
                }
                
            }
            
        case Sections.TrendingMovies.rawValue:
            
            APICaller.shared.getTrendingMovies { result in
                
                switch result {
                    
                case .success(let titles):
                    
                    cell.configure(with: titles)
                    
                case .failure(let error):
                    
                    print(error)
                    
                }
                
            }
            
        case Sections.Popular.rawValue:
            
            APICaller.shared.getPopularMovies { result in
                
                switch result {
                    
                case .success(let titles):
                    
                    cell.configure(with: titles)
                    
                case .failure(let error):
                    
                    print(error)
                    
                }
                
            }
            
        case Sections.Upcoming.rawValue:
            
            APICaller.shared.getUpcomingMovies { result in
                
                switch result {
                    
                case .success(let titles):
                    
                    cell.configure(with: titles)
                    
                case .failure(let error):
                    
                    print(error)
                    
                }
                
            }
            
        case Sections.TopRated.rawValue:
            
            APICaller.shared.getTopRatedMovies { result in
                
                switch result {
                    
                case .success(let titles):
                    
                    cell.configure(with: titles)
                    
                case .failure(let error):
                    
                    print(error)
                    
                }
                
            }
            
        default:
            
            return UITableViewCell()
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
        
    }
    
    // Returns section names
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sectionTitles[section]
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let header = view as? UITableViewHeaderFooterView else { return }
        
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        
        header.textLabel?.textColor = .white
        
        header.textLabel?.text = header.textLabel?.text?.capitalized
        
    }
    
    // Navbar special functionality - scrolling up
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Safe area-size padding
        
        let defaultOffset = view.safeAreaInsets.top
        
        // How much is scroll view offset from content view. Scroll view is inside the content view.
        
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
        
    }

}

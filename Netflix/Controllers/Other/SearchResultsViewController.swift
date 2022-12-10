//
//  SearchResultsViewController.swift
//  Nextflix-Clone-App
//
//  Created by Tomi Antoljak on 11/30/22.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel)
    
}

class SearchResultsViewController: UIViewController {
    
    public weak var delegate: SearchResultsViewControllerDelegate?
    
    public var titles: [Title] = [Title]()
    
    public let searchResultsCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        
        return collectionView
        
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.addSubview(searchResultsCollectionView)
        
        view.backgroundColor = .systemBackground
        
        searchResultsCollectionView.dataSource = self
        
        searchResultsCollectionView.delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        searchResultsCollectionView.frame = view.bounds
        
    }
    
}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return titles.count
        
    }
    
    private func downloadTitleAt(indexPath: IndexPath) {
        
        DataPersistenceManager.shared.downloadTitle(with: titles[indexPath.row]) { result in
            
            switch result {
                
            case .success():
                
                NotificationCenter.default.post(name: NSNotification.Name("Downloaded"), object: nil)
                
            case .failure(let error):
                
                print(error)
                
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            
            let downloadAction = UIAction(title: "Download", image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                
                self?.downloadTitleAt(indexPath: indexPaths[0])
                
            }
            
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
            
        }
        
        return config
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        
        let title = titles[indexPath.row]
        
        cell.configure(with: title.poster_path ?? "")
                
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        let titleName = title.original_title ?? ""
        
        let titleOverview = title.overview ?? ""
        
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            
            switch result {
                
            case .success(let videoElement):
                
                self?.delegate?.searchResultsViewControllerDidTapItem(TitlePreviewViewModel(titleName: titleName, youtubeView: videoElement, titleOverview: titleOverview))
                
            case .failure(let error):
                
                print(error)
                
            }
            
        }
        
    }
    
}

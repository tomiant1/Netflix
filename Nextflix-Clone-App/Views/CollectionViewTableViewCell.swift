//
//  CollectionViewTableViewCell.swift
//  Nextflix-Clone-App
//
//  Created by Tomi Antoljak on 11/27/22.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel)
    
}

class CollectionViewTableViewCell: UITableViewCell {

    static let identifier = "CollectionViewTableViewCell"
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private var titles: [Title] = [Title]()

    private let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: 140, height: 200)
       
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        
        return collectionView
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style , reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemPink
        
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        
        collectionView.dataSource = self
        
    }
    
    // Setting collection view to be equal to w: 140, h: 200 as defined above; it won't otherwise display
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        collectionView.frame = contentView.bounds
        
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    // [weak self] = CollectionViewTableViewCell
    
    public func configure(with titles: [Title]) {
        
        self.titles = titles
        
        DispatchQueue.main.async { [weak self] in
            
            self?.collectionView.reloadData()
            
        }
        
    }
    
    private func downloadTitleAt(indexPath: IndexPath) {
        
        DataPersistenceManager.shared.downloadTitle(with: titles[indexPath.row]) { result in
            
            switch result {
                
            case .success():
                
                print("Downloaded to database")
                
            case .failure(let error):
                
                print(error)
                
            }
            
        }
        
    }
    
}


extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return titles.count
        
    }
    
    // Putting collection view cell inside the collection view
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        
        // Keys of the dictionary are accessed via .key like here .poster_path is
        
        guard let model = titles[indexPath.row].poster_path else { return UICollectionViewCell() }
        
        cell.configure(with: model)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_title ?? title.original_name else { return }
        
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            
            switch result {
                
            case .success(let videoElement):
                
                let title = self?.titles[indexPath.row]
                
                guard let titleOverview = title?.overview else { return }
                
                guard let strongSelf = self else { return }
                
                let titlePreviewViewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview)
                
                self?.delegate?.collectionViewTableViewCellDidTapCell(strongSelf, viewModel: titlePreviewViewModel)
                
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
    
}

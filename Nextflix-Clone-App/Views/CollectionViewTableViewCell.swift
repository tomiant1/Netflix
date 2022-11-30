//
//  CollectionViewTableViewCell.swift
//  Nextflix-Clone-App
//
//  Created by Tomi Antoljak on 11/27/22.
//

import UIKit

class CollectionViewTableViewCell: UITableViewCell {

    static let identifier = "CollectionViewTableViewCell"
    
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
    
}

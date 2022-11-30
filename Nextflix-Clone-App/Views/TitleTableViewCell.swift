//
//  TitleTableViewCell.swift
//  Nextflix-Clone-App
//
//  Created by Tomi Antoljak on 11/29/22.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    static let identifier = "TitleTableViewCell"
    
    private let playButton: UIButton = {
        
        let button = UIButton()
        
        let buttonImage = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        
        button.setImage(buttonImage, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.tintColor = .white
        
        return button
        
    }()
    
    private let titleLabel: UILabel = {
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
        
    }()
    
    private let titleImageView: UIImageView = {
        
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleImageView)
        
        contentView.addSubview(titleLabel)
        
        contentView.addSubview(playButton)
        
        applyConstraints()
        
    }
    
    private func applyConstraints() {
        
         let titleImageViewConstraints = [
         
            titleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            titleImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            titleImageView.widthAnchor.constraint(equalToConstant: 100)
         
         ]
        
        let titleLabelConstraints = [
        
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: titleImageView.trailingAnchor, constant: 20)
        
        ]
        
        let playButtonConstraints = [
        
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        
        ]
        
        NSLayoutConstraint.activate(titleImageViewConstraints)
        
        NSLayoutConstraint.activate(titleLabelConstraints)
        
        NSLayoutConstraint.activate(playButtonConstraints)
        
    }
    
    public func configure(with model: TitleViewModel) {
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else { return }
        
        titleImageView.sd_setImage(with: url)
        
        titleLabel.text = model.titleName
        
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
}

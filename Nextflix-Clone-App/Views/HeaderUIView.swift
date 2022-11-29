//
//  HeroHeaderUIView.swift
//  Nextflix-Clone-App
//
//  Created by Tomi Antoljak on 11/27/22.
//

import UIKit

class HeaderUIView: UIView {
    
    private let playButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle("Play", for: .normal)
        
        button.layer.borderColor = UIColor.white.cgColor
        
        button.layer.borderWidth = 1
        
        // Manually setting button's position no matter the size of the screen
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.layer.cornerRadius = 5
        
        return button
        
    }()
    
    private let downloadButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle("Download", for: .normal)
        
        button.layer.borderColor = UIColor.white.cgColor
        
        button.layer.borderWidth = 1
        
        // Manually setting button's position no matter the size of the screen
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.layer.cornerRadius = 5
        
        return button
        
    }()
    
    private let imageView: UIImageView = {
        
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "cinema")
        
        imageView.clipsToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        
        return imageView
        
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        addSubview(imageView)
        
        addGradient()
        
        addSubview(playButton)
        
        addSubview(downloadButton)
        
        applyConstraints()
        
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        // Setting frame coordinates to its own coordinates instead of its parent view's
        
        imageView.frame = bounds
        
    }
    
    private func applyConstraints() {
        
        let playButtonConstraints = [
        
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 90),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 100)
        
        ]
        
        let downloadButtonConstraints = [
        
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -90),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 100)
        
        ]
        
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
        
    }
    
    private func addGradient() {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [
        
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        
        ]
        
        gradientLayer.frame = bounds
        
        // .addSublayer because we are adding this gradient layer to a subview (image view)
        
        layer.addSublayer(gradientLayer)
        
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
}
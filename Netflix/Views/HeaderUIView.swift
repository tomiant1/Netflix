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
        
        button.setTitleColor(UIColor.label, for: .normal)
        
        button.layer.borderColor = UIColor.label.cgColor
        
        button.layer.borderWidth = 1
        
        // Manually setting button's position no matter the size of the screen
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.layer.cornerRadius = 5
        
        return button
        
    }()
    
    private let downloadButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle("Download", for: .normal)
        
        button.layer.borderColor = UIColor.label.cgColor
        
        button.setTitleColor(UIColor.label, for: .normal)
        
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
                
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        // Setting frame coordinates to its own coordinates instead of its parent view's
        
        imageView.frame = bounds
        
    }
    
    public func configure(with model: TitleViewModel) {
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else { return }
        
        imageView.sd_setImage(with: url)
        
    }
    
    private func addGradient() {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [
        
            UIColor.clear.cgColor,
            UIColor.black.cgColor
        
        ]
        
        gradientLayer.frame = bounds
        
        // .addSublayer because we are adding this gradient layer to a subview (image view)
        
        layer.addSublayer(gradientLayer)
        
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
}

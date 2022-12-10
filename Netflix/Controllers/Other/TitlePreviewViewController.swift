//
//  TitlePreviewViewController.swift
//  Nextflix-Clone-App
//
//  Created by Tomi Antoljak on 11/30/22.
//
// Configure functions just insert data into a data model. Like filling in an empty model.

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {
    
    private let webView: WKWebView = {
       
        let webView = WKWebView()
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        return webView
        
    }()
    
    private let titleLabel: UILabel = {
       
        let label = UILabel()
        
        label.text = ""
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .systemFont(ofSize: 22, weight: .bold)
        
        return label
        
    }()
    
    private let overviewLabel: UILabel = {
       
        let label = UILabel()
        
        label.text = ""
        
        label.font = .systemFont(ofSize: 18, weight: .regular)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.numberOfLines = 0
        
        return label
        
    }()

    override func viewDidLoad() {
        
        super.viewDidLoad()

        view.addSubview(titleLabel)
        view.addSubview(webView)
        view.addSubview(overviewLabel)
                
        view.backgroundColor = .systemBackground
        
        configureConstraints()

    }
    
    private func configureConstraints() {
        
        let webViewConstraints = [
        
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300)
        
        ]
        
        let titleLabelConstraints = [
        
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        
        ]
        
        let overviewLabelConstraints = [
        
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        
        ]
        
        NSLayoutConstraint.activate(webViewConstraints)
        
        NSLayoutConstraint.activate(titleLabelConstraints)
        
        NSLayoutConstraint.activate(overviewLabelConstraints)
        
    }
    
    func configure(with model: TitlePreviewViewModel) {
        
        titleLabel.text = model.titleName
        
        overviewLabel.text = model.titleOverview
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else { return }
        
        webView.load(URLRequest(url: url))
        
    }

}

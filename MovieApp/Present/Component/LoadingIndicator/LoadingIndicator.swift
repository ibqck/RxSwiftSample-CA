//
//  LoadingIndicator.swift
//  MovieApp
//
//  Created by Pyo on 2024/03/29.
//

import Foundation
import UIKit
import Then
import SnapKit
import APNGKit

protocol LoadingPresentable {
    func showLoading()
    func hideLoading()
}

final class LoadingIndicator: UIView {
    static let shared = LoadingIndicator()
    
    var displayLink: CADisplayLink?
    
    private var backgroundView: UIView = UIView(frame: UIScreen.main.bounds)
    
    private let containerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let contentView = UIView().then {
        $0.backgroundColor = .clear
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 24
    }
    
    private lazy var loadingImageView = APNGImageView()
    
    private lazy var messageLabel = UILabel().then{
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.backgroundColor = .clear
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 22
    }
    
    let enableAlphaAnimation = true
    
    private var isLoading: Bool = false {
        didSet {
            if enableAlphaAnimation {
                startOpaticyAnimation()
            }
        }
    }
    
    private enum Constants {
        static let loadingImageViewSize: CGFloat = 48
        static let contentSize: CGFloat = 48
    }
    
    private convenience init() {
        self.init(frame: UIScreen.main.bounds)
        configureUI()
    }
    
    /// Loading Indicator show
    func show(withMessage message: String? = nil) {
        
        if let msg = message {
            messageLabel.text = msg
            messageLabel.backgroundColor = .gray
            
            if msg.isEmpty {
                messageLabel.backgroundColor = .clear
            }
        } else {
            messageLabel.text = ""
            messageLabel.backgroundColor = .clear
        }
        
        DispatchQueue.main.async {
            if self.isLoading {
                return
            } else {
                self.isLoading = true
            }
            
            self.addOnWindow()
            self.configureSubViews()
            
            self.isLoading = true
        }
    }
    
    /// Loading Indicator hide
    func hide() {
        DispatchQueue.main.async {
            if !self.isLoading {
                return
            } else {
                self.isLoading = false
            }
            
            if !self.enableAlphaAnimation {
                self.removeSubViews()
            }
        }
    }
    
    func startOpaticyAnimation() {
        
        displayLink?.invalidate()
        
        displayLink = CADisplayLink(
            target: self,
            selector: #selector(updateOpaticy)
        )
        
        displayLink?.preferredFramesPerSecond = 60
        
        displayLink?.add(
            to: .main,
            forMode: .default
        )
    }
    
    @objc private func updateOpaticy() {
        if isLoading {
            if alpha < 1.0 {
                alpha += 0.1
            } else {
                displayLink?.invalidate()
            }
        } else {
            if alpha > 0.0 {
                alpha -= 0.1
            } else {
                removeSubViews()
                displayLink?.invalidate()
            }
        }
        
    }
    
    private func configureUI() {
        guard let loading = try? APNGImage(
            named: "main_spinner.png",
            decodingOptions: [.cacheDecodedImages]
        ) else { return }
        loadingImageView.image = loading
        backgroundView.backgroundColor = .clear
        
        if enableAlphaAnimation {
            alpha = 0
        }

        self.layoutIfNeeded()
    }
    
    private func addOnWindow() {
        if let window = getKeyWindow() {
            window.addSubview(self)
        }
    }
    
    private func configureSubViews() {
        addSubview(backgroundView)
        backgroundView.addSubview(containerView)
        containerView.addSubview(contentView)
        contentView.addSubview(loadingImageView)
        containerView.addSubview(messageLabel)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        loadingImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.size.equalTo(Constants.loadingImageViewSize)
        }
        
        if let msg = messageLabel.text, !msg.isEmpty {
            contentView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
            }
            
            messageLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(contentView.snp.bottom).offset(16)
            }
        } else {
            contentView.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }
    }
    
    private func removeSubViews() {
        loadingImageView.removeFromSuperview()
        contentView.removeFromSuperview()
        backgroundView.removeFromSuperview()
        messageLabel.removeFromSuperview()
        self.removeFromSuperview()
    }
    
    private func getKeyWindow() -> UIWindow? {
        var window: UIWindow?
        window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        
        return window
    }
}


extension UIViewController: LoadingPresentable {
    func showLoading() {
        LoadingIndicator.shared.show()
    }
    
    func hideLoading() {
        LoadingIndicator.shared.hide()
    }
}

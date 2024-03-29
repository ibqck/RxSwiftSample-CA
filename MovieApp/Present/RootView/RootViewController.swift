//
//  RootViewController.swift
//  MovieApp
//
//  Created by Pyo on 2024/03/29.
//

import UIKit
public protocol RootViewControllerDependencies{}


class RootViewController: BaseViewController {
    public var dependencies: RootViewControllerDependencies
    public let viewModel: RootViewModelProtocol
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    init(dependencies: RootViewControllerDependencies, viewModel: RootViewModelProtocol) {
        self.dependencies = dependencies
        self.viewModel = viewModel
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


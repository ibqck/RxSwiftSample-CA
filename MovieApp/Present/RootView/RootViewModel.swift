//
//  RootViewModel.swift
//  MovieApp
//
//  Created by 60157143 on 2024/03/29.
//



// MARK: - ViewModel Protocols
public protocol RootViewModelDependencies: BaseViewModelDependencies {
}

public protocol RootViewModelInputProtocol: BaseViewModelInputProtocol {
}

public protocol RootViewModelOutputProtocol: BaseViewModelOutputProtocol {
}
    
public protocol RootViewModelProtocol:
    BaseViewModelProtocol,
    RootViewModelInputProtocol,
    RootViewModelOutputProtocol
{
}



final class RootViewModel : BaseViewModel,RootViewModelProtocol{
    internal let dependencies: RootViewModelDependencies
    
    init(dependencies: RootViewModelDependencies) {
        self.dependencies = dependencies
    }
}


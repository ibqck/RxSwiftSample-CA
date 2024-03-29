//
//  BaseViewModel.swift
//  MovieApp
//
//  Created by Pyo on 2024/03/29.
//

import Foundation
import UIKit
import RxSwift
import RxRelay


// MARK: - ViewModel Protocols
public protocol BaseViewModelDependencies {
}

public protocol BaseViewModelInputProtocol {
    func processErrorModel(_ errorModel: ErrorModel)
}

public protocol BaseViewModelOutputProtocol {
    var alert: Observable<AlertModel> { get }
    var loading: Observable<Bool> { get }
}

public protocol BaseViewModelProtocol:
    BaseViewModelInputProtocol,
    BaseViewModelOutputProtocol
{}

public extension BaseViewModelProtocol  {
    var inputs: BaseViewModelInputProtocol { self }
    var outputs: BaseViewModelOutputProtocol { self }
}

// MARK: - ViewModel

public class BaseViewModel:
    BaseViewModelProtocol
{
    var disposeBag = DisposeBag()
    
    // output relay
    let alertRelay = PublishRelay<AlertModel>()
    let loadingRelay = PublishRelay<Bool>()
    
    deinit {
        AppLogger.debug("\(String(describing: self)).\(#function)")
    }
    
    public init() {
    }
    
    // MARK: - Output
    
    public var alert: Observable<AlertModel> { alertRelay.asObservable() }
    public var loading: Observable<Bool> { loadingRelay.asObservable() }
    
    // MARK: - Input
    
    public func publishAlert(_ alertModel: AlertModel) {
        return processErrorModel(
            .alert(alertModel)
        )
    }
    
    public func publishAlert(message: String) {
        return processErrorModel(
            .alert(
                .init(
                    title: nil,
                    message: message
                )
            )
        )
    }
    
    public func publishErrorMessage(error: String) {
        return processErrorModel(
            .errorMessage(error)
        )
    }
    
    public func processErrorModel(_ errorModel: ErrorModel) {
        switch errorModel {
        case .alert(let alertModel):
            alertRelay.accept(alertModel)
            break
        case .errorMessage(let msg):
            alertRelay.accept(
                .init(
                    title: nil,
                    message: msg
                )
            )
        }
    }
}

/// 공통 에러 모델
public enum ErrorModel {
    /// 알럿을 보여주는 에러
    case alert(AlertModel)
    case errorMessage(String)
}

/// 공통 알럿 모델
public struct AlertModel {
    public let title: String?
    public let message: String?
}



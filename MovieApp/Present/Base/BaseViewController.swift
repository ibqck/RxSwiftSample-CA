//
//  BaseViewController.swift
//  MovieApp
//
//  Created by Pyo on 2024/03/29.
//

import UIKit
import RxSwift
import RxCocoa

enum ViewControllerLifecycle {
    case `init`
    case viewDidAppear
    case viewDidDisappear
    case `deinit`
}

public class BaseViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    fileprivate let viewModel: BaseViewModelProtocol
    
    var lifecycle: Observable<ViewControllerLifecycle> {
        return lifecycleSubject.asObservable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 생성자
    ///
    /// - Note: 뷰모델을 사용하지 않을 경우 EmptyViewModel()가 사용된다.
    ///
    public init(viewModel: BaseViewModelProtocol = EmptyViewModel(), nibName: String = #file) {
        self.viewModel = viewModel
        
        // 제레닉 뷰컨트롤러인 경우, 타입을 지우고 뷰컨트롤러 이름만 뽑는다.
        let typeNameWithoutGenerics = String(String(describing: type(of: self)).prefix { $0 != "<" })
        
        if let _ = Bundle(identifier: Bundle.main.bundleIdentifier ?? "")?.url(forResource: typeNameWithoutGenerics, withExtension: "nib"){
            super.init(nibName: typeNameWithoutGenerics,
                       bundle: Bundle(identifier: Bundle.main.bundleIdentifier ?? ""))
        } else {
            //xib 없이 호출하는 화면
            super.init(nibName: nil, bundle: nil)
        }
        
        lifecycleSubject.onNext(.`init`)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        bindControls()
        bindViewModel()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        lifecycleSubject.onNext(.viewDidAppear)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        lifecycleSubject.onNext(.viewDidDisappear)
    }
    
    // MARK: - Binding
    /// 버튼 등 기타 Observable 바인딩
    public func bindControls() {
    }
    
    /// ViewModel 바인딩
    public func bindViewModel() {
        /// 얼럿
        viewModel.outputs.alert
            .observe(on: MainScheduler.instance)
            .bind(with: self) { $0.showAlert($1) }
            .disposed(by: disposeBag)
        /// 로딩
        viewModel.outputs.loading
            .observe(on: MainScheduler.instance)
            .bind(with: self) { (self, isShow) in
                if isShow { LoadingIndicator.shared.show() }
                else { LoadingIndicator.shared.hide() }
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private
    private let lifecycleSubject = ReplaySubject<ViewControllerLifecycle>.create(bufferSize: 1)

    deinit {
        lifecycleSubject.onNext(.deinit)
        AppLogger.debug("[\(String(describing: type(of: self)))] deinit success !!")
    }
}

extension BaseViewController : UIAlertViewDelegate {
    func showAlert(_ alertModel :AlertModel){
        
        
        
        
    }
}


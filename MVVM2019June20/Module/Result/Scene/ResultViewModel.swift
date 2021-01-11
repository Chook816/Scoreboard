//
//  ResultViewModel.swift
//  MVVM2019June20
//
//  Created by Chook Yu Heng on 07/01/2021.
//  Copyright © 2021 Yee Chuan Lee. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ResultViewModel: BaseViewModel, ResultViewModelType {
    
    // MARK: Input
    @ViewEvent var backDidTapped: Driver<Void> = .never()
    
    // MARK: Output
    weak var view: ResultViewType? = nil
    
    // MARK: Intent
    var intent: ResultIntent
    
    // MARK: Initializer
    init(intent: ResultIntent) {
        self.intent = intent
        super.init()
    }
    
    // MARK: Transform
    override func transform() {
        super.transform()
        
        let routeToMainScreen = backDidTapped
            .do(onNext: { self.view?.dismiss()})
        
        disposeBag.insert(
            routeToMainScreen.drive()
        )
    }

}

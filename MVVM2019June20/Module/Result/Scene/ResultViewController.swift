//
//  ResultViewController.swift
//  MVVM2019June20
//
//  Created by Chook Yu Heng on 07/01/2021.
//  Copyright © 2021 Yee Chuan Lee. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxQRScanner
import RxBiBinding

class ResultViewController: BaseViewController<ResultViewModel> {
    
    // MARK: outlets
    @IBOutlet weak var congratulationLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    var intent: ResultIntent!
    
    override func loadView() {
        super.loadView()
        viewModel = DI.resolver.resolve(ResultViewModel.self, argument: intent!)
    }
    
    override func setupView() {
        super.setupView()
        navigationItem.title = "Result"
        congratulationLabel.text = "Congratulations! Winner is \(intent.winner)"
    }
    
    override func setupTransformInput() {
        super.setupTransformInput()
        viewModel.view = self
        viewModel.backDidTapped = backButton.rx.tap.asDriver()
    }
    
    override func subscribe() {
        super.subscribe()
    }
    
}

// MARK: TestViewType
extension ResultViewController: ResultViewType {
    
    func dismiss() {
        navigationController?.popToRootViewController(animated: true)
    }
    
}


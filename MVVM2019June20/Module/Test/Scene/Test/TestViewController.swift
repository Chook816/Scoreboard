//
//  TestViewController.swift
//  MVVM2019June20
//
//  Created by Chook Yu Heng on 05/01/2021.
//  Copyright © 2021 Yee Chuan Lee. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxQRScanner
import RxBiBinding

class TestViewController: BaseViewController<TestViewModel> {
    
    // MARK: outlets
    @IBOutlet private weak var playerOneLabel: UILabel!
    @IBOutlet private weak var playerTwoLabel: UILabel!
    @IBOutlet private weak var playerOneButton: UIButton!
    @IBOutlet private weak var playerTwoButton: UIButton!
    @IBOutlet private weak var pickerView: UIPickerView!
    @IBOutlet private weak var startButton: UIButton!
    
    var intent: TestIntent!
    
    override func loadView() {
        super.loadView()
        intent = TestIntent()
        viewModel = DI.resolver.resolve(TestViewModel.self, argument: intent!)
    }
    
    override func setupView() {
        super.setupView()
        navigationItem.title = "Scoreboard"
    }
    
    override func setupTransformInput() {
        super.setupTransformInput()
        viewModel.view = self
        viewModel.startLoad = rx.viewWillAppearForFirstTime
        viewModel.playerOneScanDidTapped = playerOneButton.rx.tap.asDriver()
        viewModel.playerTwoScanDidTapped = playerTwoButton.rx.tap.asDriver()
        viewModel.startGame = startButton.rx.tap.asDriver()
    }
    
    override func subscribe() {
        super.subscribe()
        disposeBag.insert(
            viewModel.pickerDataSource.bind(to: pickerView.rx.itemTitles) { (row, element) in
                return element
            },
            pickerView.rx.itemSelected
                .subscribe(onNext: { (row, value) in
                    self.viewModel.round.accept(self.viewModel.pickerDataSource.value[row])
                }),
            viewModel.enableButton
                    .bind { [weak self] isEnabled in
                        guard let self = self, let isEnable = isEnabled else { return }
                        self.startButton.isEnabled = isEnable
                    }
        )
    }
    
}

// MARK: TestViewType
extension TestViewController: TestViewType {
    
    func routeToQRScannerOne() {
        QRScanner.popup(on: self).map({ (result) -> String? in
            if case let .success(name) = result {
                self.viewModel.playerOne.accept(name)
                return name
            } else {
                let mockData = "Default Player 1"
                self.viewModel.playerOne.accept(mockData)
                return mockData
            }
        })
        .bind(to: playerOneLabel.rx.text)
        .disposed(by: disposeBag)
    }
    
    func routeToQRScannerTwo() {
        QRScanner.popup(on: self).map({ (result) -> String? in
            if case let .success(name) = result {
                self.viewModel.playerTwo.accept(name)
                return name
            } else {
                let mockData = "Default Player 2"
                self.viewModel.playerTwo.accept(mockData)
                return mockData
            }
        })
        .bind(to: playerTwoLabel.rx.text)
        .disposed(by: disposeBag)
    }
    
    func routeToScoreboard() {
        guard let playerOne = viewModel.playerOne.value,
              let playerTwo = viewModel.playerTwo.value,
              let round = viewModel.round.value else { return }
        let screen = DI.resolver.resolve(ScoreboardViewControllerType.self)!
        screen.intent = ScoreboardIntent(playerOne: playerOne, playerTwo: playerTwo, round: round)
        navigationController?.pushViewController(screen)
    }
    
}

//
//  ScoreboardViewController.swift
//  MVVM2019June20
//
//  Created by Chook Yu Heng on 06/01/2021.
//  Copyright © 2021 Yee Chuan Lee. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxQRScanner
import RxBiBinding

class ScoreboardViewController: BaseViewController<ScoreboardViewModel> {
    
    // MARK: outlets
    @IBOutlet private weak var timer: UILabel!
    @IBOutlet private weak var playerOneLabel: UILabel!
    @IBOutlet private weak var playerTwoLabel: UILabel!
    @IBOutlet private weak var roundLabel: UILabel!
    @IBOutlet private weak var playerOneWinButton: UIButton!
    @IBOutlet private weak var playerTwoWinButton: UIButton!
    @IBOutlet private weak var containerView: UIView!
    
    var intent: ScoreboardIntent!
    
    let scoreboardTableView = DI.resolver.resolve(ScoreboardListViewControllerType.self)!
    
    override func loadView() {
        super.loadView()
        viewModel = DI.resolver.resolve(ScoreboardViewModel.self, argument: intent!)
    }
    
    override func setupView() {
        super.setupView()
        navigationItem.title = "Game"
        
        playerOneLabel.text = intent.playerOne
        playerTwoLabel.text = intent.playerTwo
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.isUserInteractionEnabled = false
        self.addChild(scoreboardTableView)
        self.containerView.addSubview(scoreboardTableView.view)
        scoreboardTableView.didMove(toParent: self)
    }
    
    override func setupTransformInput() {
        super.setupTransformInput()
        viewModel.view = self
        viewModel.playerOneWinDidTapped = playerOneWinButton.rx.tap.asDriver()
        viewModel.playerTwoWinDidTapped = playerTwoWinButton.rx.tap.asDriver()
    }
    
    override func subscribe() {
        super.subscribe()
        let winner = viewModel.winner.map { $0.isNilOrEmpty }
        disposeBag.insert(
            viewModel.currentRoundText
                .bind(to: roundLabel.rx.text)
//            winner.bind { isEnabled in
//                [self.playerOneWinButton, self.playerTwoWinButton].forEach {
//                    $0?.isEnabled = isEnabled
//                }
//            }
        )
    }
    
}

// MARK: TestViewType
extension ScoreboardViewController: ScoreboardViewType {
    
    func routeToResult() {
        guard let winner = viewModel.winner.value else { return }
         let screen = DI.resolver.resolve(ResultViewControllerType.self)!
         screen.intent = ResultIntent(winner: winner)
         navigationController?.pushViewController(screen)
    }
    
    func updateWinRecord() {
        var newRecord = ScoreboardCellViewModel()
        newRecord.playerOne = viewModel.playerOne.value
        newRecord.playerTwo = viewModel.playerTwo.value
        newRecord.playerOneScore = String(viewModel.playerOneCounter.value)
        newRecord.playerTwoScore = String(viewModel.playerTwoCounter.value)
        scoreboardTableView.intent.winRecord = newRecord
        scoreboardTableView.addRecord()
    }
    
    
    
    func rxUpdateWinRecord(scoreDetails: ScoreDetails) {
        var newRecord = ScoreboardCellViewModel()
        newRecord.playerOne = scoreDetails.playerOne
        newRecord.playerTwo = scoreDetails.playerTwo
        newRecord.playerOneScore = scoreDetails.playerOneScore.string
        newRecord.playerTwoScore = scoreDetails.playerTwoScore.string
        scoreboardTableView.intent.winRecord = newRecord
        scoreboardTableView.addRecord()
    }
    
}

struct ScoreDetails {
    var playerOne: String
    var playerTwo: String
    var playerOneScore: Int
    var playerTwoScore: Int
}

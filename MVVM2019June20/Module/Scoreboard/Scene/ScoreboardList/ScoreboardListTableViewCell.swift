//
//  ScoreboardListTableViewCell.swift
//  MVVM2019June20
//
//  Created by Chook Yu Heng on 07/01/2021.
//  Copyright © 2021 Yee Chuan Lee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ScoreboardListTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet private weak var playerOneLabel: UILabel!
    @IBOutlet private weak var playerOneScoreLabel: UILabel!
    @IBOutlet private weak var playerTwoScoreLabel: UILabel!
    @IBOutlet private weak var playerTwoLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        dispose()
    }
    
    var viewModel: ScoreboardCellViewModel? {
        didSet {
            dispose()
            if let viewModel = viewModel {
                playerOneLabel.text = viewModel.playerOne
                playerTwoLabel.text = viewModel.playerTwo
                playerOneScoreLabel.text = viewModel.playerOneScore
                playerTwoScoreLabel.text = viewModel.playerTwoScore
            }
        }
    }
    
}

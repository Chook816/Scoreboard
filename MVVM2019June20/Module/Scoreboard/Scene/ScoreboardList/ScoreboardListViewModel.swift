//
//  ScoreboardListViewModel.swift
//  MVVM2019June20
//
//  Created by Chook Yu Heng on 07/01/2021.
//  Copyright © 2021 Yee Chuan Lee. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

final class ScoreboardListViewModel: BasePaginationViewModel<(), ScoreboardSection, ()> {
    
    //Input
    let scoreItems = BehaviorRelay<[ScoreboardCellViewModel]> (value: [])
    
    //Initialize
    required init() {
        super.init()
        self.pageSize = -1
        self.enableLoadMore = false
    }
    //Transform
    override func transform() {
        super.transform()
        //Subscribe
        let loadScore = scoreItems.asDriver()
            .flatMap({ _ in
                return self.getStartLoadData()
            })
            .do(onNext: self.resetAsFirstPage)
        
        disposeBag.insert(
            loadScore.drive()
        )
    }
    
    override func mapResponseToItems(output: ()) -> [ScoreboardItem] {
        let scores = scoreItems.value
        return (scores).map { response -> ScoreboardItem in
            var score = ScoreboardItem()
            score.playerOne = response.playerOne
            score.playerTwo = response.playerTwo
            score.playerOneScore = response.playerOneScore
            score.playerTwoScore = response.playerTwoScore
            return score
        }
    }
    
    override func createSections(list: [ScoreboardItem]) -> [ScoreboardSection] {
        return [SectionModel<String, ScoreboardItem>.init(model: "", items: list)]
    }
    
    override func getStartLoadData() -> Driver<()> {
        return .just(())
    }
    
}

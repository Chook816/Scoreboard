//
//  ScoreboardListTypes.swift
//  MVVM2019June20
//
//  Created by Chook Yu Heng on 07/01/2021.
//  Copyright © 2021 Yee Chuan Lee. All rights reserved.
//

import Foundation
import RxDataSources

typealias ScoreboardItem = ScoreboardCellViewModel

typealias ScoreboardSection = SectionModel<String, ScoreboardItem>

protocol ScoreboardListViewType: BasePaginationViewType {
    var intent: ScoreboardListIntent! { set get }
    func addRecord()
}

typealias ScoreboardListViewControllerType = UIViewController & ScoreboardListViewType

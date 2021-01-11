//
//  ScoreboardListViewController.swift
//  MVVM2019June20
//
//  Created by Chook Yu Heng on 07/01/2021.
//  Copyright © 2021 Yee Chuan Lee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SwifterSwift
import RxBiBinding

class ScoreboardListViewController: BasePaginationViewController<ScoreboardListViewModel>, ScoreboardListViewType {
    
    var intent: ScoreboardListIntent!
    
    //MARK: View Cycle
    override func loadView() {
        super.loadView()
        self.intent = ScoreboardListIntent(winRecord: ScoreboardCellViewModel())
        viewModel ??= ScoreboardListViewModel()
        viewModel.disposed(by: disposeBag)
    }
    
    //setupView
    override func setupListView() {
        super.setupListView()
        listView.register(nibWithCellClass: ScoreboardListTableViewCell.self)
        listView.tableFooterView = UIView()
    }
    
    //transform
    override func setupTransformInput() {
        super.setupTransformInput()
        viewModel.startLoad = rx.viewWillAppearForFirstTime
    }
    
    //subscribe
    override func subscribe() {
        super.subscribe()
        disposeBag.insert(
            
        )
    }
    
    override func configureCell(ds: TableViewSectionedDataSource<ScoreboardSection>, tv: UITableView, ip: IndexPath, item: ScoreboardItem) -> UITableViewCell {
        let cell = tv.dequeueReusableCell(withClass: ScoreboardListTableViewCell.self, for: ip)
        cell.viewModel = item
        cell.layoutIfNeeded()
        return cell
    }
    
    func addRecord() {
        var existingRecord = viewModel.scoreItems.value
        existingRecord.append(intent.winRecord)
        viewModel.scoreItems.accept(existingRecord)
    }
    
}

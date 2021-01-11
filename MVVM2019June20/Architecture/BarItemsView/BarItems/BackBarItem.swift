//
//  BackNavigationBarItem.swift
//  TestSMS
//
//  Created by Yee Chuan Lee on 08/04/2019.
//  Copyright © 2019 Yee Chuan Lee. All rights reserved.
//

import UIKit

extension BarItem {
    static func back(closure: ((UIViewController)->())? = BackBarItem.defaultClosure) -> BarItem {
        let ret = BackBarItem()
        ret.closure = closure
        return ret
    }
}

class BackBarItem: BarItem {
    static let defaultId = "back"
    class func defaultClosure(_ vc:UIViewController) {
        vc.popWithResult()
    }
    init() {
        super.init(id: BackBarItem.defaultId)
    }
    override func createBarButtonItem() -> UIBarButtonItem? {
        let image:UIImage
        if #available(iOS 13.0, *) {
            image = UIImage(systemName: "chevron.left")!
        } else {
            image = UIImage()
        }
        let item = UIBarButtonItem(image:image , style: .plain, target: self, action: #selector(self.performAction(sender:)))
        item.imageInsets = .zero
        return item
    }
}

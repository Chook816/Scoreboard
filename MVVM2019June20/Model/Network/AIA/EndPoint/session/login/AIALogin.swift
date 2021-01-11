//
//  AIALogin.swift
//  MVVM2019June20
//
//  Created by Yee Chuan Lee on 01/07/2019.
//  Copyright © 2019 Yee Chuan Lee. All rights reserved.
//

import Foundation

extension AIA.EndPoint {
    public class Login: AIA.BaseTarget<AIA.RequestLogin, AIA.ResponseLogin> {
        override var path: String { return "login" }
    }
}

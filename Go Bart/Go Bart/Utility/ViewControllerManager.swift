//
// Created by Hongfei on 2018/8/8.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit

class ViewControllerManager {
    private static var views: [String: UIViewController] = [:]

    public static func getViewController<T:UIViewController>(of type: T.Type) -> T {
        if let result = views[String(describing: type)] {
            return result as! T
        } else {
            let newItem = type.init()
            views[String(describing: type)] = newItem
            return newItem
        }
    }
}

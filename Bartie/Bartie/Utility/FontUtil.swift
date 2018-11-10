//
// Created by Hongfei on 11/9/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit

class FontUtil {
    static func pingFangTCLight(size: CGFloat) -> UIFont? {
        return UIFont(name: "PingFangTC-Light", size: size)
    }

    static func pingFangTCRegular(size: CGFloat) -> UIFont? {
        return UIFont(name: "PingFangTC-Regular", size: size)
    }

    static func pingFangTCMedium(size: CGFloat) -> UIFont? {
        return UIFont(name: "PingFangTC-Medium", size: size)
    }

    static let pingFangTCRegular17 = pingFangTCRegular(size: 17)
}

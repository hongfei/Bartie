//
// Created by Zhou, Hongfei on 8/16/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import SwiftIcons
import UIColor_Hex_Swift

class Icons {
    static let iconSize = CGSize(width: 20, height: 20)
    static let searchIcon = UIImage(icon: .icofont(.search), size: Icons.iconSize, textColor: UIColor("#C7C7CD"))
    static let locatingIcon = UIImage(icon: .icofont(.locationArrow), size: Icons.iconSize, textColor: UIColor("#C7C7CD"))
    static let startDot = UIImage(icon: .fontAwesomeSolid(.circle), size: CGSize(width: 9, height: 9), textColor: .red)
    static let endDot = UIImage(icon: .fontAwesomeSolid(.circle), size: CGSize(width: 9, height: 9), textColor: .green)
    static let middleDot = UIImage(icon: .fontAwesomeSolid(.circle), size: CGSize(width: 7, height: 7), textColor: .gray)
    static let rightArrow = UIImage(icon: .fontAwesomeSolid(.caretRight), size: Icons.iconSize)
    static let delete = UIImage(icon: .fontAwesomeSolid(.timesCircle), size: Icons.iconSize)

    static func trainIcon(of color: UIColor, width: Int = 20, height: Int = 20) -> UIImage {
        return UIImage(icon: .fontAwesomeSolid(.train), size: CGSize(width: width, height: height), textColor: color)
    }

    static func dot(of color: UIColor, width: Int = 20, height: Int = 20) -> UIImage {
        return UIImage(icon: .fontAwesomeSolid(.circle), size: CGSize(width: width, height: height), textColor: color)
    }
}

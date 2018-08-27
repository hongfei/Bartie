//
// Created by Zhou, Hongfei on 8/16/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import SwiftIcons
import UIColor_Hex_Swift

class Icons {
    static let iconSize = CGSize(width: 40, height: 40)
    static let train = UIImage(icon: .fontAwesomeSolid(.subway), size: Icons.iconSize)
    static let search = UIImage(icon: .icofont(.search), size: Icons.iconSize, textColor: UIColor("#C7C7CD"))
    static let locating = UIImage(icon: .icofont(.locationArrow), size: CGSize(width: 27, height: 27), textColor: UIColor("#C7C7CD"))
    static let startDot = UIImage(icon: .fontAwesomeSolid(.circle), size: Icons.iconSize, textColor: .red)
    static let endDot = UIImage(icon: .fontAwesomeSolid(.circle), size: Icons.iconSize, textColor: .green)
    static let middleDot = UIImage(icon: .fontAwesomeSolid(.circle), size:Icons.iconSize, textColor: .gray)
    static let rightArrow = UIImage(icon: .fontAwesomeSolid(.caretRight), size: Icons.iconSize)
    static let delete = UIImage(icon: .fontAwesomeSolid(.timesCircle), size: Icons.iconSize)
    static let arrowDown = UIImage(icon: .fontAwesomeSolid(.arrowDown), size: Icons.iconSize)
    static let arrowUp = UIImage(icon: .fontAwesomeSolid(.arrowUp), size: Icons.iconSize)
    static let location = UIImage(icon: .fontAwesomeSolid(.mapMarkerAlt), size: Icons.iconSize)
    static let toilet = UIImage(icon: .emoji(.restroom), size: Icons.iconSize, textColor: .gray)

    static func train(of color: UIColor) -> UIImage {
        return UIImage(icon: .fontAwesomeSolid(.train), size: Icons.iconSize, textColor: color)
    }

    static func dot(of color: UIColor) -> UIImage {
        return UIImage(icon: .fontAwesomeSolid(.circle), size: Icons.iconSize, textColor: color)
    }
}

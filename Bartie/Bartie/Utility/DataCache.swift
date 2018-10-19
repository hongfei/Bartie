//
// Created by Hongfei on 2018/8/9.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation
import Cache

class DataCache {
    public static let diskConfig = DiskConfig(
            name: "DiskWeekCache",
            expiry: .date(Date().addingTimeInterval(60 * 60 * 24 * 7)),
            maxSize: 10000,
            protectionType: .complete
    )
    public static let persistentConfig = DiskConfig(
            name: "PersistentData",
            expiry: .never,
            maxSize: 100000,
            protectionType: .complete
    )
}

//
// Created by Hongfei on 2018/8/10.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation

class DateUtil {
    static let dateFormatter = DateFormatter()
    static func getTimeDifferenceToNow(dateString: String) -> Int {
        self.dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        self.dateFormatter.timeZone = TimeZone(identifier: "America/Los_Angeles")
        self.dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        if let tripTime = self.dateFormatter.date(from: dateString) {
            return Int(tripTime.timeIntervalSinceNow) / 60
        } else {
            return 10000
        }
    }
}

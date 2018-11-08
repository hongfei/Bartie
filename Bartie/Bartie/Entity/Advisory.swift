//
// Created by Zhou, Hongfei on 10/30/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation

class Advisory: Codable {
    let station: String
    let description: AdvisoryDescription
    let type: String?
    let posted: String?

    init(station: String, type: String, description: AdvisoryDescription, posted: String) {
        self.station = station
        self.type = type
        self.description = description
        self.posted = posted
    }
}

class AdvisoryDescription: Codable {
    let cdData: String

    init(cdData: String) {
        self.cdData = cdData
    }

    private enum CodingKeys: String, CodingKey {
        case cdData = "#cdata-section"
    }
}
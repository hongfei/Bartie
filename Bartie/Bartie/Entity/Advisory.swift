//
// Created by Zhou, Hongfei on 10/30/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation

class Advisory: Codable {
    let station: String
    let description: AdvisoryDescription

    init(station: String, description: AdvisoryDescription) {
        self.station = station
        self.description = description
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
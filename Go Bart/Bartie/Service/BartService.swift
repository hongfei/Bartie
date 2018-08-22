//
// Created by Zhou, Hongfei on 8/7/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation
import Alamofire

class BartService {
    static let BART_HOST = "https://api.bart.gov/api"
    static let BART_TOKEN = "QEBS-PYIU-9G9T-DWE9"
    static let COMMON_PARAMS = ["key": "QEBS-PYIU-9G9T-DWE9", "json": "y"]

    static func getResponse(for resource: String, withParams: [String: String], completionHandler: @escaping (Any?) -> Void) {
        let fullParams = COMMON_PARAMS.merging(withParams, uniquingKeysWith: { $1 })
        Alamofire.request(BART_HOST + resource, method: .get, parameters: fullParams).responseJSON { response in
            completionHandler(response.result.value)
        }
    }
}

//
// Created by Zhou, Hongfei on 10/30/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import SwiftyJSON

class BartAdvisoryRepository {
    private static let ADVISORY_RESOURCE = "/bsa.aspx"
    private static let decoder = JSONDecoder()

    class func getCurrentAdvisory(completionHandler: @escaping ([Advisory]?) -> Void) {
        BartService.getResponse(for: ADVISORY_RESOURCE, withParams: ["cmd": "bsa"]) { result in
            guard let jsonResult = result else {
                return completionHandler(nil)
            }

            guard let optionalAdvisories = JSON(jsonResult)["root"]["bsa"].array?.map({ json in
                return try? decoder.decode(Advisory.self, from: json.rawData())
            }) else {
                return completionHandler([])
            }

            let advisories = optionalAdvisories.filter({ adv in adv != nil }).map({ adv in adv! })
            return completionHandler(advisories)
        }
    }
}

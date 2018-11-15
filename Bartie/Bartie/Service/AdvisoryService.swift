//
// Created by Zhou, Hongfei on 10/30/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation

class AdvisoryService {
    class func getLatestAdvisories(completionHandler: @escaping ([Advisory]?) -> Void) {
        BartAdvisoryRepository.getCurrentAdvisory(completionHandler: completionHandler)
    }
}

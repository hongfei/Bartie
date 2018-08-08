//
// Created by Zhou, Hongfei on 8/7/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit

class StationCollectionViewController: UICollectionViewController {
    let stations: [Station]?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(stations: [Station]) {
        self.stations = stations
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        return super.collectionView(collectionView, cellForItemAt: indexPath)
    }
}

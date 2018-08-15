//
// Created by Hongfei on 2018/8/12.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation
import MapKit

class RouteDetailMapView: UITableViewCell, MKMapViewDelegate {
    var map: MKMapView!
    var stations: [String] = []
    var safeArea: UILayoutGuide!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.safeArea = self.contentView.safeAreaLayoutGuide
        self.insetsLayoutMarginsFromSafeArea = false
        initializeCell()
    }

    private func initializeCell() {
        self.map = MKMapView()
        self.map.showsUserLocation = false
        self.map.translatesAutoresizingMaskIntoConstraints = false
        self.map.delegate = self
        self.contentView.addSubview(self.map)

        NSLayoutConstraint.activate([
            self.map.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor),
            self.map.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor),
            self.map.topAnchor.constraint(equalTo: self.safeArea.topAnchor),
            self.map.widthAnchor.constraint(equalToConstant: self.frame.width),
            self.map.heightAnchor.constraint(equalToConstant: self.frame.width / 3 * 2),
            self.map.bottomAnchor.constraint(lessThanOrEqualTo: self.safeArea.bottomAnchor)
        ])
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        view.canShowCallout = true
        return view
    }
    
    func showStations(stations: [Station]) {
        self.map.showAnnotations(stations.filter({ station in !self.stations.contains(station.abbr) }).map({ station in
            let point = MKPointAnnotation()
            let coord = CLLocationCoordinate2D(latitude: Double(station.gtfs_latitude)!, longitude: Double(station.gtfs_longitude)!)
            point.coordinate = coord
            point.title = station.name
            self.stations.append(station.abbr)
            return point
        }), animated: true)
    }
}
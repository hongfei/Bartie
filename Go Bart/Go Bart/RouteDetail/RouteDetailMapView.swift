//
// Created by Hongfei on 2018/8/12.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation
import MapKit

class RouteDetailMapView: UITableViewCell, MKMapViewDelegate {
    var map: MKMapView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.map = MKMapView()
        self.map.translatesAutoresizingMaskIntoConstraints = false
        self.map.delegate = self
        self.addSubview(self.map)

        NSLayoutConstraint.activate([
            self.map.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.map.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.map.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.map.heightAnchor.constraint(equalToConstant: self.frame.width / 3 * 2),
            self.contentView.bottomAnchor.constraint(equalTo: self.map.bottomAnchor)
        ])
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        view.canShowCallout = true
        return view
    }
    
    func showStations(stations: [Station]) {
        self.map.showAnnotations(stations.map({ station in
            let point = MKPointAnnotation()
            let coord = CLLocationCoordinate2D(latitude: Double(station.gtfs_latitude)!, longitude: Double(station.gtfs_longitude)!)
            point.coordinate = coord
            point.title = station.name
            return point
        }), animated: true)
    }
}
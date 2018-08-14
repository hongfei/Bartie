//
// Created by Hongfei on 2018/8/12.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation
import MapKit

class RouteDetailMapView: MKMapView, MKMapViewDelegate {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.delegate = self
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        view.canShowCallout = true
        return view
    }
    
    func showStations(stations: [Station]) {
        self.showAnnotations(stations.map({ station in
            let point = MKPointAnnotation()
            let coord = CLLocationCoordinate2D(latitude: Double(station.gtfs_latitude)!, longitude: Double(station.gtfs_longitude)!)
            point.coordinate = coord
            point.title = station.name
            return point
        }), animated: true)
    }

}
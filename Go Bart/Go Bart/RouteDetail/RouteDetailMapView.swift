//
// Created by Hongfei on 2018/8/12.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import MapKit
import PinLayout

class RouteDetailMapView: UITableViewCell, MKMapViewDelegate {
    var map: MKMapView = MKMapView()
    var stations: [String] = []

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.map.showsUserLocation = false
        self.map.showsCompass = true
        self.map.delegate = self
        self.addSubview(self.map)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.map.pin.all(pin.safeArea)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        view.canShowCallout = true
        return view
    }
    
    func showStations(stations: [Station]) {
        let newStations = stations.filter({ station in !self.stations.contains(station.abbr) })
        self.map.showAnnotations(newStations.map({ station in
            let point = MKPointAnnotation()
            if let latitude = Double(station.gtfs_latitude), let longitude = Double(station.gtfs_longitude) {
                let coord = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                point.coordinate = coord
                point.title = station.name
                self.stations.append(station.abbr)
            }
            return point
        }), animated: false)
    }
}

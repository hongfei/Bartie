//
// Created by Hongfei on 2018/8/12.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import MapKit
import PinLayout
import UIColor_Hex_Swift

class RouteDetailMapView: UITableViewCell, MKMapViewDelegate {
    var map: MKMapView = MKMapView()
    var shownAnnotations: [MKPointAnnotation] = []
    var shownAnnotationColorMap: [String: String] = [:]

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
        if let optionalTitle = annotation.title, let title = optionalTitle {
            view.pinTintColor = UIColor(self.shownAnnotationColorMap[title] ?? "#FF0000")
        }
        return view
    }

    func showStations(stations: [Station], colorMap: [String: String]) {
        if stations.count <= self.shownAnnotations.count {
            return
        }
        self.map.removeAnnotations(self.shownAnnotations)
        self.shownAnnotations = []
        self.shownAnnotationColorMap = colorMap
        self.map.showAnnotations(stations.map({ station in
            let point = MKPointAnnotation()
            if let latitude = Double(station.gtfs_latitude), let longitude = Double(station.gtfs_longitude) {
                let coord = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                point.coordinate = coord
                point.title = station.name
            }
            self.shownAnnotations.append(point)
            return point
        }), animated: false)
    }
}

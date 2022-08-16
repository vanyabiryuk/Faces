//
//  ViewPersonView.swift
//  Faces
//
//  Created by Vanüsha on 17.08.2022.
//

import MapKit
import SwiftUI

struct IdentifiableLocation: Identifiable {
    let id = UUID()
    let location: CLLocationCoordinate2D
}

struct ViewPersonView: View {
    var person: Person
    @State private var coordinateRegion: MKCoordinateRegion
    
    
    var body: some View {
        Form {
            Image(uiImage: person.image)
                .resizable()
                .scaledToFit()
            
            if let location = person.location {
                let places = IdentifiableLocation(location: location)
                Map(coordinateRegion: $coordinateRegion, annotationItems: [places]) { place in
                    MapMarker(coordinate: place.location, tint: .red)
                }
                .frame(height: 400)
            }
            
        }
        .navigationTitle(person.name)
    }
    
    init(person: Person) {
        self.person = person
        if let personLocation = person.location {
            _coordinateRegion = State(initialValue: MKCoordinateRegion(center: personLocation,
                                                                       span: MKCoordinateSpan(latitudeDelta: 0.25,
                                                                                              longitudeDelta: 0.25)))
        } else {
            _coordinateRegion = State(initialValue: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50,
                                                                                                      longitude: 0),
                                                                       span: MKCoordinateSpan(latitudeDelta: 25,
                                                                                              longitudeDelta: 25)))
        }
    }
}

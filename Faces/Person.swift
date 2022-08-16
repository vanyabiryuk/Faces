//
//  Person.swift
//  Faces
//
//  Created by Vanüsha on 02.08.2022.
//

import UIKit
import CoreLocation

struct SavedPerson: Codable {
    let id: UUID
    let name: String
    
    let lat: CLLocationDegrees?
    let lon: CLLocationDegrees?
}

struct Person: Identifiable, Comparable {
    
    var id: UUID
    var name: String
    var image: UIImage
    var location: CLLocationCoordinate2D?
    
    init?(name: String, image: UIImage?, location: CLLocationCoordinate2D? = nil) {
        guard let safeImage = image else { return nil }
        self.id = UUID()
        self.name = name
        self.image = safeImage
        self.location = location
    }
    
    init(id: UUID = UUID(), name: String, image: UIImage, location: CLLocationCoordinate2D? = nil) {
        self.id = id
        self.name = name
        self.image = image
        self.location = location
    }
    
    static let example = Person(name: "Doctor Who?", image: UIImage(systemName: "person.fill.questionmark"))
    
    static func < (lhs: Person, rhs: Person) -> Bool {
        lhs.name < rhs.name
    }
    
    static func == (lhs: Person, rhs: Person) -> Bool {
        lhs.id == rhs.id
    }
}

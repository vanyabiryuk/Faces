//
//  ContentView.swift
//  Faces
//
//  Created by Vanüsha on 30.07.2022.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @State private var showingImagePicker = false
    @State private var selectedPerson: Person? = nil
    @State private var persons: [Person] = []
    
    var personsSorted: [Person] {
        persons.sorted()
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(personsSorted) { person in
                    NavigationLink {
                        ViewPersonView(person: person)
                    } label: {
                        HStack {
                            Image(uiImage: person.image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 44, height: 44)
                                .clipShape(Circle())
                            
                            Text(person.name)
                                .font(.headline)
                        }
                    }
                }
            }
            .navigationTitle("Faces")
            .toolbar {
                Button {
                    showingImagePicker = true
                } label: {
                    Label("", systemImage: "plus.circle")
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(person: $selectedPerson)
            }
            .sheet(item: $selectedPerson) { person in
                AddPersonView(persons: $persons, person: person, save: saveData)
            }
        }
        .onAppear(perform: loadData)
    }
    
    func saveData() {
        let savedPersons = persons.map { person in
            SavedPerson(id: person.id,
                        name: person.name,
                        lat: person.location?.latitude,
                        lon: person.location?.longitude)
        }
        
        FileManager.save(savedPersons, to: K.savedPersonsFileName)
        
        for person in persons {
            let imageFileName = "\(person.id.uuidString).png"
            guard let url = FileManager.documentDirectoryURL(appending: imageFileName)
            else { continue }
            
            if FileManager.default.fileExists(atPath: url.path) == false {
                FileManager.save(person.image, to: imageFileName)
            }
        }
    }
    
    func loadData() {
        guard let savedPersons: [SavedPerson] = FileManager.loadObject(from: K.savedPersonsFileName)
        else { return }
        
        let persons: [Person] = savedPersons.compactMap { person in
            let imageFileName = "\(person.id.uuidString).png"
            guard let image = FileManager.loadImage(from: imageFileName)
            else { return nil }
            if let latitude = person.lat,
               let longitude = person.lon {
                return Person(id: person.id,
                              name: person.name,
                              image: image,
                              location: CLLocationCoordinate2D(latitude: latitude,
                                                               longitude: longitude))
            } else {
                return Person(id: person.id, name: person.name, image: image)
            }
        }
        
        self.persons = persons
    }
}

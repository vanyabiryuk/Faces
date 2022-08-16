//
//  AddPersonView.swift
//  Faces
//
//  Created by Vanüsha on 16.08.2022.
//

import SwiftUI

struct AddPersonView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var persons: [Person]
    @State private var name = ""

    var person: Person
    var save: () -> Void
    
    let locationFetcher = LocationFetcher()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Image(uiImage: person.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                }
                
                Section {
                    TextField("Name", text: $name)
                    Button("Save") {
                        guard let newPerson = Person(name: name,
                                                     image: person.image,
                                                     location: locationFetcher.lastKnownLocation)
                        else { return }
                        
                        persons.append(newPerson)
                        save()
                        dismiss()
                    }
                }
            }
            .navigationTitle("Add new Person")
        }
        .onAppear {
            locationFetcher.start()
        }
    }
}

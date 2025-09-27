//
//  ContentView.swift
//  TaskLifecycle
//
//  Created by Luiz Fernando de Aquino Dias on 2025-09-27.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            NavigationLink(destination: DetailView()) {
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Press here to go to Detail View")                    
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

//
//  DetailView.swift
//  TaskLifecycle
//
//  Created by Luiz Fernando de Aquino Dias on 2025-09-27.
//

import SwiftUI

struct DetailView: View {
    
    @State var viewModel: DetailViewModel = DetailViewModel()
    
    var body: some View {
        Section(header: Text("Navigate back to force task cancellation")) {
            List(viewModel.data, id: \.self) { item in
                HStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text(item)
                }
            }
        }
        .refreshable {
            await viewModel.refreshData()
        }
        .task {
            await viewModel.initializeData()
        }
        .onDisappear {
            viewModel.cancelRefresh()
        }
    }
}

@Observable
class DetailViewModel {
    
    /* Storing the refresh task in the VM so we can have a cancellation point
       Then we call cancelRefresh() from the .onDisappear modifier in the View */
    private var refreshTask: Task<Void, Never>? = nil
    var isLoading: Bool = false
    var data: [String] = []
    
    func initializeData() async {
        do {
            print("Initialize Data task started! 🔵")
            try await loadData()
            print("Initialize Data task finished! ✅")
        } catch {
            print("Initialize Data task cancelled! 🔴")
        }
    }
    
    func refreshData() async {
        refreshTask?.cancel()
        refreshTask = Task {
            do {
                print("Refresh started! 🔵")
                try await loadData()
                print("Refresh finished! ✅")
            } catch {
                print("Refresh cancelled! 🔴")
            }
        }
    }
    
    func loadData() async throws {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }

        try await Task.sleep(for: .seconds(5))
        try Task.checkCancellation()
        
        self.data = ["Item 1", "item 2", "A lizard 🦎", "A beer 🍺", "A cat 🐱"]
    }
    
    func cancelRefresh() {
        refreshTask?.cancel()
    }
}

#Preview {
    DetailView()
}

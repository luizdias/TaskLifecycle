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
        List(viewModel.data, id: \.self) { item in
            HStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text(item)
            }
        }
        .refreshable {
            await viewModel.refreshData()
        }
        .task {
            await viewModel.initializeData()
        }
    }
}

@Observable
class DetailViewModel {
    
    /* When we capture the async work in a Task property in the ViewModel,
    the DetailView's .task modifier no longer owns it,
    so navigation away from the view won't cancel it automatically */    
    private var currentTask: Task<Void, Never>? = nil
    var data: [String] = []
    
    func initializeData() async {
        currentTask = Task {
            do {
                print("Initialize Data task started! 🔵")
                try await loadData()
                print("Initialize Data task finished! ✅")
            } catch {
                print("Initialize Data task cancelled! 🔴")
            }
        }
    }
    
    func refreshData() async {
        currentTask?.cancel()
        currentTask = Task {
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
        try await Task.sleep(for: .seconds(5))
        if Task.isCancelled { return }
        await MainActor.run {
            self.data = ["Item 1", "item 2", "A lizard 🦎", "A beer 🍺", "A cat 🐱"]
        }
    }
}

#Preview {
    DetailView()
}

//
//  ViewModel.swift
//  async-location-swift-example
//
//  Created by Igor Shelopaev on 26.11.24.
//

import Foundation

typealias Operation =  @Sendable () async throws -> Void

/// A view model that manages a cancellable asynchronous task.
final class TaskViewModel: ObservableObject {

    /// The currently running task.
    private var task: Task<(), Never>?

    deinit {
        // Clean up when the instance is deallocated.
        stop()
        print("deinit TaskViewModel")
    }

    /// Starts the asynchronous operation.
    ///
    /// - Parameter operation: A `@Sendable` escaping closure representing the asynchronous operation to execute.
    func start(operation: @escaping Operation) {
        task = Task {
            do {
                try await operation()
            } catch {
                stop()
            }
        }
    }

    /// Stops the currently running task by cancelling it and clearing the reference.
    func stop() {
        task?.cancel()
        task = nil
    }
}

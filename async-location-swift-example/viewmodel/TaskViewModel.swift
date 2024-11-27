//
//  ViewModel.swift
//  async-location-swift-example
//
//  Created by Igor Shelopaev on 26.11.24.
//

import Foundation


/// A view model that manages a cancellable asynchronous task.
@MainActor
final class TaskViewModel<V, E: Error>: ObservableObject {

    typealias Operation =  @Sendable () async throws -> V?
    
    typealias ErrorHandler = @Sendable (Error?) -> E?
    
    // MARK: - Public properties
    
    @Published private(set) var error : E?
    
    @Published private(set) var value : V?
    
    @Published var isActive = false
    
    // MARK: - Private properties
    
    private let errorHandler : ErrorHandler?
    
    /// The currently running task.
    private var task: Task<V?, Never>?
    
    // MARK: - Life circle
    
    init(errorHandler: ErrorHandler? = nil) {
        self.errorHandler = errorHandler
    }
    
    // MARK: - API

    /// Starts the asynchronous operation.
    ///
    /// - Parameter operation: A `@Sendable` escaping closure representing the asynchronous operation to execute.
    @MainActor
    public func start(operation: @escaping Operation) {
        clean()
        isActive = true
        
        task = Task {
            do {
                value = try await operation()
            } catch {
                handle(error)
            }
            
            cancel()
            
            return value
        }
    }
    
    public func clean(){
        error = nil
        value = nil
    }

    /// Stops the currently running task by cancelling it and clearing the reference.
    public func cancel() {

        isActive = false
        
        if let task{
            task.cancel()
        }

        task = nil
    }
    
    // MARK: - Private
    
    @MainActor
    private func handle(_ error: Error){
        if let error = errorHandler?(error){
            self.error = error
        }else if let error = error as? E{
            self.error = error
        }else{
            self.error = nil
        }
    }
}

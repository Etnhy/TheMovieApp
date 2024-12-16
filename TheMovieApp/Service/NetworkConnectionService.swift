//
//  NetworkConnectionService.swift
//  TheMovieApp
//
//  Created by evhn on 16.12.2024.
//

import Foundation
import Network

final class NetworkConnectionService {
    static let shared = NetworkConnectionService()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    private(set) var isConnected = false
    private(set) var isExpensive = false
    
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    @MainActor
    func monitorStart() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else {return}
            
            self.isConnected = path.status != .unsatisfied
            self.isExpensive = path.isExpensive
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}

//
//  Network.swift
//  Network
//

import Foundation

/// Collection of different network types
public final class Network {
    public class var `default`: ConnectionPool {
        return URLSession(configuration: URLSessionConfiguration())
    }
    
}

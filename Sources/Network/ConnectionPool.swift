//
//  ConnectionPool.swift
//  Network
//

import Foundation

/// Network request
public protocol Request {
    
    /// Request url addres
    var url: URL { get }
    
    var httpMethod: RequestHTTPMethod { get }
    
    var headers: RequestHeaders { get set }
    
    var data: Data? { get }
}

public typealias RequestHeaders = [String:String]

public enum RequestHTTPMethod {
    case get
    case post
}

extension RequestHTTPMethod: Hashable, CustomStringConvertible {
    public var description: String {
        switch self {
        case .get:      return "GET"
        case .post:     return "POST"
        }
    }
}

//MARK: Response

/// Network response
public protocol Response {
    
}

public protocol ConnectionPool {
//    func task(url: URL, completionHandler: (Data?, URLResponse?, Error?) -> Void ) -> Connection
    func task(url: URL, completionHandler: (Data?, Response?, Error?) -> Void ) -> Connection
    func task(request: Request, completionHandler: (Data?, Response?, Error?) -> Void ) -> Connection
}

public protocol Connection {
    
}

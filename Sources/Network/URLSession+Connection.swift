//
//  URLSession+Connection.swift
//  PerfectLib
//

import Foundation

extension URLSession: ConnectionPool {
    
    public func task(url: URL, completionHandler: (Data?, Response?, Error?) -> Void ) -> Connection {
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        return dataTask(with: request, completionHandler: { (data, response, error) in
            
        })
    }
    
    public func task(request: Request, completionHandler: (Data?, Response?, Error?) -> Void ) -> Connection {
        var urlRequest = URLRequest(url: request.url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        urlRequest.httpMethod = request.httpMethod.description
        return dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            
        })
    }
}

extension URLResponse: Response {
    
}

extension URLSessionTask: Connection {
    
}

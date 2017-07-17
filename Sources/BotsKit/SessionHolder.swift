//
//  SessionHolder.swift
//  BotsKit
//

public protocol SessionHolder {
    associatedtype Session
    
    var session: Session? { get }
    
}

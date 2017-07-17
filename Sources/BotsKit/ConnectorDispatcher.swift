//
//  ConnectorDispatcher.swift
//  BotsKit
//

import LoggerAPI
import Dispatch

/*
 ---------------------
 |      Provider     |
 ---------------------
 ||                ^
 || Activity       | Message to chat provider
 \/                |
 ---------------------
 |     Dispatcher    |
 ---------------------
 ||                /\
 || Activity       || Replay
 \/                ||
 ----------------  ||
 |   Bot Impl   |===/
 ----------------
 |   Storage    |
 ----------------
 */

internal final class BotConnector {
    
    let provider: Provider
    
    let bot: Bot
    
    /// Dispatch queue to process messages from providers
    let queue: DispatchQueue
    
    init(bot: Bot, provider: Provider) {
        self.bot = bot
        self.provider = provider
        // Run all requests cuncurrent
        queue = DispatchQueue(label: "Dispatch \(bot.name) - \(provider.name)", attributes: .concurrent)
        
        // Subscribe on signals
        
        // For many providers we need to answer ASAP with HTTP response, so for
        // this need to schedule processing on other queue
        self.provider.recieveActivity.subscribe{ [unowned self] activity in
            self.dispatch {
                self.bot.dispatch(activity: activity)
            }
        }
        
        // Dispatch output activity to provider
        // This method can be run concurrently inside outcome group
        self.bot.sendActivity.subscribe{ [unowned self] activity in
            self.dispatch {
                self.provider.send(activity: activity)
            }
        }
    }
    
    /// Dispatch block on connector queue
    /// For now we run each block when set them, but in future this method will be more smart to descide
    /// how to run blocks
    ///
    /// - Parameter activityBlock: block to execute
    internal func dispatch(_ activityBlock: @escaping () -> Void) {
        queue.async {
            activityBlock()
        }
    }
    
}

public final class ConnectorDispatcher {
    var connectors: [BotConnector]
    
    public init() {
        connectors = []
    }
    
    public func register(bot: Bot, `in` provider: Provider) {
        let connector = BotConnector(bot: bot, provider: provider)
        Log.verbose("Connect \(bot.name) to \(provider.name) provider")
        connectors.append(connector)
    }
}

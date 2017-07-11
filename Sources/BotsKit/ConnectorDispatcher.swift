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
        self.provider.recieveActivity.subscribe{ [unowned self] activity in
            self.dispatch(incomeActivity: activity)
        }
        self.bot.sendActivity.subscribe{ [unowned self] activity in
            self.provider.send(activity: activity)
        }
    }
    
    /// For many providers we need to answer ASAP with HTTP response, so for
    /// this need to schedule processing on other queue
    ///
    /// - Parameter activity: income activity
    internal func dispatch(incomeActivity activity: Activity) {
        queue.async {
            self.bot.dispatch(activity: activity)
        }
    }
    
    /// Dispatch output activity to provider
    /// This method can be run concurrently inside outcome group
    ///
    /// - Parameter activity: activity to send
    internal func dispatch(outcomeActivity activity: Activity) {
        queue.async {
            self.provider.send(activity: activity)
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

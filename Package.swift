import PackageDescription

let package = Package(  
	name: "SwiftBot",  
	targets: [
        Target(
            name:"Mapper",
            dependencies:[]),
        Target(
            name:"Network",
            dependencies:[]),
        Target(
            name:"Storage",
            dependencies:[]),

        Target(
            name:"BotsKit",
            dependencies:[]),
        Target(
            name:"ReplyService",
            dependencies:["BotsKit"]),
        Target(
            name:"Facebook",
            dependencies:["Mapper", "BotsKit", "ReplyService"]),
        Target(
            name: "EchoBot",
            dependencies:["BotsKit"]),
        Target(
            name:"SwiftBot",
            dependencies:["Facebook","Storage","EchoBot"])
    ],  
	dependencies: [
		.Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2),
		.Package(url: "https://github.com/PerfectlySoft/Perfect-CURL.git", majorVersion: 2),
		.Package(url: "https://github.com/PerfectlySoft/Perfect-MySQL.git", majorVersion: 2),
        .Package(url: "https://github.com/IBM-Swift/Health.git", majorVersion: 0),
        // Common
        .Package(url: "https://github.com/IBM-Swift/HeliumLogger.git", majorVersion: 1)
    ],
  exclude:["Scripts"]       
)

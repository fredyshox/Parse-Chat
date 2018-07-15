# Parse-Chat 
 Simple chat application for iOS demonstrating use of Parse Server with ParseLiveQueries. 
 
 It's written using Swift 4 and Xcode 9 and tested on iOS 10.3+.

 ## Libraries 
 * Parse 
 * ParseLiveQuery
 * JSQMessagesViewController 
 
 ## How to run
 Firstly install required libraries using Cocoapods.
 Then setup the app, by providing required client configuration properties for use with your Parse server in [AppDelegate](./ParseChat/AppDelegate.swift).
 
```swift
// inside applicationDidFinishLaunchingWithOptions method...

// CLIENT CONFIGURATION
// Configure server connection
let configuration = ParseClientConfiguration { (config) in
  config.applicationId = "test123"
  config.clientKey = "yourkey"
  config.server = "http://yourserver.url"
}
```

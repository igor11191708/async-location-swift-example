# Async/await location streamer for iOS, watchOS using new concurrency model in Swift

 ## Features
- [x] Using new concurrency swift model around CoreLocation manager
- [x] Customizable in terms of passing a preconfigured CLLocationManager
- [x] Customizable in terms of CLLocationManager properties
- [x] Streaming current location asynchronously
- [x] Different strategies - Keep and publish all stack of locations since streaming has started or the last one
- [x] Support for iOS from 14.1 and watchOS from 7.0
- [x] Errors handling (as **AsyncLocationErrors** so CoreLocation errors **CLError**)

## SwiftUI example for package

[Async location streamer](https://github.com/swiftuiux/swift-async-corelocation-streamer)

 ![simulate locations](https://github.com/The-Igor/d3-async-location/blob/main/img/image11.gif)

# BackgroundKeepAlive

### Version

iOS 7.0+

### Capability

Follow below steps to make your app has background modes capability:
1. Select the project from the Project navigator.
2. Click the app target.
3. Select the Capabilities tab.
4. Turn the Background Modes switch on.
5. Check the `Audio, AirPlay, and Picture in Picture` checkbox.

## Installation

BackgroundKeepAlive is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BackgroundKeepAlive'
```

## Usage
```Objective-C
    [[KeepAliveManager sharedInstance] setEnabled:YES];
```
## License

BackgroundKeepAlive is available under the MIT license. See the LICENSE file for more info.

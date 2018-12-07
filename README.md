# RouterStateMachine

[![CircleCI](https://circleci.com/gh/aldo-dev/mfind.svg?style=svg)](https://circleci.com/gh/aldo-dev/RouterStateMachine)
[![Version](https://img.shields.io/cocoapods/v/EZSource.svg?style=flat)](https://cocoapods.org/pods/RouterStateMachine)
[![License](https://img.shields.io/cocoapods/l/EZSource.svg?style=flat)](https://cocoapods.org/pods/RouterStateMachine)
[![Platform](https://img.shields.io/cocoapods/p/EZSource.svg?style=flat)](https://cocoapods.org/pods/RouterStateMachine)

## Description
The framework provides 2 different state machines `SimpleStateMachine` and `SyncronizedStateMachine`. The second provides logic for blocking state changing until it's finilized

## Usage
- Create road map provider. The class that will tell what transitions are allowed
``` swift 
final class MockStateProvider: StateProvider {
typealias T = MockState

  func canMove(fromState state: MockState, toState to: MockState) -> Bool {
    switch (state, to) {
      case (.one, .two),
      (.two, .three),
      (.two, .one),
      (.three,. two): return true
      default: return false
    }
  }

}
```

- Create Delegate proxy to listen when a change / error happens. Here in the example the delegate proxy is wrapped into separate class. However it cab be anyclass that responsible to do action based on state change. For example Router that is responsible for Navigation
```swift
final class DelegateProxyTester {
  var proxy: StateMachineDelegateProxy<MockState> {
  let proxy = StateMachineDelegateProxy<MockState>()
  proxy.willMoveCallback = self.willMove
  proxy.errorMoving = self.errorMoving
  return proxy
}

  func willMove(from state: MockState, toState to: MockState) {
  //do the logic based on state change
  }

  func errorMoving(from state: MockState, toState to: MockState) {
    //process the error
  }
}
```

- Connect the parts 
```swift
mockProvider = MockStateProvider()
proxyTester = DelegateProxyTester()
machineToTest = SimpleStateMachine(initialState: .one, roadMapProvider: mockProvider)
machineToTest.delegateProxy = proxyTester.proxy
```

### Syncronized Machine 
It behaves more like a decorator on top of `SimpleStateMachine` that handles logic for preventing state change until it's allowed. Consider it's like using semaphore inside.
To use it follow the step above with the difference that you need to provide different proxy

```swift
final class SyncDelegateProxyTester {

  var proxy: SyncronizedMachineDelegateProxy<MockState> {
    let proxy = SyncronizedMachineDelegateProxy<MockState>()
    proxy.syncWillMove = willMove
    proxy.errorMoving = errorMoving
    return proxy
  }

  func willMove(from state: MockState, toState to: MockState, completion: @escaping () -> Void) {
  //do the logic and when it's finished call completion
  }

  func errorMoving(from state: MockState, toState to: MockState) {
    // process the error if need
    }
}
```

## Installation

RouterStateMachine is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RouterStateMachine'
```

## Author

ALDO Inc., aldodev@adogroup.com

## License

RouterStateMachine is available under the MIT license. See the LICENSE file for more info.

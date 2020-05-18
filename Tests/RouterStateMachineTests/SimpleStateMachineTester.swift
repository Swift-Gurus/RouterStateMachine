//
//  SimpleStateMachineTester.swift
//  RouterStateMachine_Tests
//
//  Created by Alex Hmelevski on 2018-07-22.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import XCTest

@testable import RouterStateMachine

enum MockState: String, State {
    var uniqueID: String { return rawValue }
    case one
    case two
    case three
}


final class DelegateProxyTester {
    
    private(set) var fromStates: [MockState] = []
    private(set) var toStates: [MockState] = []
    
    private(set) var errorFromStates: [MockState] = []
    private(set) var errorToStates: [MockState] = []
    
    var proxy: StateMachineDelegateProxy<MockState> {
        let proxy = StateMachineDelegateProxy<MockState>()
        proxy.willMoveCallback = self.willMove
        proxy.errorMoving = self.errorMoving
        return proxy
    }
    
    func willMove(from state: MockState, toState to: MockState) {
        fromStates.append(state)
        toStates.append(to)
    }
    
    func errorMoving(from state: MockState, toState to: MockState) {
        errorFromStates.append(state)
        errorToStates.append(to)
    }
}


final class SimpleStateMachineTester {
    var mockProvider = MockStateProvider()
    var machineToTest: SimpleStateMachine<MockStateProvider>
    var proxyTester = DelegateProxyTester()
    
    init() {
        mockProvider = MockStateProvider()
        proxyTester = DelegateProxyTester()
        machineToTest = SimpleStateMachine(initialState: .one, roadMapProvider: mockProvider)
        machineToTest.delegateProxy = proxyTester.proxy
    }
    
    func pushState(_ state: MockState) {
        machineToTest.pushState(state)
    }
    
    func popLastState() {
        machineToTest.popLastState()
    }
    
    func checkProviderWasCalledToMove(toStates states: [MockState],
                                      file: StaticString = #file,
                                      line: UInt = #line) {
        XCTAssertEqual(mockProvider.toStates, states,file: file, line: line)
    }
    
    func checkDelegateProxyWasCalledToMove(toStates states: [MockState],
                                           file: StaticString = #file,
                                           line: UInt = #line) {
        
        XCTAssertEqual(proxyTester.toStates, states, file: file, line: line)
    }
    
    
    func checkDelegateProxyWasCalledErrorMoving(toStates states: [MockState],
                                                file: StaticString = #file,
                                                line: UInt = #line) {
        
        XCTAssertEqual(proxyTester.errorToStates, states, file: file, line: line)
    }
}

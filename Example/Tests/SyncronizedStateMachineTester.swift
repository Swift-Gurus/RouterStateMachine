//
//  SyncronizedStateMachineTester.swift
//  RouterStateMachine_Example
//
//  Created by Alex Hmelevski on 2018-07-22.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
@testable import RouterStateMachine

final class SyncronizedStateMachineTester {
    
    var machineToTest:  SyncronizedStateMachine<MockStateProvider>
    var mockProvider: MockStateProvider
    var mockDelegateProxy: SyncDelegateProxyTester

    init() {
        mockProvider = MockStateProvider()
        mockDelegateProxy = SyncDelegateProxyTester()
        machineToTest = SyncronizedStateMachine(initialState: .one, roadMapProvider: mockProvider)
        machineToTest.delegateProxy = mockDelegateProxy.proxy
    }
    
    
    func pushState(_ state: MockState) {
        machineToTest.pushState(state)
    }
    
    func popToLast() {
        machineToTest.popLastState()
    }
    
    func callCompletion() {
        mockDelegateProxy.completion?()
    }
    
    func checkProviderWillMoveToStateCalled(toStates: [MockState],
                                            file: StaticString = #file,
                                            line: UInt = #line) {
        XCTAssertEqual(mockProvider.toStates, toStates, file: file, line: line)
    }
    
    func checkDelegateProxyWillMoveToStateCalled(toStates: [MockState],
                                                 file: StaticString = #file,
                                                 line: UInt = #line) {
        XCTAssertEqual(mockDelegateProxy.toStates, toStates, file: file, line: line)
    }
    
    func checkDelegateProxyErrorMoving(toStates: [MockState],
                                       file: StaticString = #file,
                                       line: UInt = #line) {
         XCTAssertEqual(mockDelegateProxy.errorToStates, toStates, file: file, line: line)
    }
}

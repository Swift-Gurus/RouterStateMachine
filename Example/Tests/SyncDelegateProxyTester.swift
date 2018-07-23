//
//  SyncDelegateProxyTester.swift
//  RouterStateMachine_Tests
//
//  Created by Alex Hmelevski on 2018-07-22.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
@testable import RouterStateMachine

final class SyncDelegateProxyTester {
    
    private(set) var fromStates: [MockState] = []
    private(set) var toStates: [MockState] = []
    
    private(set) var errorFromStates: [MockState] = []
    private(set) var errorToStates: [MockState] = []
    
    var completion: (() -> Void)?
    
    var proxy: SyncronizedMachineDelegateProxy<MockState> {
        let proxy = SyncronizedMachineDelegateProxy<MockState>()
        proxy.syncWillMove = willMove
        proxy.errorMoving = errorMoving
        return proxy
    }
    
    func willMove(from state: MockState, toState to: MockState, completion: @escaping () -> Void) {
        self.completion = completion
        fromStates.append(state)
        toStates.append(to)
    }
    
    func errorMoving(from state: MockState, toState to: MockState) {
        errorFromStates.append(state)
        errorToStates.append(to)
    }
}

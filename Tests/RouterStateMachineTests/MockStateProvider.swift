//
//  MockStateProvider.swift
//  RouterStateMachine_Tests
//
//  Created by Alex Hmelevski on 2018-07-22.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
@testable import RouterStateMachine

final class MockStateProvider: StateProvider {
    typealias T = MockState
    
    private(set) var fromStates: [MockState] = []
    private(set) var toStates: [MockState] = []
    
    func canMove(fromState state: MockState, toState to: MockState) -> Bool {
        fromStates.append(state)
        toStates.append(to)
        switch (state, to) {
        case (.one, .two),
             (.two, .three),
             (.two, .one),
             (.three,. two): return true
        default: return false
        }
    }
    
}

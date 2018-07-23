//
//  SimpleStateMachineTestCases.swift
//  RouterStateMachine_Tests
//
//  Created by Alex Hmelevski on 2018-07-22.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
@testable import RouterStateMachine

class SimpleStateMachineTestCases: XCTestCase {
    
    
    var tester: SimpleStateMachineTester!
    override func setUp() {
        super.setUp()
        tester = SimpleStateMachineTester()
    }
   
    func test_push_allowed_state() {
        tester.pushState(.two)
        tester.checkProviderWasCalledToMove(toStates: [.two])
        tester.checkDelegateProxyWasCalledToMove(toStates: [.two])
    }
    
}

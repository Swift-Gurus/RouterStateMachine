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
        tester.checkDelegateProxyWasCalledErrorMoving(toStates: [])
    }
    
    func test_push_unallowed_state() {
        tester.pushState(.three)
        tester.checkProviderWasCalledToMove(toStates: [.three])
        tester.checkDelegateProxyWasCalledToMove(toStates: [])
        tester.checkDelegateProxyWasCalledErrorMoving(toStates: [.three])
    }
    
    func test_pop_last_state() {
        tester.pushState(.two)
        tester.popLastState()
        tester.checkProviderWasCalledToMove(toStates: [.two,.one])
        tester.checkDelegateProxyWasCalledToMove(toStates: [.two,.one])
        tester.checkDelegateProxyWasCalledErrorMoving(toStates: [])
    }
    
}

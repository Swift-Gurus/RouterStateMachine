//
//  SyncronizedStateMachineTestCases.swift
//  RouterStateMachine_Tests
//
//  Created by Alex Hmelevski on 2018-07-22.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest

class SyncronizedStateMachineTestCases: XCTestCase {
    
    var tester = SyncronizedStateMachineTester()
    override func setUp() {
        super.setUp()
        tester = SyncronizedStateMachineTester()
    }
   
    func test_push_to_state() {
        tester.pushState(.two)
        tester.callCompletion()
        tester.checkDelegateProxyErrorMoving(toStates: [])
        tester.checkProviderWillMoveToStateCalled(toStates: [.two])
        tester.checkDelegateProxyWillMoveToStateCalled(toStates: [.two])
    }
    
    func test_push_to_state_prevents_second_if_completion_is_not_called() {
        tester.pushState(.two)
        tester.pushState(.three)
        tester.checkDelegateProxyErrorMoving(toStates: [])
        tester.checkProviderWillMoveToStateCalled(toStates: [.two])
        tester.checkDelegateProxyWillMoveToStateCalled(toStates: [.two])
    }
    
    func test_push_to_state_pushes_second_after_completion_is_called() {
        tester.pushState(.two)
        tester.pushState(.three)
        tester.callCompletion()
        tester.checkDelegateProxyErrorMoving(toStates: [])
        tester.checkProviderWillMoveToStateCalled(toStates: [.two, .three])
        tester.checkDelegateProxyWillMoveToStateCalled(toStates: [.two,.three])
    }
    
    
    func test_if_completion_is_not_called_should_prevent_from_poping() {
        tester.pushState(.two)
        tester.popToLast()
        tester.checkDelegateProxyErrorMoving(toStates: [])
        tester.checkProviderWillMoveToStateCalled(toStates: [.two,])
        tester.checkDelegateProxyWillMoveToStateCalled(toStates: [.two,])
    }
    
    func test_if_after_completion_pops_last_state() {
        tester.pushState(.two)
        tester.popToLast()
        tester.callCompletion()
        tester.checkDelegateProxyErrorMoving(toStates: [])
        tester.checkProviderWillMoveToStateCalled(toStates: [.two,.one])
        tester.checkDelegateProxyWillMoveToStateCalled(toStates: [.two,.one])
    }
    
    func test_error_flow() {
        tester.pushState(.two)
        tester.pushState(.two)
        tester.callCompletion()
        tester.checkDelegateProxyErrorMoving(toStates: [.two])
        tester.checkProviderWillMoveToStateCalled(toStates: [.two,.two])
        tester.checkDelegateProxyWillMoveToStateCalled(toStates: [.two])
    }
}

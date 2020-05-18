//
//  SimpleStateMachine.swift
//  RouterStateMachine
//
//  Created by Alex Hmelevski on 2018-07-22.
//

import Foundation
import SwiftyCollection

public protocol State {
    var uniqueID: String { get }
}

public protocol StateMachine {
    associatedtype T where T: State
    func pushState(_ state: T)
    func popLastState()
}

public protocol StateProvider {
    associatedtype T where T: State
    func canMove(fromState state: T, toState to: T) -> Bool
}


public final class StateMachineDelegateProxy<T> {
    public var willMoveCallback: StateMachineWillMoveCallback<T>?
    public var errorMoving: StateMachineWillMoveCallback<T>?
    
    public init(willMoveCallback: StateMachineWillMoveCallback<T>? = nil,
                errorMoving: StateMachineWillMoveCallback<T>? = nil) {
        self.willMoveCallback = willMoveCallback
        self.errorMoving = errorMoving
    }
}

public typealias StateMachineWillMoveCallback<T> = (_ toState: T, _ fromState: T) -> Void

public class SimpleStateMachine<Provider: StateProvider>: StateMachine {
    public typealias T = Provider.T
    public var delegateProxy: StateMachineDelegateProxy<T>?
    
    private let roadMapProvider: Provider
    private var states: [T] = []
    private let initialState: T
    
    public init(initialState: T,
         roadMapProvider: Provider) {
        self.initialState = initialState
        self.roadMapProvider = roadMapProvider
    }
    
    public func pushState(_ state: T) {
        let last = self.states.last ?? self.initialState
        if self.canPush(state) {
            self.addState(state)
            self.willMove(fromState: last, toState: state)
        } else {
            self.errorMoving(fromState: last, toState: state)
        }
    }
    
    public func popLastState() {
        let last = self.states.reversed().element(at: 0) ?? self.initialState
        let previous = self.states.reversed().element(at: 1) ?? self.initialState
        if self.roadMapProvider.canMove(fromState: last, toState: previous) {
            self.removeLastState()
            self.willMove(fromState: last, toState: previous)
        } else {
            self.errorMoving(fromState: last, toState: previous)
        }
    }
    
    private func addState(_ state: T) {
        states.append(state)
    }
    
    private func removeLastState() {
        states.removeLastSafe()
    }
    
    private func canPush(_ state: T) -> Bool {
        return roadMapProvider.canMove(fromState: states.last ?? initialState, toState: state)
    }
    
    func willMove(fromState state: T,
                  toState to: T) {
        delegateProxy?.willMoveCallback?(state, to)
    }
    
    func errorMoving(fromState state: T, toState to: T) {
        delegateProxy?.errorMoving?(state, to)
    }
}

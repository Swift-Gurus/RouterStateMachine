//
//  SyncronizedStateMachine.swift
//  RouterStateMachine
//
//  Created by Alex Hmelevski on 2018-07-22.
//

import Foundation

public final class SyncronizedMachineDelegateProxy<T> {
    public var syncWillMove: SyncronizedWillMove<T>?
    public var errorMoving: StateMachineWillMoveCallback<T>?
    
    public init(syncWillMove: SyncronizedWillMove<T>? = nil,
                errorMoving: StateMachineWillMoveCallback<T>? = nil) {
        self.syncWillMove = syncWillMove
        self.errorMoving = errorMoving
    }
}

public typealias SyncronizedWillMove<T> = (_ toState: T, _ fromState: T, _ completion: @escaping () -> Void) -> Void

public final class  SyncronizedStateMachine<Provider: StateProvider>: StateMachine {
    public typealias T = Provider.T
    public var delegateProxy: SyncronizedMachineDelegateProxy<T>?
    private let simpleStateMachine: SimpleStateMachine<Provider>
    
    private var shouldWait = false
    private var blockedNewStates: [() -> Void] = []
    
   public  init(initialState: T, roadMapProvider: Provider) {
        simpleStateMachine =  SimpleStateMachine<Provider>.init(initialState: initialState, roadMapProvider: roadMapProvider)
        let proxy = StateMachineDelegateProxy<T>()
        proxy.willMoveCallback = { [weak self] in self?.willMove(from: $0, to: $1) }
        proxy.errorMoving = { [weak self] in self?.errorMoving(from: $0, to: $1)}
        simpleStateMachine.delegateProxy = proxy
    }
    
    public func pushState(_ state: Provider.T) {
        processStateChange { [weak self] in
            self?.simpleStateMachine.pushState(state)
        }
    }
    
    public func popLastState() {
        processStateChange { [weak self] in
            self?.simpleStateMachine.popLastState()
        }
    }
    
    func willMove(from: T, to: T) {
        delegateProxy?.syncWillMove?(from,to, { [weak self] in
            self?.shouldWait = false
            self?.processNextBlockedStates()
        })
    }
    
    func errorMoving(from: T, to: T) {
        shouldWait = false
        delegateProxy?.errorMoving?(from, to)
        processNextBlockedStates()
    }
    
    func processStateChange(_ stateChange: @escaping () -> Void) {
        if shouldWait {
            blockedNewStates.append(stateChange)
        } else {
            shouldWait = true
            stateChange()
        }
    }
    
    
    private func processNextBlockedStates() {
        blockedNewStates.removeLastSafe()?()
    }
}

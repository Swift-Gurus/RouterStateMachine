//
//  RouterTemplate.swift
//  Pods-RouterStateMachine_Example
//
//  Created by Alex Hmelevski on 2019-04-26.
//

import Foundation

open class RouterTemplate<Provider: StateProvider> {
    
    public typealias RouterState = Provider.T
    private var stateMachine: SyncronizedStateMachine<Provider>
    
    public init(initialState: RouterState,
         roadMapProvider: Provider) {
        
        self.stateMachine = SyncronizedStateMachine(initialState: initialState,
                                                    roadMapProvider: roadMapProvider)
        
        let proxy = SyncronizedMachineDelegateProxy<RouterState>()
        proxy.syncWillMove = { [weak self] in self?.willMove(from: $0, to: $1, with: $2) }
        proxy.errorMoving = { [weak self] in self?.errorMoving(from: $0, to: $1) }
        stateMachine.delegateProxy = proxy
    }
    
    open func willMove(from: RouterState,
                  to nextState: RouterState,
                  with completion: @escaping () -> Void) {
        fatalError("Subclasses should implement")
    }
    
    open func errorMoving(from: RouterState, to nextState: RouterState) {
        
    }
    
    open func pushState(_ state: RouterState) {
        stateMachine.pushState(state)
    }
    
    open func popLastState() {
        stateMachine.popLastState()
    }
}

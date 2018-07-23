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
}

public typealias StateMachineWillMoveCallback<T> = (_ toState: T, _ fromState: T) -> Void

public class SimpleStateMachine<Provider: StateProvider>: StateMachine {
    public typealias T = Provider.T
    fileprivate let roadMapProvider: Provider
    private var states: [T] = []
    fileprivate let initialState: T
    public var delegateProxy: StateMachineDelegateProxy<T>?
    
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
        debugPrint("\(Date()) Cannot move from state: \(state) to state \(to) on main: \(Thread.isMainThread)")
    }
}


//
//enum ComplexState: State {
//    var uniqueID: String {
//        switch self {
//        case .initial: return "initial"
//        case .userInfo: return "userInfo"
//        case .userLogIn: return "userLogIn"
//        }
//    }
//
//    case initial
//    case userInfo(String)
//    case userLogIn(String, String)
//}
//
//
//struct ComplexStateProvider: StateProvider {
//    typealias T = ComplexState
//    func canMove(fromState state: ComplexState, toState to: ComplexState) -> Bool {
//        switch (state,to) {
//        case (.initial,.userInfo),
//             (.userInfo,.initial),
//             (.userInfo,.userLogIn),
//             (.userLogIn,.userInfo): return true
//        default: return false
//        }
//    }
//}
//
//
//
//class Router {
//
//    let machine = SyncronizedStateMachine(initialState: .initial, roadMapProvider: ComplexStateProvider())
//
//
//
//    init() {
//        let proxy = SyncronizedMachineDelegateProxy<ComplexState>()
//        proxy.syncWillMove = { [weak self] in self?.willMove(fromState: $0, toState: $1, completion: $2) }
//        machine.delegateProxy = proxy
//
//    }
//
//    func willMove(fromState state: ComplexState,
//                  toState to: ComplexState,
//                  completion: @escaping () -> Void) {
//        switch (state, to) {
//        case (.initial, .userInfo),
//             (.userInfo, .initial),
//             (.userInfo, .userLogIn),
//             (.userLogIn, .userInfo):
//            completion()
//            debugPrint("\(Date()) Moved from \(state) to \(to) on main: \(Thread.isMainThread)")
//        default: break
//        }
//    }
//
//    func moveToUserInfo() {
//        machine.pushState(.userInfo("USER"))
//    }
//
//    func movetToLogIn() {
//        machine.pushState(.userLogIn("USER", "PSWD"))
//    }
//
//    func pop() {
//        machine.popLastState()
//    }
//}

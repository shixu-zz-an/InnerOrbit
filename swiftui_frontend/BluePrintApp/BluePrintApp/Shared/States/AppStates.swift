import Foundation

enum ViewState<Value> {
    case idle
    case loading
    case empty(String)
    case loaded(Value)
    case failed(String)
}

struct ToastMessage: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let message: String
}


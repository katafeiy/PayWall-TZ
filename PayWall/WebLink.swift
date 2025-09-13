enum WebLink: Int {
    
    case terms = 1
    case privacy
    case subscriptionPolicy
    
    var url: String {
        switch self {
        case .terms: "https://developer.apple.com/documentation/UIKit"
        case .privacy: "https://developer.apple.com/documentation/SwiftUI"
        case .subscriptionPolicy: "https://developer.apple.com/documentation/SwiftData"
        }
    }
    var title: String {
        switch self {
        case .terms: "Terms"
        case .privacy: "Privacy"
        case .subscriptionPolicy: "Subscription Policy"
        }
    }
}

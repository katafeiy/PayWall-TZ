import UIKit

final class PayWallPresenter {
    
    weak var view: PayWallViewProtocol?

    private let price = "$5.99/week"
    private var checkedStates: [Bool] = Array(repeating: true, count: 5)

    let tableItems = [
        ["No limits", "Tap as much as you want"],
        ["Place multiple tap points on any screen"],
        ["Save setups and load them instantly"],
        ["Fast & accurate", "Works even on tricky buttons"],
        ["Use it anywhere", "Games, apps, or web tools"]
    ]

    init(view: PayWallViewProtocol? = nil) {
        self.view = view
    }

    func handleContinue() { print("Continue") }
    func handleClose() { view?.close() }
    func handleSwitch(isOn: Bool) {
        view?.updateSwitchState(isOn: isOn)
        view?.updateContinueButton(title: isOn ? "Start Free Trial" : "Continue")
    }
    func handleCheckbox(at index: Int) { checkedStates[index].toggle(); view?.updateTable() }
    func isChecked(at index: Int) -> Bool { checkedStates[index] }
    func handleOpenWeb(_ link: WebLink) { view?.showWebPage(url: link.url) }
    var payPrice: String { price }
}

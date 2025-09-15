import UIKit

struct WebViewData {
    let urlString: String
    let navigationTitle: String
}

final class WebViewPresenter: NSObject {
    
    weak var view: WebViewProtocol?
    var model: WebViewData!
    
    func setupView() {
        view?.setupUI()
        view?.loadPage(urlString: model.urlString)
    }
    
    func closeTapped() {
        view?.dismiss()
    }
    
    init(model: WebViewData!) {
        self.model = model
    }
}

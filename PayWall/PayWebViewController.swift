import UIKit
import WebKit

protocol WebViewProtocol: AnyObject {
    func setupUI()
    func loadPage(urlString: String)
    func dismiss()
}

final class WebViewController: UIViewController, WebViewProtocol {
    
    private var presenter: WebViewPresenter!
    
    private lazy var navBar: UINavigationBar = {
        let navBar = UINavigationBar()
        return navBar
    }()
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    
    init(presenter: WebViewPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        let navBar = UINavigationBar()
        let navItem = UINavigationItem(title: presenter.model.navigationTitle)
        navItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeTapped)
        )
        navBar.setItems([navItem], animated: false)
        
        view.addSubviews(navBar, webView)
        
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            webView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func loadPage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setupView()
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
    
    @objc private func closeTapped() {
            presenter.closeTapped()
    }
}

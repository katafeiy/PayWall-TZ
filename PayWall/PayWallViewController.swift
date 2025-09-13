import UIKit
import SwiftUI

protocol PayWallViewProtocol: AnyObject {
    func updateSwitchState(isOn: Bool)
    func updateTable()
    func updateContinueButton(title: String)
    func showWebPage(url: String)
    func close()
}

final class PayWallViewController: UIViewController, PayWallViewProtocol {
    
    private let presenter: PayWallPresenter
    
    private var checkedStates: [Bool] = []
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 19, weight: .bold)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        button.tintColor = .mainGray
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return button
    }()
    
    private lazy var handPointImage: UIImageView = {
        let imageView = UIImageView(image: UIImage.handPoint)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private lazy var payWallLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "Unlock Full Control with AutoClicker Pro"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .mainWhite
        return label
    }()
    
    private lazy var tapLess: UILabel = PayWallViewController.makeOptionLabel(title: "Tap Less.")
    private lazy var winMore: UILabel = PayWallViewController.makeOptionLabel(title: "Win more.")
    private lazy var automateAnything: UILabel = PayWallViewController.makeOptionLabel(title: "Automate anything.")
    
    private lazy var stackViewLabel: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [tapLess, winMore, automateAnything])
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.distribution = .fillProportionally
        stackView.spacing = 14.5
        return stackView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PayWallCell.self, forCellReuseIdentifier: PayWallCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private lazy var payView: UIView = {
        let view = UIView()
        view.backgroundColor = .buttonGray
        view.layer.cornerRadius = 36
        return view
    }()
    
    private lazy var paySwitch: UISwitch = {
        let switchView = UISwitch()
        switchView.onTintColor = .mainYellow
        switchView.backgroundColor = .mainGray
        switchView.addTarget(self, action: #selector(handleSwitch(_:)), for: .valueChanged)
        return switchView
    }()
    
    private lazy var payLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainWhite
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .left
        label.text = presenter.payPrice
        return label
    }()
    
    private lazy var trialLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainYellow
        label.font = UIFont.systemFont(ofSize: 11)
        label.textAlignment = .left
        label.text = "Start with 3-Day Free Trial"
        label.isHidden = true
        return label
    }()
    
    private lazy var cancelLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainGray
        label.font = UIFont.systemFont(ofSize: 11)
        label.textAlignment = .left
        label.text = "Cancel anytime"
        return label
    }()
    
    private lazy var payStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [payLabel, trialLabel, cancelLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .mainYellow
        button.layer.cornerRadius = 36
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        return button
    }()
    
    private lazy var terms: UIButton = PayWallViewController.makeFooterButton(title: "Terms", tag: WebLink.terms.rawValue, target: self)
    private lazy var privacy: UIButton = PayWallViewController.makeFooterButton(title: "Privacy", tag: WebLink.privacy.rawValue, target: self)
    private lazy var subscriptionPolicy: UIButton = PayWallViewController.makeFooterButton(title: "Subscription Policy", tag: WebLink.subscriptionPolicy.rawValue, target: self)
    
    private lazy var stackViewFooter: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [terms, privacy, subscriptionPolicy])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 30
        return stackView
    }()
    
    init(presenter: PayWallPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.view = self
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupGradientBackground()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateSwitchState(isOn: paySwitch.isOn)
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        }
    }

    @objc private func handleContinue() { presenter.handleContinue() }
    @objc private func handleClose() { presenter.handleClose() }
    @objc private func handleSwitch(_ sender: UISwitch) { presenter.handleSwitch(isOn: sender.isOn) }
    
    @objc private func openWebView(_ sender: UIButton) {
        if let link = WebLink(rawValue: sender.tag) {
            presenter.handleOpenWeb(link)
        }
    }
 
    func updateSwitchState(isOn: Bool) {
        paySwitch.thumbTintColor = isOn ? .bg : .mainWhite
        paySwitch.backgroundColor = isOn ? nil : .mainGray
        paySwitch.layer.cornerRadius = isOn ? 0 : paySwitch.frame.height / 2
        trialLabel.isHidden = !isOn
    }
    
    func updateContinueButton(title: String) { continueButton.setTitle(title, for: .normal) }
    func updateTable() { tableView.reloadData() }
    func showWebPage(url: String) {
        let webVC = WebViewController(urlString: url)
        webVC.modalPresentationStyle = .fullScreen
        present(webVC, animated: true)
    }
    func close() { dismiss(animated: true) }
    
    private func setupUI() {
        view.addSubviews(closeButton, continueButton, handPointImage, payWallLabel, stackViewLabel, tableView, payView, stackViewFooter)
        payView.addSubviews(paySwitch, payStackView)
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            continueButton.heightAnchor.constraint(equalToConstant: 72),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            
            handPointImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            handPointImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 92),
            
            payWallLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            payWallLabel.topAnchor.constraint(equalTo: handPointImage.bottomAnchor, constant: 48),
            payWallLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 48),
            payWallLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -48),
            
            stackViewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackViewLabel.topAnchor.constraint(equalTo: payWallLabel.bottomAnchor, constant: 8),
            stackViewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
            stackViewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48),
            
            tableView.topAnchor.constraint(equalTo: stackViewLabel.bottomAnchor, constant: 32),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48),
            tableView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -32),
            
            payView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            payView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            payView.heightAnchor.constraint(equalToConstant: 72),
            payView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -16),
            
            paySwitch.trailingAnchor.constraint(equalTo: payView.trailingAnchor, constant: -16),
            paySwitch.topAnchor.constraint(equalTo: payView.topAnchor, constant: 20),
            paySwitch.bottomAnchor.constraint(equalTo: payView.bottomAnchor, constant: -20),
            paySwitch.heightAnchor.constraint(equalToConstant: 32),
            paySwitch.widthAnchor.constraint(equalToConstant: 52),
            
            payStackView.leadingAnchor.constraint(equalTo: payView.leadingAnchor, constant: 16),
            payStackView.trailingAnchor.constraint(equalTo: paySwitch.leadingAnchor, constant: -8),
            payStackView.centerYAnchor.constraint(equalTo: paySwitch.centerYAnchor),
            
            stackViewFooter.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 65),
            stackViewFooter.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -65),
            stackViewFooter.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 24),
            stackViewFooter.heightAnchor.constraint(equalToConstant: 18),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
            closeButton.widthAnchor.constraint(equalToConstant: 32),
            closeButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.bg.cgColor, UIColor.filling.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private static func makeOptionLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = .mainGray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }
    
    private static func makeFooterButton(title: String, tag: Int, target: Any) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.mainGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.tag = tag
        button.addTarget(target, action: #selector(PayWallViewController.openWebView(_:)), for: .touchUpInside)
        return button
    }
}

extension PayWallViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { presenter.tableItems.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PayWallCell.reuseIdentifier, for: indexPath) as? PayWallCell else { return UITableViewCell() }
        let item = presenter.tableItems[indexPath.row]
        let isChecked = presenter.isChecked(at: indexPath.row)
        if item.count == 2 { cell.configureWithTwoLines(title: item[0], subtitle: item[1], isChecked: isChecked) }
        else { cell.configureWithOneLine(text: item[0], isChecked: isChecked) }
        cell.onCheckboxTapped = { [weak self] _ in self?.presenter.handleCheckbox(at: indexPath.row) }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 25 }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.handleCheckbox(at: indexPath.row)
    }
}

extension UIView {
    func addSubviews(_ views: UIView...) { views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false; addSubview($0) } }
}

struct PayWallPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> PayWallViewController {
        let presenter = PayWallPresenter(view: nil)
        return PayWallViewController(presenter: presenter)
    }
    
    func updateUIViewController(_ uiViewController: PayWallViewController, context: Context) {}
}

#Preview {
    PayWallPreview()
        .ignoresSafeArea()
}

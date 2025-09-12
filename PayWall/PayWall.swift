import UIKit
import SwiftUI

class PayWall: UIViewController {
    
    let price: String = "$5.99/week"
    
    let tableItems = [
        ["No limits", "Tap as much as you want"],
        ["Place multiple tap points on any screen"],
        ["Save setups and load them instantly"],
        ["Fast & accurate", "Works even on tricky buttons"],
        ["Use it anywhere", "Games, apps, or web tools"]
    ]
    
    private var checkedStates: [Bool] = Array(repeating: true, count: 5)
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 19, weight: .bold)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        button.tintColor = .mainGray
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return button
    }()
    
    lazy var handPointImage: UIImageView = {
        let image = UIImage.handPoint
        let imageView = UIImageView(image: image)
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    lazy var payWallLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "Unlock Full Control with AutoClicker Pro"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .mainWhite
        return label
    }()
    
    lazy var tapLess: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tap Less.", for: .normal)
        button.setTitleColor(.buttonGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }()
    
    lazy var winMore: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Win more.", for: .normal)
        button.setTitleColor(.buttonGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }()
    
    lazy var automateAnything: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Automate anything.", for: .normal)
        button.setTitleColor(.buttonGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [tapLess, winMore, automateAnything])
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PayWallCell.self, forCellReuseIdentifier: PayWallCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    lazy var payView: UIView = {
        let view = UIView()
        view.backgroundColor = .buttonGray
        view.layer.cornerRadius = 36
        return view
    }()
    
    lazy var paySwitch: UISwitch = {
        let switchView = UISwitch()
        switchView.onTintColor = .mainYellow
        switchView.addTarget(self, action: #selector(handleSwitch), for: .valueChanged)
        return switchView
    }()
    
    lazy var payLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainWhite
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .left
        label.text = price
        return label
    }()
    
    lazy var trialLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainYellow
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textAlignment = .left
        label.text = "Start with 3-Day Free Trial"
        return label
    }()
    
    lazy var cancelLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainGray
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textAlignment = .left
        label.text = "Cancel anytime"
        return label
    }()
    
    lazy var payStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [payLabel, trialLabel, cancelLabel])
        stackView.axis = .vertical
        trialLabel.isHidden = true
        stackView.spacing = trialLabel.isHidden ? 4 : 2
        return stackView
    }()
    
    lazy var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .mainYellow
        button.layer.cornerRadius = 36
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        return button
    }()
    
    lazy var terms: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Terms", for: .normal)
        button.setTitleColor(.buttonGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        button.tag = WebLink.terms.rawValue
        button.addTarget(self, action: #selector(openWebView(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var privacy: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Privacy", for: .normal)
        button.setTitleColor(.buttonGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        button.tag = WebLink.privacy.rawValue
        button.addTarget(self, action: #selector(openWebView(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var subscriptionPolicy: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Subscription Policy", for: .normal)
        button.setTitleColor(.buttonGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        button.tag = WebLink.subscriptionPolicy.rawValue
        button.addTarget(self, action: #selector(openWebView(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var stackViewFooter: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [terms, privacy, subscriptionPolicy])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 30
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
        setupGradientBackground()
    }
    
    @objc
    func handleContinue() {
        print("Continue")
    }
    
    @objc
    func handleClose() {
        print("Экран закрылся")
    }
    
    @objc
    func handleSwitch(_ sender: UISwitch) {
        if sender.isOn {
            sender.thumbTintColor = .bg
            trialLabel.isHidden = false
            continueButton.setTitle( "Start Free Trial", for: .normal)
        } else {
            sender.thumbTintColor = .mainWhite
            continueButton.setTitle( "Continue", for: .normal)
            trialLabel.isHidden = true
        }
        print("Switch changed")
    }
    
    @objc
    func openWebView(_ sender: UIButton) {
       if let link = WebLink(rawValue: sender.tag) {
           let webVC = WebViewController(urlString: link.url)
            webVC.modalPresentationStyle = .fullScreen
            present(webVC, animated: true)
        }
    }
    
    func setupUI() {
        
        view.addSubviews(closeButton, continueButton, handPointImage, payWallLabel, stackView, tableView, payView, stackViewFooter)
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
            
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: payWallLabel.bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48),
            
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 32),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
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
        // Создаем градиентный слой
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.frame
        
        // Задаем цвета градиента
        gradientLayer.colors = [
            UIColor.bg.cgColor,
            UIColor.filling.cgColor
        ]
        
        // Задаем точки градиента (от 0 до 1)
        gradientLayer.locations = [0.0, 1.0]
        
        // Направление градиента
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0) // верх
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)   // низ
        
        // Добавляем слой как самый нижний
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        }
    }
}

extension PayWall: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PayWallCell.reuseIdentifier, for: indexPath) as? PayWallCell else {
            return UITableViewCell()
        }
        
        let item = tableItems[indexPath.row]
        if item.count == 2 {
            cell.configureWithTwoLines(
                title: item[0],
                subtitle: item[1],
                isChecked: checkedStates[indexPath.row]
            )
        } else {
            cell.configureWithOneLine(
                text: item[0],
                isChecked: checkedStates[indexPath.row]
            )
        }
        
        cell.onCheckboxTapped = { [weak self] isChecked in
            self?.checkedStates[indexPath.row] = isChecked
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        25
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Переключаем состояние чекбокса
        checkedStates[indexPath.row].toggle()
        
        // Анимируем изменение состояния
        if let cell = tableView.cellForRow(at: indexPath) as? PayWallCell {
            cell.setChecked(checkedStates[indexPath.row], animated: true)
        }
    }
}

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
    }
}

// Обертка для SwiftUI Preview
struct PayWallPreview: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> PayWall { PayWall() }
    
    func updateUIViewController(_ uiViewController: PayWall, context: Context) {}
}

#Preview {
    PayWallPreview()
        .ignoresSafeArea()
    //        .frame(width: 300, height: 100)
}

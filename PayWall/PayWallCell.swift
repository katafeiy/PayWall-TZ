import UIKit

class PayWallCell: UITableViewCell {
    
    static let reuseIdentifier = "PayWallCell"
    
    var onCheckboxTapped: ((Bool) -> Void)?
    
    private let checkBoxImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .mainWhite
        label.numberOfLines = 1
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = .mainGray
        label.numberOfLines = 1
        return label
    }()
    
    private let singleLineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .mainWhite
        label.numberOfLines = 1
        return label
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .bottom
        return stackView
    }()
    
    private let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .bottom
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            mainStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        mainStackView.addArrangedSubview(checkBoxImageView)
        
        NSLayoutConstraint.activate([
            checkBoxImageView.widthAnchor.constraint(equalToConstant: 16),
            checkBoxImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCheckboxTap))
        checkBoxImageView.isUserInteractionEnabled = true
        checkBoxImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleCheckboxTap() {
        let isCurrentChecked = checkBoxImageView.tintColor == .mainYellow
        let newChecked = !isCurrentChecked
        
        print("Checked states: \(newChecked)")
        
        onCheckboxTapped?(newChecked)
        setChecked(newChecked, animated: true)
        animateCheckboxTap()
    }
    
    private func animateCheckboxTap() {
        UIView.animate(withDuration: 0.1, animations: {
            self.checkBoxImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.checkBoxImageView.transform = .identity
            }
        }
    }
    
    func configureWithTwoLines(title: String, subtitle: String, isChecked: Bool) {

        singleLineLabel.removeFromSuperview()
        textStackView.removeFromSuperview()
        
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(subtitleLabel)
        
        mainStackView.addArrangedSubview(textStackView)
        
        titleLabel.text = title
        subtitleLabel.text = subtitle
        
        setChecked(isChecked, animated: false)
    }
    
    func configureWithOneLine(text: String, isChecked: Bool) {

        textStackView.removeFromSuperview()
        singleLineLabel.removeFromSuperview()
        
        mainStackView.addArrangedSubview(singleLineLabel)
        
        singleLineLabel.text = text
        
        setChecked(isChecked, animated: false)
    }
    
    func setChecked(_ isChecked: Bool, animated: Bool) {
        let imageName = isChecked ? "checkmark.square.fill" : "square"
        let image = UIImage(systemName: imageName)?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 16, weight: .medium))
        
        if animated {
            UIView.transition(with: checkBoxImageView,
                            duration: 0.2,
                            options: .transitionCrossDissolve,
                            animations: {
                                self.checkBoxImageView.image = image
                                self.checkBoxImageView.tintColor = isChecked ? .mainYellow : .buttonGray
                            },
                            completion: nil)
        } else {
            checkBoxImageView.image = image
            checkBoxImageView.tintColor = isChecked ? .mainYellow : .buttonGray
        }
    }
}

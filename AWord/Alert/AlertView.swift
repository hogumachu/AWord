import UIKit
import SnapKit

class AlertView: UIView {
    static let shared = AlertView()
    
    // MARK: - Properties
    
    private let alertView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .continuous
        return view
    }()
    private let alertLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .init(white: 0, alpha: 0.4)
        return view
    }()
    private lazy var backgroundButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(okButtonDidTap), for: .touchUpInside)
        button.backgroundColor = .clear
        return button
    }()
    private lazy var okButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(okButtonDidTap), for: .touchUpInside)
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.systemGray, for: .highlighted)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.layer.cornerCurve = .continuous
        
        button.contentMode = .scaleAspectFit
        return button
    }()
    private let checkMarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = _checkmarkCircle
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    private let xMarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = _xmarkCircleRed
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    convenience private init() {
        self.init(frame: UIScreen.main.bounds)
    }
    required internal init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override private init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: - Helper
    
    class func show(_ text: String = "") {
        
        DispatchQueue.main.async {
            shared.showAlert(text)
        }
    }
    
    class func showCheckMark(_ text: String = "") {
        DispatchQueue.main.async {
            shared.setCheckMarkImageView(text)
        }
    }
    
    class func showXMark(_ text: String = "") {
        DispatchQueue.main.async {
            shared.setXMarkImageView(text)
        }
    }
    
    private func hiddenImageViews() {
        checkMarkImageView.isHidden = true
        xMarkImageView.isHidden = true
    }
    
    private func setCheckMarkImageView(_ text: String = "") {
        hiddenImageViews()
        checkMarkImageView.isHidden = false
        checkMarkImageView.image = _checkmarkCircle
        alertLabel.text = text
        setUI()
        checkMarkAnimation()
    }
    
    private func setXMarkImageView(_ text: String = "") {
        hiddenImageViews()
        xMarkImageView.isHidden = false
        xMarkImageView.image = _xmarkCircleRed
        alertLabel.text = text
        setUI()
        xMarkAnimation()
    }
    
    private func xMarkAnimation() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        } completion: { [weak self] isCompleted in
            if isCompleted, let xMarkImageView = self?.xMarkImageView {
                UIView.transition(with: xMarkImageView, duration: 0.5, options: .transitionFlipFromRight) {
                    xMarkImageView.image = _xmarkCircleFillRed
                }
            }
        }
    }
    
    private func showAlert(_ text: String = "") {
        alertLabel.text = text
        setUI()
        defaultAnimation()
    }
    
    private func defaultAnimation() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
    
    private func checkMarkAnimation() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        } completion: { [weak self] isCompleted in
            if isCompleted, let checkMarkImageView = self?.checkMarkImageView {
                UIView.transition(with: checkMarkImageView, duration: 0.5, options: .transitionFlipFromRight) {
                    checkMarkImageView.image = _checkmarkCircleFill
                }
            }
        }
    }
    
    private func setUI() {
        alpha = 0
        addSubview(backgroundView)
        addSubview(alertView)
        addSubview(alertLabel)
        addSubview(backgroundButton)
        addSubview(okButton)
        
        addSubview(checkMarkImageView)
        addSubview(xMarkImageView)
        
        backgroundView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        alertView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(300)
        }
        
        alertLabel.snp.makeConstraints {
            $0.center.equalTo(alertView)
            $0.leading.greaterThanOrEqualTo(alertView.snp.leading).offset(10)
            $0.trailing.lessThanOrEqualTo(alertView.snp.trailing).offset(-10)
        }
        
        backgroundButton.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        okButton.snp.makeConstraints {
            $0.centerX.equalTo(alertView)
            $0.leading.equalTo(alertView.snp.leading).offset(30)
            $0.trailing.equalTo(alertView.snp.trailing).offset(-30)
            $0.bottom.equalTo(alertView.snp.bottom).offset(-10)
        }
        
        checkMarkImageView.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.centerX.equalTo(alertView)
            $0.bottom.equalTo(alertLabel.snp.top).offset(-10)
        }
        
        xMarkImageView.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.centerX.equalTo(alertView)
            $0.bottom.equalTo(alertLabel.snp.top).offset(-10)
        }
        
        let mainWindow = UIApplication.shared.windows.first ?? UIWindow()
        mainWindow.addSubview(self)
    }
    
    // MARK: - Cancel Action
    
    @objc
    private func okButtonDidTap() {
        self.removeFromSuperview()
    }
}

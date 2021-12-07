import UIKit
import SnapKit

class WordListTableViewCell: UITableViewCell {
    static let identifier = "WordListTableViewCellIdentifier"
    
    // MARK: - Properties
    
    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.cornerCurve = .continuous
        view.backgroundColor = _lightBackgroundColor
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.masksToBounds = false
        return view
    }()
    private let flipCardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.layer.cornerRadius = 8
        view.layer.cornerCurve = .continuous
        view.backgroundColor = _lightBackgroundColor
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.masksToBounds = false
        return view
    }()
    private let definitionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = _titleColor
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    private let flipDefinitionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = _titleColor
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    private let flipMeaningLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = _titleColor
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    private let checkMarkImageView: UIImageView = {
        let imageView = UIImageView(image: _checkmark)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    private let xMarkImageView: UIImageView = {
        let imageView = UIImageView(image: _xmarkRed)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    private func configureUI() {
        backgroundColor = _backgroundColor
        addSubview(cardView)
        addSubview(flipCardView)
        addSubview(checkMarkImageView)
        addSubview(xMarkImageView)
        
        cardView.addSubview(definitionLabel)
        
        flipCardView.addSubview(flipDefinitionLabel)
        flipCardView.addSubview(flipMeaningLabel)
        
        cardView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(2)
            $0.leading.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().offset(-5)
            $0.bottom.equalToSuperview().offset(-2)
            $0.height.equalTo(60)
        }
        
        flipCardView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(2)
            $0.leading.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().offset(-5)
            $0.bottom.equalToSuperview().offset(-2)
            $0.height.equalTo(60)
        }
        
        definitionLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().offset(50)
            $0.trailing.equalToSuperview().offset(-50)
        }
        
        flipDefinitionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalToSuperview().offset(50)
            $0.trailing.equalToSuperview().offset(-50)
        }
        
        flipMeaningLabel.snp.makeConstraints {
            $0.top.equalTo(flipDefinitionLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(flipDefinitionLabel)
        }
        
        checkMarkImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-15)
            $0.top.equalToSuperview().offset(10)
            
            $0.width.height.equalTo(15)
        }
        
        xMarkImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-15)
            $0.top.equalToSuperview().offset(10)
            
            $0.width.height.equalTo(15)
        }
    }
    
    func setItem(item: Word) {
        definitionLabel.text = item.definition
        flipDefinitionLabel.text = item.definition
        flipMeaningLabel.text = item.meaning
        
        setComplete(item.complete)
    }
    
    private func setComplete(_ complete: Int16) {
        switch complete {
        case 1:
            xMarkImageView.isHidden = false
            checkMarkImageView.isHidden = true
        case 2:
            xMarkImageView.isHidden = true
            checkMarkImageView.isHidden = false
        default:
            xMarkImageView.isHidden = true
            checkMarkImageView.isHidden = true
        }
    }
    
    // MARK: - Action
    
    func flip() {
        UIView.transition(with: cardView, duration: 0.3, options: .transitionCrossDissolve) { [weak self] in
            if let cardView = self?.cardView {
                cardView.isHidden = !cardView.isHidden
            }
        }
        
        UIView.transition(with: flipCardView, duration: 0.3, options: .transitionCrossDissolve) { [weak self] in
            if let flipCardView = self?.flipCardView {
                flipCardView.isHidden = !flipCardView.isHidden
            }
        }
    }
}

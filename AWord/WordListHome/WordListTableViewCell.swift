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
        view.layer.borderWidth = 1
        view.layer.borderColor = _titleColor.cgColor
        return view
    }()
    private let flipCardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.layer.cornerRadius = 8
        view.layer.cornerCurve = .continuous
        view.layer.borderWidth = 1
        view.layer.borderColor = _titleColor.cgColor
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
        addSubview(cardView)
        addSubview(flipCardView)
        
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
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        flipDefinitionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        flipMeaningLabel.snp.makeConstraints {
            $0.top.equalTo(flipDefinitionLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(flipDefinitionLabel)
        }
    }
    
    func setItem(item: Word) {
        definitionLabel.text = item.definition
        flipDefinitionLabel.text = item.definition
        flipMeaningLabel.text = item.meaning
    }
    
    // MARK: - Action
    
    func flip() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let cardView = self?.cardView, let flipCardView = self?.flipCardView else {
                return
            }
            
            cardView.isHidden = !cardView.isHidden
            flipCardView.isHidden = !flipCardView.isHidden
        }
    }
}

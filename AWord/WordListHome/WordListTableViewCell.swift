import UIKit
import SnapKit

class WordListTableViewCell: UITableViewCell {
    static let identifier = "WordListTableViewCellIdentifier"
    
    private let definitionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    private let meaningLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .blue
        label.isHidden = true
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(definitionLabel)
        addSubview(meaningLabel)
        
        definitionLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        meaningLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func setItem(item: Word) {
        definitionLabel.text = item.definition
        meaningLabel.text = item.meaning
    }
    
    func flip() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let definition = self?.definitionLabel, let meaning = self?.meaningLabel else {
                return
            }
            
            definition.isHidden = !definition.isHidden
            meaning.isHidden = !meaning.isHidden
        }
    }
}

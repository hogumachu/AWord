import UIKit
import SnapKit

class TestResultViewController: UIViewController {
    struct Dependency {
        let viewModel: TestResultViewModel
    }
    
    let viewModel: TestResultViewModel
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = _titleColor
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.text = "테스트 결과입니다"
        return label
    }()
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = _titleColor
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    
    init(dependency: Dependency) {
        self.viewModel = dependency.viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(totalLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(15)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
        
        totalLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(titleLabel)
        }
    }
    
    private func bind() {
        totalLabel.text = "총 \(viewModel.total) 개 중 \(viewModel.rightWords.count) 개 맞았습니다."
    }
}

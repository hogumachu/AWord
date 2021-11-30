import UIKit
import RxSwift
import SnapKit

class WordListCreateViewController: UIViewController {
    struct Dependency {
        let viewModel: WordListCreateViewModel
    }
    
    let viewModel: WordListCreateViewModel
    private let disposeBag = DisposeBag()
    private let headerStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        return stack
    }()
    private let createButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("생성", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        return button
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "단어를 입력하세요"
        return label
    }()
    private let wordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "단어를 입력하세요"
        return textField
    }()
    private let meaningTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "뜻을 입력하세요"
        return textField
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
        
        view.addSubview(headerStackView)
        view.addSubview(wordTextField)
        view.addSubview(meaningTextField)
        
        headerStackView.addArrangedSubview(cancelButton)
        headerStackView.addArrangedSubview(titleLabel)
        headerStackView.addArrangedSubview(createButton)
        
        headerStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-15)
        }
        
        wordTextField.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(5)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-5)
            $0.top.equalTo(headerStackView.snp.bottom).offset(10)
        }
        
        meaningTextField.snp.makeConstraints {
            $0.leading.trailing.equalTo(wordTextField)
            $0.top.equalTo(wordTextField.snp.bottom).offset(10)
        }
    }
    
    private func bind() {
        createButton.rx.tap
            .bind(
                with: self,
                onNext: { vc, _ in
                    vc.viewModel.create(definition: vc.wordTextField.text, meaning: vc.meaningTextField.text)
                }
            )
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .bind(
                with: viewModel,
                onNext: { viewModel, _ in
                    viewModel.cancel()
                }
            )
            .disposed(by: disposeBag)
    }
    
}
import UIKit
import RxSwift
import SnapKit

class TestViewController: UIViewController {
    
    struct Dependency {
        let viewModel: TestViewModel
    }
    
    let viewModel: TestViewModel
    private let disposeBag = DisposeBag()
    private let problemLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = _titleColor
        label.textAlignment = .center
        return label
    }()
    private let exampleStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .center
        return stack
    }()
    private let nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
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
        bind()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = _backgroundColor
        
        view.addSubview(problemLabel)
        view.addSubview(exampleStackView)
        view.addSubview(nextButton)
        
        
        problemLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.snp.centerY)
        }
        
        exampleStackView.snp.makeConstraints {
            $0.top.equalTo(problemLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-60)
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(exampleStackView.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    private func bind() {
        viewModel.testObservable
            .bind(
                with: self,
                onNext: { vc, testWord in
                    if let testWord = testWord {
                        vc.setTestWords(testWord: testWord)
                    }
                }
            )
            .disposed(by: disposeBag)
        
        viewModel.words
            .bind(
                with: self,
                onNext: { vc, words in
                    vc.viewModel.generateTestWords(words: words)
                }
            )
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(
                with: viewModel,
                onNext: { vm, _ in
                    vm.next()
                }
            )
            .disposed(by: disposeBag)
        
        viewModel.hasNext
            .bind(
                with: nextButton,
                onNext: { button, hasNext in
                    button.isHidden = hasNext ? false : true
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func setTestWords(testWord: TestWord) {
        problemLabel.text = "\(testWord.problem.definition)"
        
        if exampleStackView.subviews.count != testWord.examples.count + 1 {
            (testWord.examples + [testWord.problem])
                .map { word -> UILabel in
                    let label = UILabel()
                    label.text = word.meaning
                    label.textColor = _titleColor
                    label.textAlignment = .center
                    return label
                }
                .shuffled()
                .forEach { label in
                    exampleStackView.addArrangedSubview(label)
                }
        } else {
            (testWord.examples + [testWord.problem])
                .map {
                    $0.meaning
                }
                .shuffled()
                .enumerated()
                .forEach { (offset, element) in
                    if let label = exampleStackView.arrangedSubviews[offset] as? UILabel {
                        label.text = element
                    }
                }
        }
    }
}

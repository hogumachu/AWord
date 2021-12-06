import UIKit
import RxSwift
import SnapKit

class TestViewController: UIViewController {
    
    struct Dependency {
        let viewModel: TestViewModel
    }
    
    let viewModel: TestViewModel
    private let disposeBag = DisposeBag()
    private let problemView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .continuous
        view.backgroundColor = .systemGray5
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.masksToBounds = false
        return view
    }()
    private let problemLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = _titleColor
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    private let exampleStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.spacing = 5
        return stack
    }()
    private let speakButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(_speaker, for: .normal)
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
        setNavigationBar()
    }
    
    private func configureUI() {
        view.backgroundColor = _backgroundColor
        
        view.addSubview(problemView)
        view.addSubview(exampleStackView)
        
        problemView.addSubview(problemLabel)
        problemView.addSubview(speakButton)
        
        problemView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.bottom.equalTo(view.snp.centerY)
        }
        
        problemLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().offset(-5)
        }
        
        speakButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().offset(-5)
            $0.width.height.equalTo(30)
        }
        
        exampleStackView.snp.makeConstraints {
            $0.top.equalTo(problemView.snp.bottom).offset(10)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
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
        
        viewModel.words()
            .bind(
                with: self,
                onNext: { vc, words in
                    vc.viewModel.generateTestWords(words: words)
                }
            )
            .disposed(by: disposeBag)
        
        viewModel.isRight
            .bind(
                with: self,
                onNext: { vc, isRight in
                    vc.viewModel.testResultAlert(vc, testReuslt: isRight)
                }
            )
            .disposed(by: disposeBag)
        
        viewModel.title
            .bind(
                with: self,
                onNext: { vc, title in
                    vc.title = title
                }
            )
            .disposed(by: disposeBag)
        
        speakButton.rx.tap
            .bind(
                with: viewModel,
                onNext: { vm, _ in
                    vm.speak()
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func setNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setTestWords(testWord: TestWord) {
        problemLabel.text = "\(testWord.problem.definition)"
        
        if exampleStackView.subviews.count != testWord.examples.count + 1{
            (testWord.examples + [testWord.problem])
                .map { word -> UIButton in
                    let button = UIButton()
                    button.setTitle(word.meaning, for: .normal)
                    button.setTitleColor(_titleColor, for: .normal)
                    button.setTitleColor(_lightTitleColor, for: .highlighted)
                    button.backgroundColor = .white
                    button.layer.cornerRadius = 8
                    button.layer.cornerCurve = .continuous
                    button.layer.borderColor = _titleColor.cgColor
                    button.layer.borderWidth = 1
                    
                    button.rx.tap
                        .bind(
                            with: self,
                            onNext: { vc, _ in
                                vc.viewModel.exampleDidTap(meaning: button.titleLabel?.text)
                            }
                        )
                        .disposed(by: disposeBag)
                    
                    return button
                }
                .shuffled()
                .forEach { button in
                    exampleStackView.addArrangedSubview(button)
                }
        } else {
            (testWord.examples + [testWord.problem])
                .map {
                    $0.meaning
                }
                .shuffled()
                .enumerated()
                .forEach { (offset, element) in
                    if let button = exampleStackView.arrangedSubviews[offset] as? UIButton {
                        button.setTitle(element, for: .normal)
                    }
                }
        }
    }
}

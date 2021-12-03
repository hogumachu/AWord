import UIKit
import RxSwift

class TestViewController: UIViewController {
    
    struct Dependency {
        let viewModel: TestViewModel
    }
    
    let viewModel: TestViewModel
    private let disposeBag = DisposeBag()
    
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
        
        
    }
    
    private func bind() {
        // TODO: - Set Test Words
        
        viewModel.words
            .bind(
                with: self,
                onNext: { vc, words in
                    let testWords = vc.viewModel.generateTestWords(words: words)
                    
                    print(testWords)
                }
            )
            .disposed(by: disposeBag)
    }
}

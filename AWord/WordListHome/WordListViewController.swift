import UIKit
import RxSwift
import SnapKit

class WordListViewController: UIViewController {
    struct Dependency {
        let viewModel: WordListViewModel
    }
    
    let viewModel: WordListViewModel
    
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
        view.backgroundColor = .systemPink
    }
    
    private func bind() {
        
    }
    
}

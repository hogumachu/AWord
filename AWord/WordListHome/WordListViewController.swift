import UIKit
import RxSwift
import RxCocoa
import SnapKit

class WordListViewController: UIViewController {
    struct Dependency {
        let viewModel: WordListViewModel
    }
    
    let viewModel: WordListViewModel
    private let disposeBag = DisposeBag()
    private let wordListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(WordListTableViewCell.self, forCellReuseIdentifier: WordListTableViewCell.identifier)
        return tableView
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
        
        view.addSubview(wordListTableView)
        
        
        wordListTableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        wordListTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.wordList
            .bind(to: wordListTableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: disposeBag)
        
        wordListTableView.rx.itemSelected
            .bind(
                with: self,
                onNext: { vc, indexPath in
                    vc.viewModel.itemSelected(tableView: vc.wordListTableView, at: indexPath)
                }
            )
            .disposed(by: disposeBag)
        
    }
}

extension WordListViewController: UIScrollViewDelegate { }

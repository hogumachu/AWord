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
    private let createButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("생성", for: .normal)
        button.setTitleColor(.systemPink, for: .normal)
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
        configureUI()
        bind()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(wordListTableView)
        view.addSubview(createButton)
        
        wordListTableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        createButton.snp.makeConstraints {
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
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
        
        wordListTableView.rx.itemDeleted
            .bind(
                with: viewModel,
                onNext: { viewModel, indexPath in
                    viewModel.delete(indexPath: indexPath)
                }
            )
            .disposed(by: disposeBag)
        
        createButton.rx.tap
            .bind(
                with: viewModel,
                onNext: { viewModel, _ in
                    viewModel.create()
                }
            )
            .disposed(by: disposeBag)
        
        navigationItem.title = viewModel.storage.title
    }
}

extension WordListViewController: UIScrollViewDelegate { }

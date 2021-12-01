import UIKit
import RxSwift
import RxCocoa
import SnapKit

class WordSetViewController: UIViewController {
    struct Dependency {
        let viewModel: WordSetViewModel
    }
    
    
    // MARK: - Properties
    
    let viewModel: WordSetViewModel
    private let disposeBag = DisposeBag()
    private let setTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(WordSetTableViewCell.self, forCellReuseIdentifier: WordSetTableViewCell.identifier)
        tableView.backgroundColor = _backgroundColor
        tableView.separatorStyle = .none
        return tableView
    }()
    private let createButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleToFill
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.setImage(_plusCircle, for: .normal)
        button.setImage(_plusCircleFill, for: .highlighted)
        return button
    }()
    
    // MARK: - Lifecycle
    
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
    
    // MARK: - Configure
    
    private func configureUI() {
        navigationItem.title = "AWord"
        
        view.backgroundColor = _backgroundColor
        
        view.addSubview(setTableView)
        view.addSubview(createButton)
        
        setTableView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(createButton.snp.top).offset(-10)
        }
        
        createButton.snp.makeConstraints {
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.width.height.equalTo(30)
        }
    }
    
    // MARK: - Bind
    
    private func bind() {
        setTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.wordSetList
            .bind(to: setTableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: disposeBag)
        
        Observable.zip(setTableView.rx.modelSelected(WordSet.self), setTableView.rx.itemSelected)
            .bind(
                with: self,
                onNext: { vc, event in
                    vc.viewModel.modelSelected(tableView: vc.setTableView, model: event.0, indexPath: event.1)
                }
            )
            .disposed(by: disposeBag)
        
        setTableView.rx.modelDeleted(WordSet.self)
            .bind(
                with: viewModel,
                onNext: { viewModel, wordSet in
                    viewModel.delete(wordSet: wordSet)
                }
            )
            .disposed(by: disposeBag)
        
        setTableView.rx.itemMoved
            .bind(
                with: viewModel,
                onNext: { viewModel, indexPaths in
                    viewModel.move(source: indexPaths.sourceIndex, destination: indexPaths.destinationIndex)
                }
            )
            .disposed(by: disposeBag)
        
        createButton.rx.tap
            .bind(
                with: self,
                onNext: { vc, _ in
                    vc.viewModel.create(vc)
                    
                }
            )
            .disposed(by: disposeBag)
    }
}

extension WordSetViewController: UIScrollViewDelegate { }

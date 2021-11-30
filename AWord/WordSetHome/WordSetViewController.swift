import UIKit
import RxSwift
import RxCocoa
import SnapKit

class WordSetViewController: UIViewController {
    struct Dependency {
        let viewModel: WordSetViewModel
    }
    
    let viewModel: WordSetViewModel
    
    private let disposeBag = DisposeBag()
    private let setTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(WordSetTableViewCell.self, forCellReuseIdentifier: WordSetTableViewCell.identifier)
        return tableView
    }()
    private let createButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("생성", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    private let editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("편집", for: .normal)
        button.setTitleColor(.red, for: .normal)
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
        
        view.addSubview(setTableView)
        view.addSubview(createButton)
        view.addSubview(editButton)
        
        setTableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        createButton.snp.makeConstraints {
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        editButton.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    private func bind() {
        setTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.wordSetList
            .bind(to: setTableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: disposeBag)
        
        setTableView.rx.itemSelected
            .bind(
                with: self,
                onNext: { vc, indexPath in
                    vc.viewModel.itemSelected(tableView: vc.setTableView, indexPath: indexPath)
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
        
        editButton.rx.tap
            .bind(
                with: self,
                onNext: { vc, _ in
                    vc.changeEditMode()
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func changeEditMode() {
        setTableView.setEditing(!setTableView.isEditing, animated: true)
    }
}

extension WordSetViewController: UIScrollViewDelegate { }

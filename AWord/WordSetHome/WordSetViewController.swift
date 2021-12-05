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
        button.backgroundColor = UIColor(hex: "95D1CC")
        button.setTitle("세트 추가하기", for: .normal)
        button.setTitleColor(_titleColor, for: .normal)
        button.setTitleColor(.systemGray, for: .highlighted)
        button.contentMode = .scaleToFill
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.layer.cornerRadius = 8
        button.layer.cornerCurve = .continuous
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        button.layer.masksToBounds = false
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
        setNavigationBar()
    }
    
    // MARK: - Configure
    
    private func configureUI() {
        view.backgroundColor = _backgroundColor
        
        view.addSubview(setTableView)
        view.addSubview(createButton)
        
        setTableView.tableFooterView = UIView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 80))
        
        setTableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        createButton.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(40)
        }
    }
    
    private func setNavigationBar() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = _titleColor
        navigationItem.backBarButtonItem = backBarButtonItem
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "AWord"
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

extension WordSetViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
       if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
          navigationController?.setNavigationBarHidden(true, animated: true)
       } else {
          navigationController?.setNavigationBarHidden(false, animated: true)
       }
    }
}

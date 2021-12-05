import UIKit
import RxSwift
import RxCocoa
import SnapKit

class WordListViewController: UIViewController {
    struct Dependency {
        let viewModel: WordListViewModel
    }
    
    // MARK: - Properties
    
    let viewModel: WordListViewModel
    private let disposeBag = DisposeBag()
    private let wordListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(WordListTableViewCell.self, forCellReuseIdentifier: WordListTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = _backgroundColor
        return tableView
    }()
    private let createButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(hex: "95D1CC")
        button.setTitle("추가하기", for: .normal)
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
    private let testButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(hex: "95D1CC")
        button.setTitle("학습하기", for: .normal)
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
        
        view.addSubview(wordListTableView)
        view.addSubview(createButton)
        view.addSubview(testButton)
        
        wordListTableView.tableFooterView = UIView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 80))
        
        wordListTableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        createButton.snp.makeConstraints {
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.leading.equalTo(view.snp.centerX).offset(10)
            $0.height.equalTo(40)
        }
        
        testButton.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.trailing.equalTo(view.snp.centerX).offset(-10)
            $0.height.equalTo(40)
        }
    }
    
    private func setNavigationBar() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = _titleColor
        navigationItem.backBarButtonItem = backBarButtonItem
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Bind
    
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
        
        wordListTableView.rx.modelDeleted(Word.self)
            .bind(
                with: viewModel,
                onNext: { viewModel, word in
                    viewModel.delete(word: word)
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
        
        testButton.rx.tap
            .bind(
                with: viewModel,
                onNext: { vm, _ in
                    vm.test()
                }
            )
            .disposed(by: disposeBag)
        
        navigationItem.title = viewModel.storage.title
    }
}

extension WordListViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
       if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
          navigationController?.setNavigationBarHidden(true, animated: true)
       } else {
          navigationController?.setNavigationBarHidden(false, animated: true)
       }
    }
}

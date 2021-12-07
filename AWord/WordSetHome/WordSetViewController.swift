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
    private let popUpView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 8
        view.layer.cornerCurve = .continuous
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.masksToBounds = false
        return view
    }()
    private let popUpLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "세트 추가 버튼을 눌러 단어장을 생성해보세요!"
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    private let handTapImageView: UIImageView = {
        let imageView = UIImageView(image: _handTap)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.animationImages = [_handTap!, _handTapFill!]
        imageView.animationDuration = 1.5
        imageView.animationRepeatCount = 8
        return imageView
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
        view.addSubview(popUpView)
        view.addSubview(handTapImageView)
        
        popUpView.addSubview(popUpLabel)
        
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
        
        popUpView.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.bottom.equalTo(createButton.snp.top).offset(-20)
        }
        
        popUpLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().offset(-5)
        }
        
        handTapImageView.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.trailing.equalTo(createButton).offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-5)
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
        
        viewModel.wordSetList
            .bind(
                with: self,
                onNext: { vc, items in
                    vc.sceneInitialSet(count: items.count)
                }
            )
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
    
    // MARK: - Init View Helper
    
    private func sceneInitialSet(count: Int) {
        if count == 0 {
            UIView.transition(with: popUpView, duration: 0.5, options: .transitionFlipFromBottom) { [weak self] in
                self?.popUpView.isHidden = false
            }
            handTapImageView.isHidden = false
            
            handTapImageView.startAnimating()
        } else {
            popUpView.isHidden = true
            handTapImageView.isHidden = true
        }
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

extension WordSetViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
}

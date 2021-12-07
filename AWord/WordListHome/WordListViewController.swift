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
        label.text = "추가하기 버튼을 눌러 단어를 생성할 수 있습니다!"
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()
    private let secondPopUpView: UIView = {
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
    private let secondPopUpLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "단어 5개 부터 학습하기를 진행할 수 있습니다!"
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 2
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
        
        view.addSubview(wordListTableView)
        view.addSubview(createButton)
        view.addSubview(testButton)
        
        view.addSubview(popUpView)
        view.addSubview(secondPopUpView)
        view.addSubview(handTapImageView)
        
        popUpView.addSubview(popUpLabel)
        secondPopUpView.addSubview(secondPopUpLabel)
        
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
        
        popUpView.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.bottom.equalTo(secondPopUpView.snp.top).offset(-20)
        }
        
        popUpLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().offset(-5)
        }
        
        secondPopUpView.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.bottom.equalTo(createButton.snp.top).offset(-20)
        }
        
        secondPopUpLabel.snp.makeConstraints {
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
    }
    
    // MARK: - Bind
    
    private func bind() {
        wordListTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.wordList
            .bind(to: wordListTableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: disposeBag)
        
        viewModel.wordList
            .bind(
                with: self,
                onNext: { vc, items in
                    vc.sceneInitialSet(count: items[0].items.count)
                }
            )
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
    
    // MARK: - Init View Helper
    
    private func sceneInitialSet(count: Int) {
        if count == 0 {
            UIView.transition(with: popUpView, duration: 0.5, options: .transitionFlipFromBottom) { [weak self] in
                self?.popUpView.isHidden = false
            }
            UIView.transition(with: secondPopUpView, duration: 0.5, options: .transitionFlipFromBottom) { [weak self] in
                self?.secondPopUpView.isHidden = false
            }
            handTapImageView.isHidden = false
            
            handTapImageView.startAnimating()
        } else {
            popUpView.isHidden = true
            secondPopUpView.isHidden = true
            handTapImageView.isHidden = true
        }
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

extension WordListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
}

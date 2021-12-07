import UIKit
import RxSwift
import SnapKit

class TestResultViewController: UIViewController {
    struct Dependency {
        let viewModel: TestResultViewModel
    }
    
    let viewModel: TestResultViewModel
    private let disposeBag = DisposeBag()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = _titleColor
        label.font = .systemFont(ofSize: 30, weight: .heavy)
        label.text = "결과"
        return label
    }()
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = _titleColor
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    private let okButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(hex: "95D1CC")
        button.setTitle("확인", for: .normal)
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
    private let testResultCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TestResultCollectionViewCell.self, forCellWithReuseIdentifier: TestResultCollectionViewCell.identifier)
        collectionView.isPagingEnabled = false
        collectionView.backgroundColor = _backgroundColor
        return collectionView
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
        view.backgroundColor = _backgroundColor
        
        view.addSubview(titleLabel)
        view.addSubview(totalLabel)
        view.addSubview(okButton)
        
        view.addSubview(testResultCollectionView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(15)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
        
        totalLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        testResultCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(totalLabel.snp.bottom).offset(10)
            $0.bottom.equalTo(okButton.snp.top).offset(-10)
        }
        
        okButton.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(40)
        }
    }
    
    private func bind() {
        totalLabel.text = "\(viewModel.total) 문제 중 \(viewModel.rightWords.count) 개 맞았습니다."
        
        viewModel.wordList
            .bind(to: testResultCollectionView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: disposeBag)
        
        okButton.rx.tap
            .bind(
                with: self,
                onNext: { vc, _ in
                    vc.viewModel.back(vc)
                }
            )
            .disposed(by: disposeBag)
        
        testResultCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension TestResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}

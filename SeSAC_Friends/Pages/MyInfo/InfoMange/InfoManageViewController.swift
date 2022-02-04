//
//  InfoManageViewController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/02.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

final class InfoManageViewController: UIViewController {
    //MARK: Properties
    
    private let viewModel = InfoManageViewModel()
    
    private var disposeBag = DisposeBag()
    
    //MARK: UI
    private let mainView = InfoManageView()
    
    private let saveButton = UIButton().then {
        let attr = NSAttributedString(string: "저장", attributes: [NSAttributedString.Key.font: UIFont.title3_M14])
        $0.setAttributedTitle(attr, for: .normal)
        $0.setTitleColor(.defaultBlack, for: .normal)
    }
    
    //MARK: Method
    private func bind() {
        
        let reviews = viewModel.output.sesacReviews
            .share()
        
        //MARK: Input Binding
        saveButton.rx.tap
            .asDriver()
            .drive(viewModel.input.saveButtonClicked)
            .disposed(by: disposeBag)
        
        mainView.infoStackView.hobbyView.hobbyTextField.textField.rx.text.orEmpty
            .asDriver()
            .drive(viewModel.input.hobbyTextFieldText)
            .disposed(by: disposeBag)
        
        mainView.infoStackView.withdrawView.rx.tapGesture()
            .when(.recognized)
            .asDriver { _ in .never() }
            .drive(viewModel.input.tapWithdrawView)
            .disposed(by: disposeBag)
        
        mainView.cardView.nicknameView.rx.tapGesture()
            .when(.recognized)
            .asDriver { _ in .never() }
            .drive(viewModel.input.tapNicknameView)
            .disposed(by: disposeBag)
        
        mainView.cardView.cardStackView.sesacReviewChevronImage.rx.tapGesture()
            .when(.recognized)
            .withLatestFrom(reviews)
            .filter { !($0.isEmpty) }
            .asDriver(onErrorJustReturn: [])
            .drive(with: self) { owner, reviews in
                print("tab")
                //MARK: 리뷰가 있는 경우...
            }
            .disposed(by: disposeBag)
        
        mainView.infoStackView.genderView.manButton.rx.tap
            .asDriver()
            .drive(viewModel.input.manButtonClicked)
            .disposed(by: disposeBag)
        
        mainView.infoStackView.genderView.womanButton.rx.tap
            .asDriver()
            .drive(viewModel.input.womanButtonClicked)
            .disposed(by: disposeBag)
        
        mainView.infoStackView.ageRestrictView.slider.rx.controlEvent(.valueChanged)
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.viewModel.input.ageValueChanged.accept(owner.mainView.infoStackView.ageRestrictView.slider.value)
            }
            .disposed(by: disposeBag)
        
        mainView.infoStackView.hobbyView.hobbyTextField.textField.rx.controlEvent(.editingDidBegin)
            .asDriver()
            .drive(viewModel.input.tapHobbyTextField)
            .disposed(by: disposeBag)

        mainView.infoStackView.hobbyView.hobbyTextField.textField.rx.controlEvent(.editingDidEndOnExit)
            .asDriver()
            .drive(viewModel.input.endEditTextField)
            .disposed(by: disposeBag)
        
        mainView.infoStackView.allowView.allowSwitch.rx.value
            .asDriver()
            .drive(viewModel.input.allowSearchPhoneNumber)
            .disposed(by: disposeBag)
        
        //MARK: Output Binding
        viewModel.output.sesacImage
            .asDriver(onErrorJustReturn: 0)
            .drive(with: self) { owner, sesac in
                switch sesac {
                case 1:
                    owner.mainView.cardView.cardImageView.sesacImage.image = UIImage(asset: Asset.sesacFace2)
                case 2:
                    owner.mainView.cardView.cardImageView.sesacImage.image = UIImage(asset: Asset.sesacFace3)
                default:
                    owner.mainView.cardView.cardImageView.sesacImage.image = UIImage(asset: Asset.sesacFace1)
                }
                
            }
            .disposed(by: disposeBag)
        
        viewModel.output.backgroundImage
            .asDriver(onErrorJustReturn: 0)
            .drive(with: self) { owner, background in
                switch background {
                case 1:
                    owner.mainView.cardView.cardImageView.backgroundImage.image = UIImage(asset: Asset.sesacBackground2)
                case 2:
                    owner.mainView.cardView.cardImageView.backgroundImage.image = UIImage(asset: Asset.sesacBackground3)
                default:
                    owner.mainView.cardView.cardImageView.backgroundImage.image = UIImage(asset: Asset.sesacBackground1)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.output.ageValue
            .filter { !($0.isEmpty) }
            .asDriver(onErrorJustReturn: [])
            .drive(with: self) { owner, values in
                let first = values[0]
                let second = values[1]
                owner.mainView.infoStackView.ageRestrictView.ageRangeLabel.text = "\(Int(first)) - \(Int(second))"
                owner.mainView.infoStackView.ageRestrictView.slider.value = [first, second]
            }
            .disposed(by: disposeBag)
        
        
        viewModel.output.switchValue
            .asDriver(onErrorJustReturn: false)
            .drive(mainView.infoStackView.allowView.allowSwitch.rx.value)
            .disposed(by: disposeBag)
        
        viewModel.output.floatingPopUp
            .debug()
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                print("pop Up")
            }
            .disposed(by: disposeBag)
        
        viewModel.output.openOrClose
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, bool in
                owner.mainView.cardView.openOrClose(opened: bool)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.manButtonState
            .asDriver()
            .drive(mainView.infoStackView.genderView.manButton.rx.buttonState)
            .disposed(by: disposeBag)
        
        viewModel.output.womanButtonState
            .asDriver()
            .drive(mainView.infoStackView.genderView.womanButton.rx.buttonState)
            .disposed(by: disposeBag)
        
        
        reviews
            .asDriver(onErrorJustReturn: [])
            .drive(with: self) { owner, reviews in
                if !(reviews.isEmpty) {
                    owner.mainView.cardView.cardStackView.sesacReviewContentLabel.text = reviews[0]
                    owner.mainView.cardView.cardStackView.sesacReviewChevronImage.isHidden = false
                    owner.mainView.cardView.cardStackView.sesacReviewContentLabel.textColor = .defaultBlack
                } else {
                    owner.mainView.cardView.cardStackView.sesacReviewChevronImage.isHidden = true
                    owner.mainView.cardView.cardStackView.sesacReviewContentLabel.textColor = .gray6
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.output.sesacTitles
            .asDriver()
            .drive(with: self) { owner, titles in
                let view = owner.mainView.cardView.cardStackView.titleStackView
                for (index, title) in titles.enumerated() {
                    if title != 0 {
                        switch index {
                        case 0:
                            view.goodMannerButton.buttonState = .fill
                        case 1:
                            view.exactTimeButton.buttonState = .fill
                        case 2:
                            view.fastResponseButton.buttonState = .fill
                        case 3:
                            view.kindnessButton.buttonState = .fill
                        case 4:
                            view.greatJobButton.buttonState = .fill
                        case 5:
                            view.goodTimeButton.buttonState = .fill
                        default:
                            print("아직 추가 안된 케이스")
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.output.textFieldState
            .asDriver()
            .drive(mainView.infoStackView.hobbyView.hobbyTextField.rx.textFieldState)
            .disposed(by: disposeBag)
        
        viewModel.output.goToPrevious
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                print("저장 버튼 클릭")
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.textFieldText
            .asDriver()
            .drive(mainView.infoStackView.hobbyView.hobbyTextField.textField.rx.text)
            .disposed(by: disposeBag)

    }
    
    //MARK: LifeCycle
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "정보 관리"
        let barButton = UIBarButtonItem(customView: saveButton)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }
}

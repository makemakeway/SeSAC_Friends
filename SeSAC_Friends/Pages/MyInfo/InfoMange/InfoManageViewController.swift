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
import Toast
import Then

final class InfoManageViewController: UIViewController {
    //MARK: Properties
    
    private let viewModel = InfoManageViewModel()
    
    private var disposeBag = DisposeBag()
    
    var needSelectGender = false
    
    //MARK: UI
    private let mainView = InfoManageView()
    
    private let saveButton = UIButton().then {
        let attr = NSAttributedString(string: "저장", attributes: [NSAttributedString.Key.font: UIFont.title3_M14])
        $0.setAttributedTitle(attr, for: .normal)
        $0.setTitleColor(.defaultBlack, for: .normal)
    }
    
    private func popupConfig() {
        let vc = CustomAlertViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.mainView.mainTitleLabel.text = "정말 탈퇴하시겠습니까?"
        vc.mainView.subtextLabel.text = "탈퇴하시면 새싹 프렌즈를 이용할 수 없어요ㅠ"
        
        vc.mainView.cancelButton.rx.tap
            .asDriver()
            .drive { _ in
                vc.dismiss(animated: false, completion: nil)
            }
            .disposed(by: disposeBag)

        vc.mainView.okButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.viewModel.input.withdrawButtonClicked.onNext(())
                vc.dismiss(animated: false, completion: nil)
            }
            .disposed(by: disposeBag)
        
        self.present(vc, animated: false, completion: nil)
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
        
        mainView.cardView.cardStackView.sesacReviewView.sesacReviewChevronImage.rx.tapGesture()
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
                owner.popupConfig()
            }
            .disposed(by: disposeBag)
        
        viewModel.output.openOrClose
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, bool in
                owner.mainView.cardView.openOrClose(opened: bool)
                owner.mainView.infoStackView.snp.updateConstraints { make in
                    make.top.equalTo(owner.mainView.cardView.snp.bottom)
                }
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
                    owner.mainView.cardView.cardStackView.sesacReviewView.sesacReviewContentLabel.text = reviews[0]
                    owner.mainView.cardView.cardStackView.sesacReviewView.sesacReviewChevronImage.isHidden = false
                    owner.mainView.cardView.cardStackView.sesacReviewView.sesacReviewContentLabel.textColor = .defaultBlack
                } else {
                    owner.mainView.cardView.cardStackView.sesacReviewView.sesacReviewChevronImage.isHidden = true
                    owner.mainView.cardView.cardStackView.sesacReviewView.sesacReviewContentLabel.textColor = .gray6
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.output.sesacTitles
            .asDriver()
            .drive(with: self) { owner, titles in
                let view = owner.mainView.cardView.cardStackView.sesacTitleView
                owner.selectedSesacTitle(titles: titles, view: view)
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
        
        viewModel.output.goToOnboarding
            .debug("GoToOnboarding")
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                let vc = OnBoardingViewController()
                owner.changeRootView(viewController: vc)
            }
            .disposed(by: disposeBag)

        viewModel.output.errorMessage
            .asDriver(onErrorJustReturn: "")
            .filter { !($0.isEmpty) }
            .drive(with: self) { owner, message in
                owner.view.makeToast(message, duration: 3.0, position: .center)
            }
            .disposed(by: disposeBag)
    }
    
    override func willMove(toParent parent: UIViewController?) {
        if parent == nil {
            let viewControllers = self.navigationController!.viewControllers
            if ((viewControllers[viewControllers.count - 2]).isKind(of: UIViewController.self)) {
                (viewControllers[viewControllers.count - 2]).hidesBottomBarWhenPushed = false
            }
        }
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
        view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind()
        viewModel.transform()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if needSelectGender {
            view.makeToast("새싹 찾기를 이용하기 위해서는 성별이 필요해요!")
            needSelectGender = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }
}

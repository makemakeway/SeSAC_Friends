//
//  HomeViewController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/29.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation
import NMapsMap
import Toast

enum HomeType {
    case defaults
    case fromBackbutton
}

final class HomeViewController: UIViewController {
    //MARK: Properties
    private var disposeBag = DisposeBag()
    private let viewModel = HomeViewModel()
    private let locationManager = CLLocationManager()
    
    var homeType = HomeType.defaults
    
    //MARK: UI
    
    private let mainView = HomeView()
    private var markers = Set<NMFMarker>()
    
    //MARK: Method
    
    private func bind() {
        
        //MARK: Input Binding
        viewModel.input.homeInit.onNext(())
        
        mainView.entireButton.rx.tap
            .asDriver()
            .drive(viewModel.input.entireButtonClicked)
            .disposed(by: disposeBag)
        
        mainView.manButton.rx.tap
            .asDriver()
            .drive(viewModel.input.manButtonClicked)
            .disposed(by: disposeBag)
        
        mainView.womanButton.rx.tap
            .asDriver()
            .drive(viewModel.input.womanButtonClicked)
            .disposed(by: disposeBag)
        
        mainView.locationButton.rx.tap
            .asDriver()
            .drive(viewModel.input.locationButtonClicked)
            .disposed(by: disposeBag)
        
        mainView.floatingButton.rx.tap
            .asDriver()
            .drive(viewModel.input.floatingButtonClicked)
            .disposed(by: disposeBag)
        
        
        //MARK: Output Binding
        
        viewModel.output.entireButtonState
            .asDriver()
            .drive(mainView.entireButton.rx.buttonState)
            .disposed(by: disposeBag)
        
        viewModel.output.manButtonState
            .asDriver()
            .drive(mainView.manButton.rx.buttonState)
            .disposed(by: disposeBag)
        
        viewModel.output.womanButtonState
            .asDriver()
            .drive(mainView.womanButton.rx.buttonState)
            .disposed(by: disposeBag)
        
        
        viewModel.output.filteredQueueList
            .debug("AddMarkers")
            .filter { !($0.isEmpty) }
            .asDriver(onErrorJustReturn: [])
            .drive(with: self) { owner, friends in
                owner.addMarker(friends: friends)
            }
            .disposed(by: disposeBag)

        viewModel.output.filteredRequiredQueueList
            .debug("AddMarkers")
            .filter { !($0.isEmpty) }
            .asDriver(onErrorJustReturn: [])
            .drive(with: self) { owner, friends in
                owner.addMarker(friends: friends)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.currentFilterValue
            .debug("RemoveMarkers")
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: -1)
            .drive(with: self) { owner, value in
                owner.removeMarkers()
            }
            .disposed(by: disposeBag)

        viewModel.output.currentMapViewCamera
            .asDriver(onErrorJustReturn: DefaultValue.location)
            .drive(with: self) { owner, location in
                owner.moveCamera(location: location)
            }
            .disposed(by: disposeBag)

        viewModel.output.currentUserState
            .debug("Current User State")
            .asDriver(onErrorJustReturn: .normal)
            .drive(mainView.floatingButton.rx.floatingButtonState)
            .disposed(by: disposeBag)
        
        viewModel.output.currentAuthorization
            .debug("현재 유저 권한")
            .asDriver(onErrorJustReturn: .notDetermined)
            .drive(with: self) { owner, status in
                print(status)
            }
            .disposed(by: disposeBag)

        viewModel.output.showAlert
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.alertConfig()
            }
            .disposed(by: disposeBag)

        viewModel.output.goToEnterHobby
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                let vc = EnterHobbyViewController()
                owner.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.goToInfoManage
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.goToInfoManageView()
            }
            .disposed(by: disposeBag)

        viewModel.output.errorMessage
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, message in
                owner.view.makeToast(message,
                                     duration: 3.0,
                                     position: .center)
            }
            .disposed(by: disposeBag)

        viewModel.output.goToSearchSesac
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                let root = HomeViewController()
                let vc1 = EnterHobbyViewController()
                let vc2 = SearchSesacViewController()
                owner.hidesBottomBarWhenPushed = true
                let vcs = [owner, root, vc1, vc2]
                owner.navigationController?.setViewControllers(vcs, animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.goToChat
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                let vc = ChatViewController()
                owner.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)

        viewModel.output.goToOnboarding
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                let vc = OnBoardingViewController()
                owner.changeRootView(viewController: vc)
            }
            .disposed(by: disposeBag)
    }
    
    func alertConfig() {
        let vc = CustomAlertViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.mainView.mainTitleLabel.text = "위치 서비스 사용불가"
        vc.mainView.cancelButton.rx.tap
            .asDriver()
            .drive { _ in
                vc.dismiss(animated: false, completion: nil)
            }
            .disposed(by: disposeBag)

        vc.mainView.okButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                print("아이폰 설정 화면으로 이동")
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
                vc.dismiss(animated: false, completion: nil)
            }
            .disposed(by: disposeBag)
        present(vc, animated: false, completion: nil)
    }
    
    func moveCamera(location: CLLocationCoordinate2D) {
        print("Location: \(location)")
        let camera = NMFCameraPosition(NMGLatLng(lat: location.latitude,
                                                 lng: location.longitude), zoom: 18)
        let update = NMFCameraUpdate(position: camera)
        
        mainView.mapView.moveCamera(update)
    }
    
    func removeMarkers() {
        let group = DispatchGroup()
        
        group.enter()
        for marker in self.markers {
            marker.self.mapView = nil
        }
        group.leave()
        
        group.notify(queue: DispatchQueue.global()) {
            self.markers.removeAll()
        }
    }
    
    func addMarker(friends: [FromQueueDB]) {
        for friend in friends {
            let marker = NMFMarker()
            let friendPosition = NMGLatLng(lat: friend.lat, lng: friend.long)
            let size = UIScreen.main.bounds.width * 0.2222
            switch friend.sesac {
            case 0:
                let iconImage = NMFOverlayImage(image: UIImage(asset: Asset.sesacFace1)!)
                marker.iconImage = iconImage
            case 1:
                let iconImage = NMFOverlayImage(image: UIImage(asset: Asset.sesacFace2)!)
                marker.iconImage = iconImage
            case 2:
                let iconImage = NMFOverlayImage(image: UIImage(asset: Asset.sesacFace3)!)
                marker.iconImage = iconImage
            case 3:
                let iconImage = NMFOverlayImage(image: UIImage(asset: Asset.sesacFace4)!)
                marker.iconImage = iconImage
            case 4:
                let iconImage = NMFOverlayImage(image: UIImage(asset: Asset.sesacFace5)!)
                marker.iconImage = iconImage
            default:
                let iconImage = NMFOverlayImage(image: UIImage(asset: Asset.sesacFace1)!)
                marker.iconImage = iconImage
            }
            
            marker.width = size
            marker.height = size
            marker.position = friendPosition
            marker.mapView = mainView.mapView
            markers.insert(marker)
            print("MARKER: \(marker)")
        }
    }
    
    //MARK: LifeCycle
    override func loadView() {
        self.view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel.transform()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        viewModel.input.currentAuthority.onNext(locationManager.authorizationStatus)
        viewModel.input.userStateChanged.onNext(.normal)
        mainView.mapView.addCameraDelegate(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        hidesBottomBarWhenPushed = false
        viewModel.input.homeWillAppear.onNext(())
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
}

extension HomeViewController: NMFMapViewCameraDelegate {
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        let target = mapView.cameraPosition.target
        
        viewModel.input.mapViewCameraDidChanged
            .onNext(CLLocationCoordinate2D(latitude: target.lat, longitude: target.lng))
        mapView.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            mapView.isUserInteractionEnabled = true
        }
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("위치권한 : \(manager.authorizationStatus)")
        viewModel.input.currentAuthority.onNext(manager.authorizationStatus)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last?.coordinate else { return }
        viewModel.input.locationDidChanged
            .onNext(location)
        manager.stopUpdatingLocation()
        
        if homeType == .fromBackbutton {
            let position = UserInfo.mapPosition
            print("FROM BACKBUTTON")
            moveCamera(location: CLLocationCoordinate2D(latitude: position.lat, longitude: position.lng))
        }
    }
    
}

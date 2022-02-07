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
import RxCoreLocation
import NMapsMap

final class HomeViewController: UIViewController {
    //MARK: Properties
    private var disposeBag = DisposeBag()
    private let viewModel = HomeViewModel()
    private let locationManager = CLLocationManager()
    
    //MARK: UI
    
    private let mainView = HomeView()
    private var markers = Set<NMFMarker>()
    
    //MARK: Method
    
    private func bind() {
        
        //MARK: Input Binding
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
        
        locationManager.rx.didUpdateLocations
            .compactMap { $0.locations.last?.coordinate }
            .bind(to: viewModel.input.locationDidChanged)
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
        
        viewModel.output.currentLocation
            .asDriver()
            .drive(with: self) { owner, location in
                let camera = NMFCameraPosition(NMGLatLng(lat: location.latitude,
                                                         lng: location.longitude), zoom: 18)
                let update = NMFCameraUpdate(position: camera)
                
                owner.mainView.mapView.moveCamera(update)
            }
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

    }
    
    func removeMarkers() {
        print(#function)
        for marker in markers {
            marker.mapView = nil
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
        super.loadView()
        self.view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel.transform()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mainView.mapView.addCameraDelegate(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
}

extension HomeViewController: NMFMapViewCameraDelegate {
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        viewModel.input.mapViewCameraDidChanged
            .onNext(mapView.cameraPosition)
    }
}

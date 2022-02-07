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
            .debug("UPDATE Location")
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

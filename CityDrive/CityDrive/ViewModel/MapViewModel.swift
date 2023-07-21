//
//  MapViewModel.swift
//  CityDrive
//
//  Created by Иван Вдовин on 16.06.2023.
//

import Foundation
import MapKit
import SwiftUI

class MapViewModel: ObservableObject {
    private var networkManager: NetworkManager
    
    @Published var cars: [Car] = []
    @Published var bonusBalance = ""

//    @Published var mapRegion: MKCoordinateRegion
    
    //==========================
    //
    // TODO: change in settings
    //
    @AppStorage("selectedCity") var city: City?
    @AppStorage("selectedMapType") var mapType: MapType?
    var interactions: MapInteractionModes = [.pan, .zoom]
    //
    //==========================

    init() {
        self.networkManager = NetworkManager()
        loadCarStatus()
//        self.mapRegion = MKCoordinateRegion(center: city.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    }
    
    func loadCarStatus() {
        networkManager.getCarStatus { response, error in
            if let error = error {
                print(error)
            }
            
            if let statusResponse = response {
                let cars = statusResponse.cars?.compactMap { car in
                    if
                        car.areaGroupID == self.city?.areaGroupID,
                        let carID = car.carID,
                        let id = UUID(uuidString: carID),
                        let lat = car.lat,
                        let lon = car.lon,
                        let img = car.img,
                        let model = car.model,
                        let number = car.number,
                        let distance = car.distance {
                        return Car(
                            id: id,
                            lat: lat,
                            lon: lon,
                            img: img,
                            model: model,
                            number: number,
                            distance: distance,
                            walktime: 0,
                            fuel: 0,
                            tankVolume: 0,
                            powerReserve: 0,
                            tankVolumeEmergency: 0,
                            discount: 0,
                            transferable: false,
                            seats: 0,
                            remainPath: 0,
                            carFilterID: "",
                            notAvailable: false,
                            horn: false,
                            isElectric: false,
                            tariffID: "",
                            chargingLevel: 0,
                            remainPathElectric: 0,
                            areaGroupID: "",
                            engineWarnUpAvailable: false,
                            carFilterCompany: CarFilterCompany(),
                            transferringIsAvailable: false,
                            boosterSeat: false,
                            babySeat: false,
                            forSale: false,
                            eOsagoLink: "",
                            wrapBrand: "",
                            fuelType: "",
                            inTransfer: false,
                            hasTransponder: false,
                            transferModeExists: false,
                            engineWarnUp: false,
                            wrapBrandLogo: ""
                        )
                    }
                    return nil
                }
                
                if let cars = cars {
                    DispatchQueue.main.async {
                        self.cars = cars
                    }
                }
            }
        }
    }
    
    func loadBonusBalance() {
        networkManager.getBonusCount { response, error in
            if let error = error {
                print(error)
            }
            
            if let bonusBalance = response?.balance {
                DispatchQueue.main.async {
                    self.bonusBalance = String(bonusBalance)
                }
            }
        }
    }
    
}

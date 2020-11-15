//
//  LocationsViewController.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 31.10.2020.
//

import UIKit
import Combine

class LocationsViewController: UIViewController {
    
    var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getLocations()
    }
    
    func getLocations() {
        NetworkService.sharedInstance.getLocations(for: 1).sink { (completion) in
            if case .failure(let apiError) = completion {
                print(apiError.errorMessage)
            }
        } receiveValue: { (responseModel) in
            print(responseModel)
        }
        .store(in: &cancellables)
    }
    


}

//
//  MainViewModel.swift
//  Scorp Case
//
//  Created by YUSUF TALHA BALIKCIN on 13.12.2023.
//

import Foundation

enum RequestType {
    case getPeople
    case insertPeople
}

protocol MainViewModelDelegate: AnyObject {
    func fetchedData()
    func handleError(_ errorMessage: String)
}

class MainViewModel {
    weak var delegate: MainViewModelDelegate?
    var responseModel = MainModel()
    var isLoading = false
    var inserted = false
    private var next = "0"
    
    func getData(requestType: RequestType) {
        next = requestType == .getPeople ? "0" : next
        self.isLoading = true
        
        DataSource.fetch(next: next) { response, error in
            self.isLoading = false
            
            if let _ = response {
                if requestType == .getPeople {
                    self.responseModel.people = response?.people ?? [Person]()
                } else {
                    response?.people.forEach({ person in
                        if !self.responseModel.people.contains(where: { $0.id == person.id }) {
                            self.responseModel.people.append(person)
                            self.inserted = true
                        }
                    })
                }
                
                self.next = String(response?.people.count ?? 0)
                self.delegate?.fetchedData()
            } else if let errorMessage = error?.errorDescription {
                self.delegate?.handleError(errorMessage)
            }
        }
    }
}

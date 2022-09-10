//
//  AddOrderViewModel.swift
//  Kahawa Tungu
//
//  Created by LenoxBrown on 10/09/2022.
//

import Foundation

struct AddOrderViewModel{
    
    var name: String?
    var email: String?
    //
    var selectedType: String?
    var selectedSize: String?
    
    var types: [String]{
        return CoffeeType.allCases.map { $0.rawValue.capitalized }
    }
    
    var sizes: [String]{
        return CoffeeSize.allCases.map{ $0.rawValue.capitalized }
    }
    
}

//
//  Order.swift
//  Kahawa Tungu
//
//  Created by LenoxBrown on 10/09/2022.
//

import Foundation

enum CoffeeType: String, Codable, CaseIterable{
    case capuccino
    case latte
    case expresso
    case cortado
}

enum CoffeeSize: String, Codable, CaseIterable{
    case small
    case medium
    case large
}

struct Order: Codable{
    
    let name: String
    let email: String
    let type: CoffeeType
    let size: CoffeeSize
}

extension Order{
    
    init?(_ vm: AddOrderViewModel){
        guard let name = vm.name,
              let email = vm.email,
              let selectedType = CoffeeType(rawValue: vm.selectedType!.lowercased()),
              let size = CoffeeSize(rawValue: vm.selectedSize!.lowercased()) else{
            return nil
        }
        
        self.name = name
        self.email = email
        self.type = selectedType
        self.size = size
        
    }
    
}

extension Order{
    
    static var all: Resource<[Order]> = {
        //
        guard let url = URL(string: "https://warp-wiry-rugby.glitch.me/orders") else{
            fatalError("Could not create URL")
        }
        //
        return Resource<[Order]>(url: url)
    }()
    
    static func create(vm: AddOrderViewModel) -> Resource<Order?>{
        //
        let order = Order(vm)
        //
        guard let url = URL(string: "https://warp-wiry-rugby.glitch.me/orders") else{
            fatalError("Could not create URL")
        }
        //
        guard let data = try? JSONEncoder().encode(order) else{
            fatalError("Could not encode data")
        }
        //
        var resource = Resource<Order?>(url: url)
        resource.httpMethod = HttpMethod.post
        resource.body = data
        //
        return resource
    }
    
}

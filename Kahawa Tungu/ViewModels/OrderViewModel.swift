//
//  OrderViewModel.swift
//  Kahawa Tungu
//
//  Created by LenoxBrown on 10/09/2022.
//

import Foundation

//MARK: - OrderListViewModel rep entire list
struct OrderListViewModel{
    
    var ordersViewModel: [OrderViewModel]
    
    init(){
        self.ordersViewModel = [OrderViewModel]()
    }
    
}

//MARK: - Configures the index to return the OrderViewModel
extension OrderListViewModel{
    
    func orderViewModel(at index: Int) -> OrderViewModel {
        return self.ordersViewModel[index]
    }
    
}


//MARK: - Represent one order object
struct OrderViewModel{
    let order: Order
}

//MARK: - Represent one order
extension OrderViewModel{
    
    var name: String{
        return self.order.name
    }
    
    var email: String{
        return self.order.email
    }
    
    var type: String{
        return self.order.type.rawValue.capitalized
    }
    
    var size: String{
        return self.order.size.rawValue.capitalized
    }
}

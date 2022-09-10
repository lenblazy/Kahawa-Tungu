//
//  OrdersTableVC.swift
//  Kahawa Tungu
//
//  Created by LenoxBrown on 10/09/2022.
//

import Foundation
import UIKit

class OrdersTableViewController: UITableViewController{
    
    var orderListVM = OrderListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateOrders()
    }
    
    private func populateOrders(){
        //
        WebService().load(resource: Order.all) { [weak self] result in
            switch result{
            case .success(let orders):
                self?.orderListVM.ordersViewModel = orders.map({ order in
                    OrderViewModel.init(order: order)
                })
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderListVM.ordersViewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = self.orderListVM.orderViewModel(at: indexPath.row)
        //
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath)
        cell.textLabel?.text = vm.type
        cell.detailTextLabel?.text = vm.size
        //
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController,
              let addCoffeeOrderVC = navC.viewControllers.first as? AddOrderViewController else {
            print("Error performing segue!")
            return
        }
        
        addCoffeeOrderVC.delegate = self
    }
    
}

extension OrdersTableViewController: AddOrderDelegate{
    func addOrderDelegateDidSave(order: Order, controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
        //
        let orderVM = OrderViewModel(order: order)
        self.orderListVM.ordersViewModel.append(orderVM)
        self.tableView.insertRows(at: [IndexPath.init(row: self.orderListVM.ordersViewModel.count - 1, section: 0)], with: .automatic)
    }
    
    func addOrderViewControllerDidClose(controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}

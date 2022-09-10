//
//  AddOrderVC.swift
//  Kahawa Tungu
//
//  Created by LenoxBrown on 10/09/2022.
//

import Foundation
import UIKit

protocol AddOrderDelegate{
    
    func addOrderDelegateDidSave(order: Order, controller: UIViewController)
    func addOrderViewControllerDidClose(controller: UIViewController)
    
}

class AddOrderViewController: UIViewController{
    
    var delegate: AddOrderDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfName: UITextField!
    //
    private var coffeSizesSegmentedControl: UISegmentedControl!
    //
    private var vm = AddOrderViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        setUp()
        //
        tableView.delegate = self
        tableView.dataSource = self
        //
    }
    
    private func setUp(){
        self.coffeSizesSegmentedControl = UISegmentedControl(items: self.vm.sizes)
        // we will be applying different contraints
        self.coffeSizesSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.coffeSizesSegmentedControl)
        //
        self.coffeSizesSegmentedControl.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 20).isActive = true
        self.coffeSizesSegmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        //
        //        self.coffeSizesSegmentedControl.
    }
    
    
    @IBAction func actionClose(_ sender: UIBarButtonItem) {
        
        if let delegate = delegate {
            delegate.addOrderViewControllerDidClose(controller: self)
        }
    }
    
    
    @IBAction func actionSave(_ sender: UIBarButtonItem) {
        let name = self.tfName.text
        let email = self.tfEmail.text
        
        let selectedSize = self.coffeSizesSegmentedControl.titleForSegment(at: self.coffeSizesSegmentedControl.selectedSegmentIndex)
        //
        guard let indexPath = self.tableView.indexPathForSelectedRow else{
            fatalError("Error in selecting coffee")
        }
        
        self.vm.name = name
        self.vm.email = email
        //
        self.vm.selectedSize = selectedSize
        self.vm.selectedType = self.vm.types[indexPath.row]
        //
        
        WebService().load(resource: Order.create(vm: self.vm)) { result in
            switch result{
            case .success(let order):
                DispatchQueue.main.async {
                    if let order = order, let delegate = self.delegate{
                        delegate.addOrderDelegateDidSave(order: order, controller: self)
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension AddOrderViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.types.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeTypeCell", for: indexPath)
        cell.textLabel?.text = self.vm.types[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
}

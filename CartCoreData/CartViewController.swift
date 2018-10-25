//
//  CartViewController.swift
//  CoredAtaDemo
//
//  Created by Mac User on 10/3/18.
//  Copyright © 2018 Mac User. All rights reserved.
//

import UIKit
import CoreData

class CartViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
     var value=["0","0","0","0","0"]
    
    @IBOutlet weak var tbview: UITableView!
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
    
    var tasks: [CartEntity] = []
    var type = String()
    var product_array = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
     
        tbview.allowsSelection = false
        getData()
        //calculateTotal()
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return product_array.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! productTableViewCell
        
        let obj_dic = product_array.object(at: indexPath.row) as! NSDictionary
        
        cell.ItemName.text=obj_dic.value(forKey: "product_id") as! String
        cell.lblNo.text = obj_dic.value(forKey: "product_count") as! String
        cell.plusBtn.tag=indexPath.row
        cell.minusBtn.tag=indexPath.row
        
        cell.plusBtn.addTarget(self, action: #selector(ProductViewController.addBtn(sender:)), for: .touchUpInside)
        cell.minusBtn.addTarget(self, action: #selector(ProductViewController.subBtn(sender:)), for: .touchUpInside)
        
        
        
        return cell
    }
    
    
    @objc func addBtn(sender: AnyObject) -> Int {
        //var count:NSInteger=0;
        //let button: UIButton = sender as! UIButton
        
        let indexPath = NSIndexPath(row: sender.tag, section: 0) // This defines what indexPath is which is used later to define a cell
        var count1=Int()
        let cell = tbview.cellForRow(at: indexPath as IndexPath) as! productTableViewCell! // This is where the magic happens - reference to the cell
        count1 = Int(cell?.lblNo.text ?? "0")!
        count1 = 1 + count1
     
        print(count1)
        cell?.lblNo.text = "\(count1)" // Once you have the reference to the cell, just use the traditional way of setting up the objects inside the cell.
        
        let obj_dic = product_array.object(at: indexPath.row) as! NSDictionary
        
        
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CartEntity")
        request.predicate = NSPredicate (format: "product_id == %@", obj_dic.value(forKey: "product_id") as! String)
        let product_id = obj_dic.value(forKey: "product_id")
        do
        {
            let result = try context.fetch(request)
            if result.count > 0
            {
                let objectUpdate = result[0] as! NSManagedObject
                
                objectUpdate.setValue(count1, forKey: "product_count")
                objectUpdate.setValue(product_id, forKey: "product_id")
                
                do {
                    try context.save()
                    
                    
                } catch {}
                
                print("Object Saved.")
                
                
            }
            else
            {
                
                let newproduct = NSEntityDescription.insertNewObject(forEntityName: "CartEntity", into: context) as NSManagedObject
                newproduct.setValue(count1, forKey: "product_count")
                newproduct.setValue(product_id, forKey: "product_id")
                
                do {
                    try context.save()
                } catch {}
                
                print("Object Saved.")
            }
        }
        catch
        {
            print(error)
        }
        
        
        
        return count
    }
    
    
    
    
    
    @objc func subBtn(sender: AnyObject) -> Int {
        //var count1:NSInteger=0;
        //let button: UIButton = sender as! UIButton
        
        let indexPath = NSIndexPath(row: sender.tag, section: 0)
        var count=Int(value[indexPath.row])!;
        let cell = tbview.cellForRow(at: indexPath as IndexPath) as! productTableViewCell!
        count = Int(cell?.lblNo.text ?? "0")!
        count = count - 1
        value[indexPath.row]=String(count);
        cell?.lblNo.text = "\(count)"
        print(count)
        if count == 0 {
            NSLog("Count zero")
            let task = tasks[indexPath.row]
            context.delete(task)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                tasks = try context.fetch(CartEntity.fetchRequest())
            }
            catch {
                print("Fetching Failed")
            }
             getData()
        }else{
            
            
              let obj_dic = product_array.object(at: indexPath.row) as! NSDictionary
            
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CartEntity")
            request.predicate = NSPredicate (format: "product_id == %@", obj_dic.value(forKey: "product_id") as! String)
            let product_id = obj_dic.value(forKey: "product_id")
            do
            {
                let result = try context.fetch(request)
                if result.count > 0
                {
                    let objectUpdate = result[0] as! NSManagedObject
                    
                    objectUpdate.setValue(count, forKey: "product_count")
                    objectUpdate.setValue(product_id, forKey: "product_id")
                    
                    do {
                        try context.save()
                        
                        
                    } catch {}
                    
                    print("Object Saved.")
                    
                    
                }
                else
                {
                    
                    let newproduct = NSEntityDescription.insertNewObject(forEntityName: "CartEntity", into: context) as NSManagedObject
                    newproduct.setValue(count, forKey: "product_count")
                    newproduct.setValue(product_id, forKey: "product_id")
                    
                    do {
                        try context.save()
                    } catch {}
                    
                    print("Object Saved.")
                }
            }
            catch
            {
                print(error)
            }
        }
        
        return count
    }
    
    
    func getData() {
        
        do {
            
            tasks = try context.fetch(CartEntity.fetchRequest())
            product_array.removeAllObjects()
            for item in tasks
            {
                var product_dic = NSMutableDictionary()
                let data = item.product_id
                let count = item.product_count
                print("name:\(String(describing: data!))","Count:\(count)")
                product_dic.setValue(data, forKey: "product_id")
                product_dic.setValue(String(count), forKey: "product_count")
                product_array.add(product_dic)
            }
            
            tbview.reloadData()
        }
        catch {
            print("Fetching Failed")
        }
    }
    

}

//
//  ViewController.swift
//  BeaconPopoSwift4
//
//  Created by wan muzaffar Wan Hashim on 14/07/2018.
//  Copyright © 2018 wan muzaffar Wan Hashim. All rights reserved.
//

import UIKit
import QuartzCore
import CoreLocation
import CoreBluetooth

class ViewController: UIViewController, CBPeripheralManagerDelegate  {
    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var minorTextField: UITextField!
    
    @IBOutlet weak var broadcastBtn: UIButton!
    var uuid = UUID(uuidString: "48E47A6D-F366-A502-CD5D-1EC12DC66282")
    
    var beaconRegion : CLBeaconRegion!
    
    var bluetoothPeripheralManager: CBPeripheralManager!
    
    var isBroadcasting = false
    
    var dataDictionary : [String:Any] = [:]
    
    @IBOutlet weak var lblBTStatus: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
          bluetoothPeripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
       
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func broadcastPressed(_ sender: Any) {
       
        if majorTextField.text == "" || minorTextField.text == "" {
            return
        }
        
       
        
        if !isBroadcasting {
            if bluetoothPeripheralManager.state == .poweredOn {
                let major: CLBeaconMajorValue = UInt16(Int(majorTextField.text!)!)
                let minor: CLBeaconMinorValue = UInt16(Int(minorTextField.text!)!)
                
                beaconRegion = CLBeaconRegion(proximityUUID: uuid!, major: major, minor: minor, identifier: "com.itrainasia.beacondemo")
                dataDictionary = beaconRegion.peripheralData(withMeasuredPower: nil) as! [String: Any]
                bluetoothPeripheralManager.startAdvertising(dataDictionary)
                
                broadcastBtn.setTitle("Stop", for: .normal)
                
                majorTextField.isEnabled = false
                minorTextField.isEnabled = false
                
                isBroadcasting = true
            }
        }
        else {
            bluetoothPeripheralManager.stopAdvertising()
            
            broadcastBtn.setTitle("Start", for: .normal)
            lblBTStatus.text = "Stopped"
            
            majorTextField.isEnabled = true
            minorTextField.isEnabled = true
            
            isBroadcasting = false
        }
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        var statusMessage = ""
        
        switch peripheral.state {
        case .poweredOn:
            statusMessage = "Bluetooth Status: Turned On"
            
        case .poweredOff:
            if isBroadcasting {
                broadcastPressed(self)
            }
            statusMessage = "Bluetooth Status: Turned Off"
            
        case .resetting:
            statusMessage = "Bluetooth Status: Resetting"
            
        case .unauthorized:
            statusMessage = "Bluetooth Status: Not Authorized"
            
        case .unsupported:
            statusMessage = "Bluetooth Status: Not Supported"
            
        default:
            statusMessage = "Bluetooth Status: Unknown"
        }
        
        lblBTStatus.text = statusMessage
    }

}


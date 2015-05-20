//
//  BTService.swift
//  Arduino_Servo
//
//  Created by Owen L Brown on 10/11/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import Foundation
import CoreBluetooth

/* Services & Characteristics UUIDs
characteristic 一共有六个
FFF1 READ WRITE
FFF2 READ
FFF3 WRITE
FFF4 Notify
FFF5 Read
FFF6 Read,Write Without Response,Notify
*/

let BLEServiceUUID = CBUUID(string: "FFF0")//current bluetooth uuid
let WRITEUUID = CBUUID(string: "FFF6")
let BLEServiceChangedStatusNotification = "kBLEServiceChangedStatusNotification"
let BLEServiceReceiveNotification = "kBLEServiceReceiveNotification"

class BTService: NSObject, CBPeripheralDelegate {
    var peripheral: CBPeripheral?
    var positionCharacteristic: CBCharacteristic?
    
    init(initWithPeripheral peripheral: CBPeripheral) {
        super.init()
        
        self.peripheral = peripheral
        self.peripheral?.delegate = self
    }
    
    deinit {
        self.reset()
    }
    
    func startDiscoveringServices() {
        //        self.peripheral?.discoverServices([BLEServiceUUID])
        self.peripheral?.discoverServices(nil)
    }
    
    func reset() {
        if peripheral != nil {
            peripheral = nil
        }
        
        // Deallocating therefore send notification
        self.sendBTServiceNotificationWithIsBluetoothConnected(false)
    }
    
    // Mark: - CBPeripheralDelegate
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        
        if(error != nil){
            println("Error Reading characteristic value: \(error.localizedDescription)")
        }else{
            var data = characteristic.value
            let str:String = (NSString(data: data, encoding: NSUTF8StringEncoding) ?? "blank") as String
            let connectionDetails = ["value": str]
            
            println("charac \(characteristic.UUID) updates value: \(str)")
            NSNotificationCenter.defaultCenter().postNotificationName(BLEServiceReceiveNotification, object: self, userInfo: connectionDetails)
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        println("Discover services")
        let uuidsForBTService: [CBUUID] = [WRITEUUID]
        
        if (peripheral != self.peripheral) {
            // Wrong Peripheral
            return
        }
        
        if (error != nil) {
            return
        }
        
        if ((peripheral.services == nil) || (peripheral.services.count == 0)) {
            // No Services
            return
        }
        
        for service in peripheral.services {
            println("serveice uuid = \(service.UUID)")
            if service.UUID == BLEServiceUUID {
                peripheral.discoverCharacteristics(nil, forService: service as! CBService)
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        println("Found characterisctics")
        if (peripheral != self.peripheral) {
            // Wrong Peripheral
            return
        }
        
        if (error != nil) {
            return
        }
        
        for characteristic in service.characteristics {
            println("characteristic == \(characteristic.UUID)")
            if characteristic.UUID == WRITEUUID {
                self.positionCharacteristic = (characteristic as! CBCharacteristic)
                peripheral.setNotifyValue(true, forCharacteristic: characteristic as! CBCharacteristic)
                // Send notification that Bluetooth is connected and all required characteristics are discovered
                self.sendBTServiceNotificationWithIsBluetoothConnected(true)
            }
        }
    }
    
    // Mark: - Private
    func writePosition(position: UInt8) {
        // See if characteristic has been discovered before writing to it
        if self.positionCharacteristic == nil {
            return
        }
        
        // Need a mutable var to pass to writeValue function
        var positionValue = position
        let data = NSData(bytes: &positionValue, length: sizeof(UInt8))
        self.peripheral?.writeValue(data, forCharacteristic: self.positionCharacteristic, type: CBCharacteristicWriteType.WithoutResponse)
    }
    
    func sendBTServiceNotificationWithIsBluetoothConnected(isBluetoothConnected: Bool) {
        let connectionDetails = ["isConnected": isBluetoothConnected]
        NSNotificationCenter.defaultCenter().postNotificationName(BLEServiceChangedStatusNotification, object: self, userInfo: connectionDetails)
    }
    
}
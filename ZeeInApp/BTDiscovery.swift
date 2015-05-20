//
//  BTDiscovery.swift
//  Arduino_Servo
//
//  Created by Owen L Brown on 9/24/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import Foundation
import CoreBluetooth

let btDiscoverySharedInstance = BTDiscovery();

class BTDiscovery: NSObject, CBCentralManagerDelegate {
    private var centralManager: CBCentralManager?
    private var peripheralBLE: CBPeripheral?
    
    override init() {
        super.init()
        let centralQueue = dispatch_queue_create("com.raywenderlich", DISPATCH_QUEUE_SERIAL)
        centralManager = CBCentralManager(delegate: self, queue: centralQueue)
        //        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startScanning() {
        //        centralManager!.scanForPeripheralsWithServices(nil, options: nil)
        if let central = centralManager {
            central.scanForPeripheralsWithServices([BLEServiceUUID], options: nil)
        }
    }

    var bleService: BTService? {
        didSet {
            if let service = self.bleService {
                service.startDiscoveringServices()
            }
        }
    }
    
//    func disconnect(){
//        现在不能用啊
//        println("Disconnect!")
//        centralManager?.cancelPeripheralConnection(self.peripheralBLE)
//        clearDevices()
//    }
    
    // MARK: - CBCentralManagerDelegate
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!,
        advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
            println("found peripheral")
            // Be sure to retain the peripheral or it will fail during connection.
            
            // Validate peripheral information
            if ((peripheral == nil) || (peripheral.name == nil) || (peripheral.name == "")) {
                return
            }
            
            // If not already connected to a peripheral, then connect to this one
            if ((self.peripheralBLE == nil) || (self.peripheralBLE?.state == CBPeripheralState.Disconnected)) {
                
                println("CenCentalManagerDelegate didDiscoverPeripheral")
                println("Discovered \(peripheral.name)")//name Microduino
                println("uuid : \(peripheral.identifier)")//uuid BF16FC65-A071-6BD7-18E4-EFF904D8DE1F
                println("Rssi: \(RSSI)")
                println("Stop scan the Ble Devices")
                
                // Retain the peripheral before trying to connect
                self.peripheralBLE = peripheral
                
                // Reset service
                self.bleService = nil
                
                // Connect to peripheral
                central.connectPeripheral(peripheral, options: nil)
            }
    }
    
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        println("connect!")
        if (peripheral == nil) {
            return;
        }
        
        // Create new service class
        if (peripheral == self.peripheralBLE) {
            self.bleService = BTService(initWithPeripheral: peripheral)
        }
        
        // Stop scanning for new devices
        central.stopScan()
    }
    
    func centralManager(central: CBCentralManager!, didDisconnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        println("Disconnect!")
        if (peripheral == nil) {
            return;
        }
        
        // See if it was our peripheral that disconnected
        if (peripheral == self.peripheralBLE) {
            self.bleService = nil;
            self.peripheralBLE = nil;
        }
        
        // Start scanning for new devices
        self.startScanning()
    }
    
    // MARK: - Private
    func clearDevices() {
        println("Clear Devices")
        self.bleService = nil
        self.peripheralBLE = nil
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        switch (central.state) {
        case CBCentralManagerState.PoweredOff:
            self.clearDevices()
            
        case CBCentralManagerState.Unauthorized:
            // Indicate to user that the iOS device does not support BLE.
            break
            
        case CBCentralManagerState.Unknown:
            // Wait for another event
            break
            
        case CBCentralManagerState.PoweredOn:
            self.startScanning()
            
        case CBCentralManagerState.Resetting:
            self.clearDevices()
            
        case CBCentralManagerState.Unsupported:
            break
            
        default:
            break
        }
    }
    
}

//
//  BLEController.m
//  FlexECG
//
//  Created by Jules Agee on 2/7/17.
//  Copyright © 2017 Jules Agee & Peter Richie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEController.h"

@implementation BLEController : NSObject

// initialization

- (BLEController *) init
{
    CBCentralManager *centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    self.centralManager = centralManager;
    return self;
}

// method called whenever you have successfully connected to the BLE peripheral
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
    self.connected = [NSString stringWithFormat:@"Connected: %@", peripheral.state == CBPeripheralStateConnected ? @"YES" : @"NO"];
    NSLog(@"%@", self.connected);
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Lost connection to FlexECG peripheral");
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
}

// CBCentralManagerDelegate - This is called with the CBPeripheral class as its main input parameter. This contains most of the information there is to know about a BLE peripheral.
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSString *localName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    if ([localName isEqual:@"FlexECG"]) {
        NSLog(@"Found the FlexECG peripheral: %@", localName);
        [self.centralManager stopScan];
        self.flexECGPeripheral = peripheral;
        peripheral.delegate = self;
        [self.centralManager connectPeripheral:peripheral options:nil];
        [self.centralManager stopScan]; //turn off scanning for peripherals
    }
}

// method called whenever the device state changes.
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    // Determine the state of the peripheral
    if ([central state] == CBManagerStatePoweredOff) {
        NSLog(@"CoreBluetooth BLE hardware is powered off");
    }
    else if ([central state] == CBManagerStatePoweredOn) {
        NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
        // Scan for all available CoreBluetooth LE devices
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
        
    }
    else if ([central state] == CBManagerStateUnauthorized) {
        NSLog(@"CoreBluetooth BLE state is unauthorized");
    }
    else if ([central state] == CBManagerStateUnknown) {
        NSLog(@"CoreBluetooth BLE state is unknown");
    }
    else if ([central state] == CBManagerStateUnsupported) {
        NSLog(@"CoreBluetooth BLE hardware is unsupported on this platform");
    }
}

// CBPeripheralDelegate - Invoked when you discover the peripheral's available services.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService *service in peripheral.services) {
        NSLog(@"Discovered service: %@", service.UUID);
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

// Invoked when the characteristics of a specified service is discovered.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if ([service.UUID isEqual:[CBUUID UUIDWithString:FLEXECG_SERVICE_UUID]])  {
        for (CBCharacteristic *aChar in service.characteristics)
        {
            // Request data update notifications
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:FLEXECG_CHAR_UUID]]) {
                [self.flexECGPeripheral setNotifyValue:YES forCharacteristic:aChar];
                NSLog(@"Found data transmission characteristic");
            }
        }
    }
}

// Invoked when you retrieve a specified characteristic's value, or when the peripheral device notifies your app that the characteristic's value has changed.
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    // Updated value for ecg measurement received
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:FLEXECG_CHAR_UUID]]) {
        [self getFlexECGData:characteristic error:error];
    }
    
    // Add your constructed device information to your UITextView
    //self.deviceInfo.text = [NSString stringWithFormat:@"%@\n%@\n", self.connected, self.flexECGDeviceData];
    
}

// Instance method to get the ECG information
- (void) getFlexECGData:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"%@", characteristic.value);
    NSData *data = [characteristic value];
    const uint16_t *netByteOrderSample;
    uint16_t sample;
    
    for(int i = 2; i < 20; i = i + 2) {
        NSRange range = { i, 2 };                           //specify index and 2-byte length of data object in packet
        NSData *sampleObj = [data subdataWithRange:range];  //create two-byte data object
        netByteOrderSample = [sampleObj bytes];             //get bytes from that data object
        sample = CFSwapInt16LittleToHost(*(uint16_t *)netByteOrderSample); //swap byte order
        if( sample != 0xffff ) {      //ignore bit-filled samples
            NSLog(@"%hu", sample);
            [self.dataSource.sampleArray addObject:[NSNumber numberWithUnsignedShort:sample]];
        }
        
    }
    
    return;
}

@end

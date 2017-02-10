//
//  BLEController.h
//  FlexECG
//
//  Created by Jules Agee on 2/7/17.
//  Copyright © 2017 Jules Agee & Peter Richie. All rights reserved.
//

#ifndef BLEController_h
#define BLEController_h

#import "FilteredDataSource.h"

@import CoreBluetooth;

@interface BLEController : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>;

#define FLEXECG_SERVICE_UUID @"0000F00D-1212-EFDE-1523-785FEF13D123"
#define FLEXECG_CHAR_UUID @"0000BEEF-1212-EFDE-1523-785FEF13D123"

// Objects
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral     *flexECGPeripheral;

// Properties to hold data characteristics for the peripheral device
@property (nonatomic, strong) NSString   *connected;
@property (nonatomic, strong) NSString   *flexECGDeviceData;

// Property for DataSource object
@property (nonatomic, weak) FilteredDataSource *dataSource;

// Instance method to get the ECG information
- (void) getFlexECGData:(CBCharacteristic *)characteristic error:(NSError *)error;


@end

#endif /* BLEController_h */

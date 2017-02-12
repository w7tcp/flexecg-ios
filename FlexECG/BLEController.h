//
//  BLEController.h
//  FlexECG
//
//  Created by Jules Agee on 2/7/17.
//
//  Some of the code in this file was taken from the Bluetooth tutorial at https://www.raywenderlich.com and used with
//  permission under the MIT license as described below. Copyright © 2016 Razeware LLC. 
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software to deal in the Software
//  without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute,
//  sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
//  Software.
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//  WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
//  OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//  All other code Copyright © 2017 Jules Agee & Peter Richie. All rights reserved.
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
@property (nonatomic, strong) NSNumber   *connected;
@property (nonatomic, strong) NSString   *status;
@property (nonatomic, strong) NSString   *flexECGDeviceData;

// Property for DataSource object
@property (nonatomic, weak) FilteredDataSource *dataSource;

// Instance method to get the ECG information
- (void) getFlexECGData:(CBCharacteristic *)characteristic error:(NSError *)error;


@end

#endif /* BLEController_h */

//
//  ViewController.h
//  FlexECG
//
//  Created by Jules Agee on 2/2/17.
//  Copyright © 2017 Jules Agee & Peter Richie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "FilteredDataSource.h"
#import "BLEController.h"

@import CoreBluetooth;
@import QuartzCore;

@interface ViewController : UIViewController <CPTScatterPlotDelegate>

// Properties for your Object controls
@property (nonatomic, weak) IBOutlet UIView *ecgView;
@property (nonatomic, weak) IBOutlet UITextView  *deviceInfo;

// Property for DataSource object
@property (nonatomic, strong) FilteredDataSource *dataSource;

// Property for BLEController object
@property (nonatomic, strong) BLEController *bleController;

// Property for Graph object
@property (nonatomic, strong) CPTXYGraph *graph;

@property (nonatomic, strong) NSTimer *timer;

-(void)onTimerTick;

@end



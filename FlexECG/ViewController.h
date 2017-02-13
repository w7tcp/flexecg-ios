//
//  ViewController.h
//  FlexECG
//
//  Created by Jules Agee on 2/2/17.
//  Copyright © 2017 Jules Agee & Peter Richie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "CorePlot-CocoaTouch.h"
#import "FilteredDataSource.h"
#import "BLEController.h"

@import CoreBluetooth;
@import QuartzCore;

@interface ViewController : UIViewController <CPTScatterPlotDelegate, MFMailComposeViewControllerDelegate>

// Object controls
@property (nonatomic, weak) IBOutlet UIView *ecgView;
@property (nonatomic, weak) IBOutlet UILabel *connStatus;

// DataSource object
@property (nonatomic, strong) FilteredDataSource *dataSource;

// Bluetooth Controller object
@property (nonatomic, strong) BLEController *bleController;

// Core Plot Graph
@property (nonatomic, strong) CPTXYGraph *graph;

// Graph update timer
@property (nonatomic, strong) NSTimer *timer;

// buttons
@property (weak, nonatomic) IBOutlet UIButton *stopStartButton;
@property (weak, nonatomic) IBOutlet UIButton *clearDataButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;

-(void)onTimerTick;

@end



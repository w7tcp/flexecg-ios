//
//  ViewController.m
//  FlexECG
//
//  Created by Jules Agee on 2/2/17.
//  Copyright © 2017 Jules Agee & Peter Richie. All rights reserved.
//

#import "ViewController.h"
#import <Foundation/Foundation.h>

#define START_POINT 0
#define END_POINT 575.0

#define X_VAL @"X_VAL"
#define Y_VAL @"Y_VAL"

@implementation ViewController

@synthesize graph;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    // Clear out textView
    [self.deviceInfo setText:@""];
    [self.deviceInfo setTextColor:[UIColor greenColor]];
    [self.deviceInfo setBackgroundColor:[UIColor blackColor]];
    [self.deviceInfo setFont:[UIFont fontWithName:@"Futura-CondensedMedium" size:25]];
    [self.deviceInfo setUserInteractionEnabled:NO];
    
    FilteredDataSource *dataSource = [[FilteredDataSource alloc] init];
    self.dataSource = dataSource;
    
    BLEController *bleController = [[BLEController alloc] init];
    self.bleController = bleController;
    [bleController setDataSource:(dataSource)];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(onTimerTick) userInfo:nil repeats:YES];
    
    double xAxisStart = START_POINT;
    double xAxisLength = END_POINT - START_POINT;
    
    double maxY = 1024;
    double yAxisStart = 0;
    double yAxisLength = maxY;
    
    CPTGraphHostingView *hostingView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(00,30,570,300)];
    [self.view addSubview:hostingView];
    graph = [[CPTXYGraph alloc] initWithFrame:hostingView.bounds];
    
    hostingView.hostedGraph = graph;
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithDouble:xAxisStart]
                                                    length:[NSNumber numberWithDouble:xAxisLength]];
    
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithDouble:yAxisStart]
                                                    length:[NSNumber numberWithDouble:yAxisLength]];
    
    CPTScatterPlot *ecgScatterPlot = [[CPTScatterPlot alloc] initWithFrame:[graph bounds]];
    [ecgScatterPlot setDelegate:self];
    [ecgScatterPlot setDataSource:self.dataSource];
    
    [[self graph] addPlot:ecgScatterPlot];
    
    CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    [graph applyTheme:theme];
    
    CPTMutableLineStyle *mainPlotLineStyle = [[ecgScatterPlot dataLineStyle] mutableCopy];
    [mainPlotLineStyle setLineWidth:3.0f];
    [mainPlotLineStyle setLineColor:[CPTColor colorWithCGColor:[[UIColor greenColor] CGColor]]];
    [ecgScatterPlot setDataLineStyle:mainPlotLineStyle];
    
    CPTScatterPlot *dataSourceLinePlot = [[CPTScatterPlot alloc] init];
    
    [graph addPlot:dataSourceLinePlot];
    graph.axisSet = nil;
   // [[graph defaultPlotSpace] setAllowsUserInteraction:TRUE];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.05 target:self selector:@selector(onTimerTick) userInfo:nil repeats:YES];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    
    [self.timer invalidate];
}


-(void)onTimerTick{
 
    [graph reloadData];
}



@end

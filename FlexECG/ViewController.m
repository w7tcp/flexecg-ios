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
#define END_POINT 600.0

#define X_VAL @"X_VAL"
#define Y_VAL @"Y_VAL"

@implementation ViewController

@synthesize graph;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    FilteredDataSource *dataSource = [[FilteredDataSource alloc] init];
    self.dataSource = dataSource;
    
    BLEController *bleController = [[BLEController alloc] init];
    self.bleController = bleController;
    [bleController setDataSource:(dataSource)];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(onTimerTick) userInfo:nil repeats:YES];
    
    double xAxisStart = START_POINT;
    double xAxisLength = END_POINT - START_POINT;
    
    double maxY = 1024;
    double yAxisStart = -5;
    double yAxisLength = maxY + 5;
    
    [self.ecgView setFrame:self.ecgView.bounds];
    CPTGraphHostingView *hostingView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.ecgView.bounds),CGRectGetMinY(self.ecgView.bounds)+20,CGRectGetMaxX(self.ecgView.bounds),CGRectGetMaxY(self.ecgView.bounds)+10)];
    
    //CPTGraphHostingView *hostingView = [[CPTGraphHostingView alloc] initWithFrame:self.ecgView.bounds];
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
    [mainPlotLineStyle setLineWidth:1.0f];
    [mainPlotLineStyle setLineColor:[CPTColor colorWithCGColor:[[UIColor greenColor] CGColor]]];
    [ecgScatterPlot setDataLineStyle:mainPlotLineStyle];
    
    CPTScatterPlot *dataSourceLinePlot = [[CPTScatterPlot alloc] init];
    
    [graph addPlot:dataSourceLinePlot];
    graph.axisSet = nil;
    // [[graph defaultPlotSpace] setAllowsUserInteraction:TRUE];
    
    // set up KVO observation of changes in BLE controller property values
    [self.bleController addObserver:self forKeyPath:@"connected" options:kNilOptions context:Nil];
    
}

// "connected" BLE controller property update handler
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object change:(NSDictionary *)change
                       context:(void *)context
{
    if ( [object isEqual:self.bleController] ) {
        if ( [keyPath isEqualToString:@"connected"] ) {
            [self.connStatus setText:[self.bleController status]];
            if (self.bleController.connected == [NSNumber numberWithBool:YES]) {
                [self.stopStartButton setTitle:@"Stop" forState:UIControlStateNormal];
            } else {
                [self.stopStartButton setTitle:@"Start" forState:UIControlStateNormal];
            }
        }
    }

}

- (void)dealloc
{
    [self.bleController removeObserver:self forKeyPath:@"connected" context:Nil];
}

// clear data button event handler
- (IBAction)clearData:(id)sender
{
    self.dataSource = [self.dataSource init];
}

// start/stop button event handler
- (IBAction)startStopBLE:(id)sender
{
    if([self.bleController.flexECGPeripheral state] == CBPeripheralStateConnected)
    {
        [self.bleController.centralManager cancelPeripheralConnection:self.bleController.flexECGPeripheral];
        [sender setTitle:@"Start" forState:UIControlStateNormal];
    } else {
        self.bleController.status = @"Disconnected, searching...";
        [self.bleController.centralManager scanForPeripheralsWithServices:nil options:nil];
        [sender setTitle:@"Stop" forState:UIControlStateNormal];
    }
}

//not implemented yet -- send all data via email
- (IBAction)sendEmail:(id)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// set up timer for graph refresh
- (void)viewWillAppear:(BOOL)animated
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.03 target:self selector:@selector(onTimerTick) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.timer invalidate];
}

-(void)onTimerTick
{
    [graph reloadData];
}



@end

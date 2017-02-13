//
//  FilteredDataSource.m
//  FlexECG
//
//  Created by Jules Agee on 2/7/17.
//  Copyright © 2017 Jules Agee & Peter Richie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilteredDataSource.h"
#import "CorePlot-CocoaTouch.h"

@implementation FilteredDataSource : NSObject

- (FilteredDataSource *) init
{
    // initialize data arrays
    self.sampleArray = [[NSMutableArray alloc] init];
    self.FIRArray = [[NSMutableArray alloc] init];
    
    // zero all entries in plotArray so it can be graphed immediately
    self.plotArray = [[NSMutableArray alloc] init];
    for(int i = 0; i <= 600; i++){
        [self.plotArray addObject:[NSNumber numberWithInt:0]];
    }
    return self;
}


- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return 600;
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    switch (fieldEnum)
    {
        case CPTScatterPlotFieldX:
            return [NSNumber numberWithInteger:index];
            break;
        case CPTScatterPlotFieldY:
            return [self.plotArray objectAtIndex:index];
            break;
            
        default:
            break;
    }
    
    return nil;
}

- (void) appendData:(NSNumber *)sample
{
    [self.sampleArray addObject:sample]; // keep all original sample data
    [self.FIRArray addObject:sample];
    if ([self.FIRArray count] > 4)           // keep only last four objects in FIRArray
        [self.FIRArray removeObjectAtIndex:0];

    int average = 0;
    for (id obj in self.FIRArray) {
        average += [obj intValue];
    }
    
    // insert filtered values at end of plotArray, removing value at beginning
    [self.plotArray insertObject:[NSNumber numberWithInt:average/[self.FIRArray count]] atIndex:600];
    [self.plotArray removeObjectAtIndex:0];
    
    
}
@end

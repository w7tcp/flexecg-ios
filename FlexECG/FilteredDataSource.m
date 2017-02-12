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
    self.sampleArray = [[NSMutableArray alloc] init];
    for(int i = 0; i <= 600; i++){
        [self.sampleArray addObject:[NSNumber numberWithInt:0]];
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
            return [self.sampleArray objectAtIndex:[self.sampleArray count] - 600 + index];
            break;
            
        default:
            break;
    }
    
    return nil;
}

@end

//
//  FilteredDataSource.h
//  FlexECG
//
//  Created by Jules Agee on 2/7/17.
//  Copyright © 2017 Jules Agee & Peter Richie. All rights reserved.
//

#ifndef FilteredDataSource_h
#define FilteredDataSource_h
#import "CorePlot-CocoaTouch.h"

@interface FilteredDataSource : NSObject <CPTPlotDataSource>

// array of all sample data received
@property (nonatomic, strong) NSMutableArray * _Nullable sampleArray;

// array of data to visualize in the displayed graph
@property (nonatomic, strong) NSMutableArray * _Nullable plotArray;

// array for saving FIR filter state
@property (nonatomic, strong) NSMutableArray * _Nullable FIRArray;

- (NSUInteger) numberOfRecordsForPlot:		(nonnull CPTPlot *) 	plot;

- (NSNumber * _Nonnull)numberForPlot:(CPTPlot * _Nonnull)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index;

- (void) appendData:(NSNumber * _Nullable)sample;
@end

#endif /* FilteredDataSource_h */

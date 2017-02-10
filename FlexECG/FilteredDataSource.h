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

@property (nonatomic, strong) NSMutableArray * _Nullable sampleArray;

- (NSUInteger) numberOfRecordsForPlot:		(nonnull CPTPlot *) 	plot;

- (NSNumber * _Nonnull)numberForPlot:(CPTPlot * _Nonnull)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index;

@end

#endif /* FilteredDataSource_h */

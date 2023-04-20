//
//  AMapPOISearchResponse_AllResults.h
//  AwesomeProject
//
//  Created by xgb on 2023/4/18.
//

#import <Foundation/Foundation.h>
#import "AMapPOISearchResponse_OnePage.h"

NS_ASSUME_NONNULL_BEGIN

@interface AMapPOISearchResponse_AllResults : NSObject

@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, strong) NSMutableArray<AMapPOISearchResponse_OnePage*> *allPages;

@end

NS_ASSUME_NONNULL_END

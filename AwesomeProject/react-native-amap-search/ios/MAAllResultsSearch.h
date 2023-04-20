//
//  MAAllResultsSearch.h
//  AwesomeProject
//
//  Created by xgb on 2023/4/18.
//

#import <Foundation/Foundation.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "AMapPOISearchResponse_AllResults.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^MAKeyWordsPOISearchCallback)(AMapPOISearchResponse_AllResults* result);

@interface MAAllResultsSearch : NSObject

@property (nonatomic, strong) AMapSearchAPI *searchAPI;

- (void)searchAllPOIsWith:(AMapPOIKeywordsSearchRequest *)req resultCallback:(MAKeyWordsPOISearchCallback)resultCallback;

@end

NS_ASSUME_NONNULL_END

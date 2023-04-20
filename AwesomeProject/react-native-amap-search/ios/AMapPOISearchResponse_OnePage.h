//
//  AMapPOISearchResponse_OnePage.h
//  AwesomeProject
//
//  Created by xgb on 2023/4/18.
//

#import <Foundation/Foundation.h>
#import <AMapSearchKit/AMapSearchKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AMapPOISearchResponse_OnePage : NSObject

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger status; //-1:未开始 0:成功 1:失败
@property (nonatomic, strong) NSArray<AMapPOI*> *pois;

@end

NS_ASSUME_NONNULL_END

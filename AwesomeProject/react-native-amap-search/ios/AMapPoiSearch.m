//
//  AMapPoiSearch.m
//  AwesomeProject
//
//  Created by xgb on 2023/4/18.
//

#import "AMapPoiSearch.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "MAAllResultsSearch.h"
#import <React/RCTAssert.h>

@interface AMapPoiSearch() <RCTBridgeModule>

@property (nonatomic, strong) MAAllResultsSearch *search;

@end

@implementation AMapPoiSearch

RCT_EXPORT_MODULE(AMapPoiSearch)

- (NSArray<NSString *> *)supportedEvents
{
  return @[
    
  ];
}

RCT_EXPORT_METHOD(init:(NSString *)key) {
  if (key.length == 0) {
    RCTAssert(key, @"map key can not be null");
    return;;
  }
  [MAMapView updatePrivacyAgree:AMapPrivacyAgreeStatusDidAgree];
  [MAMapView updatePrivacyShow:AMapPrivacyShowStatusDidShow privacyInfo:AMapPrivacyInfoStatusDidContain];
  [AMapServices sharedServices].apiKey = (NSString *)key;
}

RCT_EXPORT_METHOD(search:(nonnull NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
  
//  dispatch_async(dispatch_get_main_queue(), ^{
//
//  });
  
  NSString *searchKey = params[@"key"];
  if (searchKey.length == 0) {
    if(reject) {
      reject(@"-1", @"key can not be null", nil);
      return;
    }
  }
  AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
  request.keywords = searchKey;
  
  NSString *city = params[@"city"];
  if(city.length > 0) {
    request.city = city;
  }
  
  NSString *longitude = params[@"longitude"];
  NSString *latitude = params[@"latitude"];
  if(longitude.length > 0 && latitude.length > 0) {
    AMapGeoPoint *location = [AMapGeoPoint new];
    location.longitude = [longitude doubleValue];
    location.latitude = [latitude doubleValue];
    request.location = location;
  }
  
  __weak typeof(self) weakSelf = self;
  [self.search searchAllPOIsWith:request resultCallback:^(AMapPOISearchResponse_AllResults *result) {
    NSMutableArray *arr = [weakSelf onPoiSearchDone:result];
    if(resolve) {
      resolve(arr);
    }
  }];
}

- (NSMutableArray *)onPoiSearchDone:(AMapPOISearchResponse_AllResults *)allResult {
    
    NSMutableArray *poiAnnotations = [NSMutableArray array];
    for(AMapPOISearchResponse_OnePage *page in allResult.allPages) {
        [page.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
          //TODO:xgb 扩展取值
          NSString *name = obj.name;
          if(name.length > 0) {
            NSDictionary *dic = @{@"name": name};
            [poiAnnotations addObject:dic];
          }
        }];
    }
  NSLog(@"xgb:count:%lu",(unsigned long)poiAnnotations.count);
  return poiAnnotations;
}

- (MAAllResultsSearch *)search {
  if(!_search) {
    _search = [MAAllResultsSearch new];
  }
  return _search;
}

@end

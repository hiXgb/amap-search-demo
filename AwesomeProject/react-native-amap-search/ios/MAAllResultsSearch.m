//
//  MAAllResultsSearch.m
//  AwesomeProject
//
//  Created by xgb on 2023/4/18.
//

#import "MAAllResultsSearch.h"

@interface MAAllResultsSearch ()<AMapSearchDelegate>
@property (nonatomic, copy) MAKeyWordsPOISearchCallback resultCallback;
@property (nonatomic, strong) AMapPOIKeywordsSearchRequest *firstReq;
@property (nonatomic, strong) AMapPOISearchResponse_AllResults *allAroundPoiResults;

@end

@implementation MAAllResultsSearch

- (void)searchAllPOIsWith:(AMapPOIKeywordsSearchRequest *)req resultCallback:(MAKeyWordsPOISearchCallback)resultCallback {
    self.firstReq = req;
    self.resultCallback = resultCallback;
    [self.searchAPI AMapPOIKeywordsSearch:req];
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    BOOL allFinished = YES;
    
    if(self.firstReq == request) {
        self.allAroundPoiResults = [[AMapPOISearchResponse_AllResults alloc] init];
        self.allAroundPoiResults.offset = request.offset;
        self.allAroundPoiResults.totalCount = response.count;
        self.allAroundPoiResults.allPages = [NSMutableArray array];
        
        AMapPOISearchResponse_OnePage *page = [[AMapPOISearchResponse_OnePage alloc] init];
        page.pageNum = 1;
        page.pois = response.pois;
        page.status = 0;
        page.offset = request.offset;
        [self.allAroundPoiResults.allPages addObject:page];
        
        NSInteger pageCount = response.count / request.offset;
        if(response.count % request.offset > 0) {
            pageCount += 1;
        }
        
        if(pageCount > 1) {
            allFinished = NO;
        }
        
        for(int i = 2; i <= pageCount; ++i) {
            AMapPOISearchResponse_OnePage *page = [[AMapPOISearchResponse_OnePage alloc] init];
            page.pageNum = i;
            page.status = -1;
            page.offset = request.offset;
            [self.allAroundPoiResults.allPages addObject:page];
            
            AMapPOIKeywordsSearchRequest *remainReq = [[AMapPOIKeywordsSearchRequest alloc] init];
            remainReq.keywords = self.firstReq.keywords;
            remainReq.location = self.firstReq.location;
            remainReq.city = self.firstReq.city;
            remainReq.cityLimit = self.firstReq.cityLimit;
            
            remainReq.types = self.firstReq.types;
            remainReq.sortrule = self.firstReq.sortrule;
            
            remainReq.page = i;
            remainReq.offset = self.firstReq.offset;
            remainReq.showFieldsType = self.firstReq.showFieldsType;
            
            [self.searchAPI AMapPOIKeywordsSearch:remainReq];
        }
        
    } else {
        NSInteger pageNum = request.page;
        AMapPOISearchResponse_OnePage *page = [self.allAroundPoiResults.allPages objectAtIndex:pageNum - 1];
        page.status = 0;
        page.pois = response.pois;
        
        for(AMapPOISearchResponse_OnePage *page in self.allAroundPoiResults.allPages) {
            if(page.status == -1) {
                allFinished = NO;
                break;
            }
        }
        
    }
    
    if(allFinished) {
        if(self.resultCallback) {
            self.resultCallback(self.allAroundPoiResults);
        }
    }
    
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
//    NSLog(@"Error: %@ - %@", error, [ErrorInfoUtility errorDescriptionWithCode:error.code]);
    
    AMapPOISearchBaseRequest *req = (AMapPOISearchBaseRequest *)request;
    NSInteger pageNum = req.page;
    AMapPOISearchResponse_OnePage *page = [self.allAroundPoiResults.allPages objectAtIndex:pageNum - 1];
    page.status = 1;
}

- (AMapSearchAPI *)searchAPI {
  if (!_searchAPI) {
    _searchAPI = [[AMapSearchAPI alloc] init];
    _searchAPI.delegate = self;
  }
  return _searchAPI;
}


@end

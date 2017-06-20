//
//  ApiHeader.h
//  jianzhi
//
//  Created by Jiangwei on 15/4/18.
//  Copyright (c) 2015年 li. All rights reserved.
//

#ifndef ApiHeader_h
#define ApiHeader_h

//#define kMainHeader   @"http://mobile.ximalaya.com/mobile/others/ca/album/track/360163/true/1/30?device=iPhone"


//http://mobile.ximalaya.com/mobile/discovery/v2/category/keyword/albums?calcDimension=hot&categoryId=3&device=iPhone&keywordId=407&pageId=1&pageSize=20&statEvent=pageview%2Fcategory%40%E6%9C%89%E5%A3%B0%E4%B9%A6&statModule=%E6%9C%89%E5%A3%B0%E4%B9%A6&statPage=tab%40%E5%8F%91%E7%8E%B0_%E5%88%86%E7%B1%BB&status=0&version=5.4.93

//#define kAlbumList @"http://mobile.ximalaya.com/mobile/discovery/v1/category/album"

#define kAlbumList @"http://mobile.ximalaya.com/mobile/discovery/v3/rankingList/album?device=iPad&pageId=1&pageSize=20&rankingListId=21&scale=3&target=main&version=6.3.6"

//#define kAlbumList @"http://mobile.ximalaya.com/mobile/discovery/v2/category/keyword/albums?calcDimension=hot&categoryId=3&device=iPhone&keywordId=407&pageId=1&pageSize=20&statEvent=pageview%2Fcategory%40%E6%9C%89%E5%A3%B0%E4%B9%A6&statModule=%E6%9C%89%E5%A3%B0%E4%B9%A6&statPage=tab%40%E5%8F%91%E7%8E%B0_%E5%88%86%E7%B1%BB&status=0&version=5.4.93"
#define kMainHeader   @"http://mobile.ximalaya.com/mobile/others/ca/album/track/"

//http://mobile.ximalaya.com/mobile/discovery/v3/rankingList/album?device=iPhone&pageId=1&pageSize=20&rankingListId=21&scale=2&target=main&version=5.4.33

#define kRankList @"http://mobile.ximalaya.com/mobile/discovery/v3/rankingList/album"

#define kList @"http://mobile.ximalaya.com/mobile/v1/artist/albums?device=iPhone&toUid=34299871"

//#define kSearchList @"http://search.ximalaya.com/front/v1?condition=play&core=album&device=iPhone&kw=%E6%96%97%E7%A0%B4%E8%8B%8D%E7%A9%B9&live=true&paidFilter=false&rows=20&version=5.4.33"

#pragma mark- 专辑列表页

#define xAlbumList @"http://ts.pk2game.com/TsService.asmx/GetHomeContent?apikey=lygames_0953&appkey=JXWYYS338"

#pragma mark - 专辑内页列表

#define xContentList @"http://ts.pk2game.com/TsService.asmx/GetTsContent?apikey=lygames_0953"


#define kAlbumID @"12"
#define kAlbumName @"人民的名义"
#define kVersion @"5.4.93"

#define kRankingListId  @"21"

#define kMainIDArr [[NSArray alloc]initWithObjects:@"4355797",@" 3689163", @"5218428",@"4071527", @"3299517",nil]


#define kDevice @"?device=iPhone"

#endif

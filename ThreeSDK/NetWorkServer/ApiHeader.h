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

#define kAlbumList @"http://mobile.ximalaya.com/mobile/discovery/v1/category/album"
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
#define kAlbumName @"相声大全"
#define kVersion @"5.4.87"
#define kRankingListId  @"21"

#define kMainIDArr [[NSArray alloc]initWithObjects:@"4355797",@" 3689163", @"5218428",@"4071527", @"3299517",nil]


#define kDevice @"?device=iPhone"

#endif

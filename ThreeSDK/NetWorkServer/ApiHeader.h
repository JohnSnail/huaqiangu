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

//#define kRankList @"http://mobile.ximalaya.com/mobile/discovery/v3/rankingList/album"

#define kList @"http://mobile.ximalaya.com/mobile/v1/artist/albums?device=iPhone&toUid=34299871"

//#define kSearchList @"http://search.ximalaya.com/front/v1?condition=play&core=album&device=iPhone&kw=%E6%96%97%E7%A0%B4%E8%8B%8D%E7%A9%B9&live=true&paidFilter=false&rows=20&version=5.4.33"

#pragma mark- 专辑列表页

#define xAlbumList @"http://ts.pk2game.com/TsService.asmx/GetHomeContent?apikey=lygames_0953&appkey=JXWYYS338"

#pragma mark - 专辑内页列表

#define xContentList @"http://ts.pk2game.com/TsService.asmx/GetTsContent?apikey=lygames_0953"

#define xBOOK @"http://appwk.baidu.com/nahome/novel/recdetail?na_uncheck=1&opid=wk_na&bid=7&fr=7&listId=2551&wh=480%2C800&summary=0&pn=0&rn=20&pid=1&_=1486608646403&callback=jsonp1"

#define xBOOKCONTENT @"http://api.bifong.com/t/follow_book/351506?devicetype=IOS&apptype=xs&uuid=0EDE2A52-0215-433E-ABC3-24574C1E6A9E&appid=sqmfxs_new2&net_status=1&open_udid=89d054cb5764db6ea827b96e895b6caf94f0d72c&ver=1.0&format=json&deviceinfo=iPhone9,1&sversion=10.2.1&invite_code=21711107"

#define kAlbumID @"12"
#define kAlbumName @"郭德纲"
#define kVersion @"5.4.75"
#define kRankingListId  @"21"

#define kMainIDArr [[NSArray alloc]initWithObjects:@"4355797",@" 3689163", @"5218428",@"4071527", @"3299517",nil]


#define kDevice @"?device=iPhone"

#endif

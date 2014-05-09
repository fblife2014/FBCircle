//
//  SzkLoadData.m
//  FBCircle
//
//  Created by 史忠坤 on 14-5-8.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "SzkLoadData.h"


@interface SzkLoadData (){
    
    NSMutableData *_data;
}

@end


@implementation SzkLoadData
-(void)SeturlStr:(NSString *)str block:(myBlock)block{
    
    _testBlocksbl=block;
    _string_url=str;
    
    NSLog(@"urlstr=====%@",_string_url);
    
    NSURL *url = [NSURL URLWithString:_string_url];
    NSURLRequest * req = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:req delegate:self];
 
    
}
//连接接受响应，表示成功建立连接
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    _data = [NSMutableData data];
}
//连接接受数据
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
 
    [_data appendData:data];
}
//连接完成

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    // NSArray *dicinfo=[_data objectFromJSONData];
    self.mydicinfo=[_data objectFromJSONData];
    
    if ([[self.mydicinfo objectForKey:@"errcode"] integerValue]==0) {
        NSArray *array_=[self.mydicinfo objectForKey:@"datainfo"];
        
        _testBlocksbl(array_,@"noerror");
        
    }else{
        
        _testBlocksbl([NSArray array],@"error");
        
    }
    
}
//请求失败的处理
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    _testBlocksbl([NSArray array],@"error");
    
}



@end

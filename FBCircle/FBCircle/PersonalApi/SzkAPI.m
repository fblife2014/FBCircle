//
//  SzkAPI.m
//  FBCircle
//
//  Created by 史忠坤 on 14-5-7.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "SzkAPI.h"
#import <AddressBook/AddressBook.h>

#import <AddressBookUI/AddressBookUI.h>

@implementation SzkAPI

#define NORESAULT @"noresault"
#pragma mark--获取通讯录放到一个数组里面，包含名字和号码
+(NSMutableArray *)AccesstoAddressBookAndGetDetail{
    NSMutableArray *arr_info=[NSMutableArray array];
    
    ABAddressBookRef tmpAddressBook=nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
        tmpAddressBook=ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema=dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool greanted, CFErrorRef error){
            dispatch_semaphore_signal(sema);
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else
    {
        tmpAddressBook =ABAddressBookCreate();
    }
    if (tmpAddressBook==nil) {
        return [NSMutableArray array];
    }
    
    
    
    
    
    NSArray* tmpPeoples = (NSArray*)CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(tmpAddressBook));
    
    
    for(id tmpPerson in tmpPeoples)
        
    {
        
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        
        //获取的联系人单一属性:First name
        
        NSString* tmpFirstName = (NSString*)CFBridgingRelease(ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonFirstNameProperty));
        
      tmpFirstName=  [self changestrkongge:tmpFirstName];
      
        
        if (tmpFirstName.length!=0) {
            [dic setObject:tmpFirstName forKey:@"tmpFirstName"];

        }else{
        
            [dic setObject:NORESAULT forKey:@"tmpFirstName"];

        
        }
        
        
        //获取的联系人单一属性:Last name
        
        NSString* tmpLastName = (NSString*)CFBridgingRelease(ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonLastNameProperty));
        
        tmpLastName=  [self changestrkongge:tmpLastName];

        
        if (tmpLastName.length!=0) {
            [dic setObject:tmpLastName forKey:@"tmpLastName"];

        }else{
            [dic setObject:NORESAULT forKey:@"tmpLastName"];

        
        }
        
        
        
        //获取的联系人单一属性:Generic phone number
        
        ABMultiValueRef tmpPhones = ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonPhoneProperty);
        
        for(NSInteger j = 0; j < ABMultiValueGetCount(tmpPhones); j++)
            
        {
            
            NSString* tmpPhoneIndex = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(tmpPhones, j));
            tmpPhoneIndex=[self changestrkongge:tmpPhoneIndex];
            
            if (tmpPhoneIndex.length!=0) {
                [dic setObject:tmpPhoneIndex forKey:[NSString stringWithFormat:@"tmpPhoneIndex%ld",(long)j]];

            }else{
            
                [dic setObject:NORESAULT forKey:[NSString stringWithFormat:@"tmpPhoneIndex%ld",(long)j]];

            
            }
            
        }
        
        [arr_info addObject:dic];
        CFRelease(tmpPhones);
        
    }
    
    
    return  arr_info;

}
//解决名字空格的问题

+(NSString *)changestrkongge:(NSString*)_receivestr{
    NSString *str=[NSString string];
    while ([_receivestr rangeOfString:@" "].length) {
        _receivestr=[_receivestr stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    str=_receivestr;
    
    return str;
    
}




@end

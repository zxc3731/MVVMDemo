//
//  ETViewModel.h
//  ElectronicTradingApp
//
//  Created by LZJ on 16/1/19.
//  Copyright © 2016年 LZJ. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol ETViewModelDelegate <NSObject>
@required
- (UIViewController *)returnThePushVC:(id)pushMsg;
@end
@interface ETViewModel : NSObject<ETViewModelDelegate>
@property (nonatomic, strong) RACSubject *requestBeforeObject;
@property (nonatomic, strong) RACSubject *successObject;
@property (nonatomic, strong) RACSubject *failureObject;
@property (nonatomic, strong) RACSubject *errorObject;

@property (nonatomic, strong) NSString *vcTitle;
@property (nonatomic, strong) NSString *vcLeftItemImage;
@end


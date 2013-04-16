//
//  DummyClass.h
//  FunctionalCategories
//
//  Created by Jan-Peter Zurek on 1/18/13.
//  Copyright (c) 2013 Jan-Peter Zurek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DummyClass : NSObject

@property NSString *firstName;
@property NSString *lastName;
@property NSInteger age;

- (id) initWithName:(NSString *)
 firstName lastName:(NSString *)
    lastName andAge:(int)age;

@end

//
//  DummyClass.m
//  FunctionalCategories
//
//  Created by Jan-Peter Zurek on 1/18/13.
//  Copyright (c) 2013 Jan-Peter Zurek. All rights reserved.
//

#import "DummyClass.h"

@implementation DummyClass

- (id)initWithName:(NSString *)firstName
          lastName:(NSString *)lastName
            andAge:(int)age
{
    if (self = [super init]) {
        self.firstName = firstName;
        self.lastName = lastName;
        self.age = age;
    }
    
    return self;
}

@end

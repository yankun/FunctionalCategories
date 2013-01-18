//
//  FunctionalCategoriesTests.m
//  FunctionalCategoriesTests
//
//  Created by Jan-Peter Zurek on 1/18/13.
//  Copyright (c) 2013 Jan-Peter Zurek. All rights reserved.
//

#import "FunctionalCategoriesTests.h"
#import "FunctionalCategories.h"
#import "DummyClass.h"

@implementation FunctionalCategoriesTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testSelect
{
    DummyClass *d1 = [[DummyClass alloc] init];
    d1.firstName = @"Max";
    d1.lastName = @"Mustermann";
    d1.age = 32;
    
    DummyClass *d2 = [[DummyClass alloc] init];
    d2.firstName = @"Franz";
    d2.lastName = @"Schlemmermayer";
    d2.age = 45;
    
    NSArray *array = [NSArray arrayWithObjects:d1, d2, nil];
    
    NSArray *selectedArray = [array selectUsingBlock:^NSString *(DummyClass *object) {
        return object.firstName;
    }];
    
    STAssertEquals([selectedArray objectAtIndex:0], d1.firstName, @"");
    STAssertEquals([selectedArray objectAtIndex:1], d2.firstName, @"");
}

@end

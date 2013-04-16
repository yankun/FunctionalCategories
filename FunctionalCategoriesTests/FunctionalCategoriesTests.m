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
    
    self.testObject1 = [[DummyClass alloc] initWithName:@"Max"
                                               lastName:@"Mustermann"
                                                 andAge:32];
    
    self.testObject2 = [[DummyClass alloc] initWithName:@"Franz"
                                               lastName:@"Schlemmermayer"
                                                 andAge:45];
    
    self.testArray = @[self.testObject1, self.testObject2];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testSelect
{
    NSArray *selectedArray =
    [self.testArray select:^NSString *(DummyClass *object) {
        return object.firstName;
    }];
    
    STAssertEqualObjects([selectedArray objectAtIndex:0],
                         self.testObject1.firstName,
                         @"First element in array should equal Max.");
    
    STAssertEqualObjects([selectedArray objectAtIndex:1],
                         self.testObject2.firstName,
                         @"Second element in array should equal Franz.");
}

- (void)testWhere
{
    NSArray *whereArray =
    [self.testArray where:^Boolean(DummyClass *object) {
        return [object.firstName isEqualToString:@"Max"];
    }];
    
    STAssertTrue([whereArray count] == 1,
                 @"Returned array should contain only one element.");
    STAssertEqualObjects([whereArray objectAtIndex:0], self.testObject1,
                         @"Object at index 0 should be Max Mustermann.");
}

- (void)testMap
{
    NSArray *mapArray = [self.testArray map:^NSString *(DummyClass *object) {
        return [NSString stringWithFormat:@"%@ %@", @"Mr.", object.firstName];
    }];
    
    STAssertTrue([mapArray count] == 2, @"Mapped array should contain two elements");
    
    NSString *resultString1 = [mapArray objectAtIndex:0];
    NSString *resultString2 = [mapArray objectAtIndex:1];
    
    STAssertEqualObjects(resultString1, @"Mr. Max", @"First element should equal Mr. Max");
    STAssertEqualObjects(resultString2, @"Mr. Franz", @"First element should equal Mr. Franz");
}

- (void)testCount
{
    int count = [self.testArray countWithCondition:^Boolean(DummyClass *object) {
        return [object.firstName compare:@"Max"] == 0;
    }];
    
    STAssertTrue(count == 1, @"Count should be only 1");
}

- (void)testFirstOrNil
{    
    DummyClass *d = [self.testArray firstOrNil];
    
    STAssertEqualObjects(d, [self.testArray objectAtIndex:0],
                         @"Returned object should be the first element of the array");
}

@end

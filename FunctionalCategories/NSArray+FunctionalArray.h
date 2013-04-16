//
//  NSArray+FunctionalArray.h
//  FunctionalCategories
//
//  Created by Jan-Peter Zurek on 1/9/13.
//  Copyright (c) 2013 Jan-Peter Zurek. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *SCFunctionalCategoryErrorDomain = @"SCFunctionalCategories";
static int SCFunctionalCategoryNoSingleElementError = 0;

typedef void (^foreach_block_t)(id object);
typedef Boolean (^condition_block_t)(id object);
typedef id (^mapping_block_t)(id object);
typedef id (^selection_block_t)(id object);

@interface NSArray (FunctionalArray)

- (void)foreach:(foreach_block_t) block;
- (void)parallelForeach:(foreach_block_t) block;
- (Boolean)any:(condition_block_t) block;
- (Boolean)many:(condition_block_t) block;
- (NSArray *)where:(condition_block_t) block;
- (id)firstOrNil;
- (id)firstOrNilWithCondition:(condition_block_t)block;
- (id)singleOrNil:(NSError **)error;
- (id)singleOrNilWithCondition:(condition_block_t)block Error:(NSError **)error;
- (NSArray *)map:(mapping_block_t) block;
- (id) findLast:(condition_block_t) block;
- (NSMutableArray *)toMutableArray;
- (NSArray *)select:(selection_block_t)block;
- (int)countWithCondition:(condition_block_t)block;

@end

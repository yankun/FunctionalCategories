//
//  NSArray+FunctionalArray.h
//  FunctionalCategories
//
//  Created by Jan-Peter Zurek on 1/9/13.
//  Copyright (c) 2013 Jan-Peter Zurek. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^foreach_block_t)(id object);
typedef Boolean (^condition_block_t)(id object);
typedef id (^mapping_block_t)(id object);
typedef id (^selection_block_t)(id object);

@interface NSArray (FunctionalArray)

- (void)foreachWithBlock:(foreach_block_t) block;
- (void)foreachParallelWithBlock:(foreach_block_t) block;
- (Boolean)anyWithCondition:(condition_block_t) block;
- (Boolean)manyWithCondition:(condition_block_t) block;
- (NSArray *)whereWithCondition:(condition_block_t) block;
- (id)firstOrNil;
- (NSArray *)mapUsingBlock:(mapping_block_t) block;
- (id) findLastUsingCondition:(condition_block_t) block;
- (NSMutableArray *)toMutableArray;
- (NSArray *)selectUsingBlock:(selection_block_t)block;
- (int)countUsingCondition:(condition_block_t)block;

@end

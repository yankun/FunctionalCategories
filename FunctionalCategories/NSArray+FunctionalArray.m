//
//  NSArray+FunctionalArray.m
//  FunctionalCategories
//
//  Created by Jan-Peter Zurek on 1/9/13.
//  Copyright (c) 2013 Jan-Peter Zurek. All rights reserved.
//

#import "NSArray+FunctionalArray.h"

@implementation NSArray (FunctionalArray)

- (void)foreachWithBlock:(foreach_block_t)block
{
    for (id obj in self) {
        block(obj);
    }
}

- (void)foreachParallelWithBlock:(foreach_block_t)block
{
    
    dispatch_queue_t parallelQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_semaphore_t waitForLoop = dispatch_semaphore_create(self.count - 1);
    
    dispatch_apply(self.count, parallelQueue, ^(size_t i) {
        block([self objectAtIndex:i]);
        dispatch_semaphore_signal(waitForLoop);
    });
    
    dispatch_semaphore_wait(waitForLoop, DISPATCH_TIME_FOREVER);
}

- (NSArray *)whereWithCondition:(condition_block_t)block
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (id obj in self) {
        if (block(obj)) {
            [array addObject:obj];
        }
    }
    
    return array;
}

- (Boolean)anyWithCondition:(condition_block_t)block
{
    for (id obj in self) {
        if (block(obj)) {
            return true;
        }
    }
    
    return false;
}

- (Boolean)manyWithCondition:(condition_block_t)block
{
    int counter = 0;
    
    for (id obj in self) {
        if (block(obj)) {
            counter++;
            if (counter > 1) {
                return true;
            }
        }
    }
    
    return false;
}

- (id)firstOrNil
{
    if (self.count > 0) {
        return [self objectAtIndex:0];
    } else {
        return nil;
    }
}

- (id)findLastUsingCondition:(condition_block_t)block
{
    id result = nil;
    
    for(id obj in self) {
        if (block(obj)) {
            result = obj;
        }
    }
    
    return result;
}

- (NSArray *)mapUsingBlock:(mapping_block_t)block
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (id obj in self) {
        [array addObject:block(obj)];
    }
    
    return array;
}

- (NSMutableArray *)toMutableArray
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (id obj in self) {
        [array addObject:obj];
    }
    
    return array;
}

- (NSArray *)selectUsingBlock:(selection_block_t)block
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (id obj in self) {
        [array addObject:block(obj)];
    }
    
    return array;
}

- (int)countUsingCondition:(condition_block_t)block
{
    __block int count = 0;
    
    dispatch_queue_t parallelQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_semaphore_t waitForLoop = dispatch_semaphore_create(self.count - 1);
    
    dispatch_apply(self.count, parallelQueue, ^(size_t i) {
        if(block([self objectAtIndex:i])) {
            @synchronized(self) {
                count++;
            }
        }
        dispatch_semaphore_signal(waitForLoop);
    });
    
    dispatch_semaphore_wait(waitForLoop, DISPATCH_TIME_FOREVER);
    
    return count;
}

@end

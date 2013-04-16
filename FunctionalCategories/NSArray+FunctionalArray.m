//
//  NSArray+FunctionalArray.m
//  FunctionalCategories
//
//  Created by Jan-Peter Zurek on 1/9/13.
//  Copyright (c) 2013 Jan-Peter Zurek. All rights reserved.
//

#import "NSArray+FunctionalArray.h"

NSString *const SCFunctionalCategoryErrorDomain = @"SCFunctionlCategoryError";
int const SCFunctionalCategoryNoSingleElementError = 0;

@implementation NSArray (FunctionalArray)

- (void)foreach:(foreach_block_t)block
{
    for (id obj in self) {
        block(obj);
    }
}

- (void)parallelForeach:(foreach_block_t)block
{
    
    dispatch_queue_t parallelQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_semaphore_t waitForLoop = dispatch_semaphore_create(self.count - 1);
    
    dispatch_apply(self.count, parallelQueue, ^(size_t i) {
        block([self objectAtIndex:i]);
        dispatch_semaphore_signal(waitForLoop);
    });
    
    dispatch_semaphore_wait(waitForLoop, DISPATCH_TIME_FOREVER);
}

- (NSArray *)where:(condition_block_t)block
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (id obj in self) {
        if (block(obj)) {
            [array addObject:obj];
        }
    }
    
    return [NSArray arrayWithArray:array];
}

- (Boolean)any:(condition_block_t)block
{
    for (id obj in self) {
        if (block(obj)) {
            return true;
        }
    }
    
    return false;
}

- (Boolean)many:(condition_block_t)block
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

- (id)firstOrNilWithCondition:(condition_block_t)block
{
    for (id obj in self) {
        if (block(obj)) {
            return obj;
        }
    }
    
    return nil;
}

- (id)singleOrNil:(NSError *__autoreleasing *)error
{
    return [self _singleOrNilInArray:self Error:error];
}

- (id)singleOrNilWithCondition:(condition_block_t)block
                         Error:(NSError *__autoreleasing *)error
{
    NSArray *filterResult = [self where:block];
    
    return [self _singleOrNilInArray:filterResult Error:error];
}

- (id)_singleOrNilInArray:(NSArray *) array
                    Error:(NSError *__autoreleasing *)error
{
    if (array.count > 1) {
        if (error != NULL) {
            NSString *errDescription = NSLocalizedString(@"singleOrNilError", @"");
            NSDictionary *dict = @{ NSLocalizedDescriptionKey: errDescription };
            
            *error = [NSError errorWithDomain:SCFunctionalCategoryErrorDomain
                                         code:SCFunctionalCategoryNoSingleElementError
                                     userInfo:dict];
        }
        return nil;
    } else if (array.count == 1){
        return [array objectAtIndex:0];
    } else {
        return nil;
    }
}

- (id)findLast:(condition_block_t)block
{
    id result = nil;
    
    for(id obj in self) {
        if (block(obj)) {
            result = obj;
        }
    }
    
    return result;
}

- (NSArray *)map:(returning_block_t)block
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (id obj in self) {
        [array addObject:block(obj)];
    }
    
    return [NSArray arrayWithArray:array];
}

- (NSMutableArray *)toMutableArray
{    
    return [NSMutableArray arrayWithArray:self];
}

- (NSArray *)select:(returning_block_t)block
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (id obj in self) {
        [array addObject:block(obj)];
    }
    
    return [NSArray arrayWithArray:array];
}

- (int)countWithCondition:(condition_block_t)block
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

//
//  NSObject+BlockAdditions.h
//  HMHelperFramework
//
//  Created by Szidonia Hertely on 5/18/12.
//  Copyright (c) 2013 Halcyon Mobile. All rights reserved.
//

@interface NSObject (BlockAdditions)

- (void)performBlockOnMainThread:(void (^)(void))block;
- (void)performBlockOnMainThread:(void (^)(void))block afterDelay:(NSTimeInterval)delay;
- (void)performAsyncBlock:(void (^)(void))block;

@end

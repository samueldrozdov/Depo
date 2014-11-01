//
//  ServerRequest.m
//  Depo
//
//  Created by Phillip Ou on 11/1/14.
//  Copyright (c) 2014 MoonAnimals. All rights reserved.
//

#import "ServerRequest.h"

@implementation ServerRequest
+ (id)sharedManager {
    static ServerRequest *sharedMyManager = nil;
    @synchronized(self) {
        if (sharedMyManager == nil)
            sharedMyManager = [[self alloc] init];
    }
    return sharedMyManager;
}

@end

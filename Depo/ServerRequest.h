//
//  ServerRequest.h
//  Depo
//
//  Created by Phillip Ou on 11/1/14.
//  Copyright (c) 2014 MoonAnimals. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerRequest : NSObject
+ (id)sharedManager;
-(void) postPayment:(NSData*)payment;
@end

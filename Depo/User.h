//
//  User.h
//  Depo
//
//  Created by Phillip Ou on 11/2/14.
//  Copyright (c) 2014 MoonAnimals. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface User : NSManagedObject
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString* publicKey;
@property (nonatomic, retain) NSDictionary *usersDictionary;
@end

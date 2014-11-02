//
//  Transaction.h
//  Depo
//
//  Created by Phillip Ou on 11/2/14.
//  Copyright (c) 2014 MoonAnimals. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Transaction : NSManagedObject
@property (nonatomic,weak) NSString *message;
@property (nonatomic,weak) NSString *transHash;
@property (nonatomic,weak) NSDate *date;

@end

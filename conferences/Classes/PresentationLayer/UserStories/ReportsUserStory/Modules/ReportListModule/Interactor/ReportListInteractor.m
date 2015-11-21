//
//  ReportListInteractor.m
//  Conferences
//
//  Created by Karpushin Artem on 08/11/15.
//  Copyright 2015 Rambler. All rights reserved.
//

#import "ReportListInteractor.h"
#import "ReportListInteractorOutput.h"

#import "EventService.h"
#import "Event.h"
#import "EventPrototypeMapper.h"
#import "PlainEvent.h"

#import "EXTScope.h"

@implementation ReportListInteractor

#pragma mark - ReportListInteractorInput

- (void)updateEventList {
    @weakify(self)
    [self.eventService updateEventWithPredicate:nil completionBlock:^(id data, NSError *error) {
        @strongify(self);
        NSMutableArray *events = [NSMutableArray array];
        events = [self mapEventsManagedObjectsToPlainObjects:data];
        
        [self.output didUpdateEventList:events];
    }];
}

- (NSArray *)obtainEventList {
    id managedObjectEvents = [self.eventService obtainEventWithPredicate:nil];
    
    NSMutableArray *events = [NSMutableArray array];
    
    if ([managedObjectEvents isKindOfClass:[NSArray class]]) {
        events = [self mapEventsManagedObjectsToPlainObjects:managedObjectEvents];
    }
    return events;
}

#pragma mark - Private methods

- (NSMutableArray *)mapEventsManagedObjectsToPlainObjects:(NSArray *)manajedObjectEvents {
    NSMutableArray *plainEvents = [NSMutableArray array];
    for (Event *managedObjectEvent in manajedObjectEvents) {
        PlainEvent *plainEvent = [PlainEvent new];
        
        [self.eventPrototypeMapper fillObject:plainEvent withObject:managedObjectEvent];
        
        [plainEvents addObject:plainEvent];
    }
    return [self obtainPastEvents:plainEvents];
}

- (NSMutableArray *)obtainPastEvents:(NSMutableArray *)events {
    NSMutableArray *pastEvents = [NSMutableArray array];
    
    for (PlainEvent *event in events) {
        NSDate *currentDate = [NSDate date];
        if ([event.endDate timeIntervalSinceReferenceDate] < [currentDate timeIntervalSinceReferenceDate]) {
            [pastEvents addObject:event];
        }
    }
    
    return [self sortEventsByDate:pastEvents];
}

- (NSMutableArray *)sortEventsByDate:(NSMutableArray *)events {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(startDate)) ascending:NO];
    events = [[events sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
    
    return events;
}




@end
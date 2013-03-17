//
//  Log.m
//  BookApp
//
//  Created by Nalin on 3/7/13.
//
//

#import "Log.h"
#import "Environment.h"

static Log* _sharedInstance = nil;

@interface Log()
@property (atomic, strong) NSMutableArray *logQueue;
@property (atomic) dispatch_queue_t queue;
@property (atomic, strong) NSTimer *logBatchTimer;
@property NSTimeInterval logBatchTimerValue;

@end
@implementation Log

- (id) init {
    self = [super init];
    if (self) {
        self.logQueue = [NSMutableArray array];
        self.queue = dispatch_queue_create("logBackgroundThread", 0);
        self.logBatchTimerValue = [[[Environment sharedInstance] getConfigOption:@"logBatchTimerValue"] floatValue];
    }
    return self;
}

- (void)startLogBatchTimer {
    self.logBatchTimer = [NSTimer scheduledTimerWithTimeInterval:self.logBatchTimerValue target:self selector:@selector(sendLogsBackground) userInfo:nil repeats:NO];
}

- (void)stopLogBatchTimer {
    [self.logBatchTimer invalidate];
    self.logBatchTimer = nil;
}

- (void)sendLogsNow {
    [self sendLogs];
    [self stopLogBatchTimer];
}

- (void)sendLogsBackground {
    dispatch_async(self.queue, ^{
        [self sendLogs];
    });
}

- (void)sendLogs {
    NSLog(@"sending logs");
    NSArray *logsToSend = [self.logQueue copy];
    [self.logQueue removeAllObjects];
    [RKObjectManager.sharedManager postObject:nil path:@"/logs" parameters:@{@"logs": logsToSend} success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"sent logs");
        [self stopLogBatchTimer];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"error sending logs: %@", error);
        [self stopLogBatchTimer];
    }];
}

+ (Log *) sharedInstance {
    if (_sharedInstance == nil) {
        _sharedInstance = [[Log alloc] init];
    }
    return _sharedInstance;
}

+ (void) eventName: (NSString *) eventName data: (NSDictionary *) data {
    Log *sharedInstance = [Log sharedInstance];
    NSMutableDictionary *logMessage = [NSMutableDictionary dictionaryWithDictionary:data];
    logMessage[@"eventName"] = eventName;
    [sharedInstance.logQueue addObject:logMessage];
    
    if (!sharedInstance.logBatchTimer) {
        [sharedInstance startLogBatchTimer];
    }
}

@end

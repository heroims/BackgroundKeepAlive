//
//  KeepAliveManager.m
//  BackgroundKeepAliveDemo
//
//  Created by Admin on 2023/7/17.
//

#import "KeepAliveManager.h"
#import <AVFoundation/AVFoundation.h>

@interface KeepAliveManager ()
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskIdentifier;
@property (nonatomic, assign) BOOL enabled;
@end

@implementation KeepAliveManager

+ (instancetype)sharedInstance
{
    static KeepAliveManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [KeepAliveManager new];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupAudioSession];
        [self setupAudioPlayer];
        [self setupNotification];
    }
    return self;
}

- (void)setupNotification {
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(beginBackgroundTask) name: UIApplicationDidEnterBackgroundNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(endBackgroundTask) name: UIApplicationWillEnterForegroundNotification object: nil];
}

- (void)setupAudioSession {
    // 新建AudioSession会话
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    // 设置后台播放
    NSError *error = nil;
    [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&error];
    if (error) {
        NSLog(@"Error setCategory AVAudioSession: %@", error);
    }
//    NSLog(@"%d", audioSession.isOtherAudioPlaying);
    NSError *activeSetError = nil;
    // 启动AudioSession，如果一个前台app正在播放音频则可能会启动失败
    [audioSession setActive:YES error:&activeSetError];
    if (activeSetError) {
        NSLog(@"Error activating AVAudioSession: %@", activeSetError);
    }
}

- (void)setupAudioPlayer {
    //静音文件
    NSURL *associateBundleURL = [[NSBundle mainBundle] URLForResource:@"Frameworks" withExtension:nil];
    associateBundleURL = [associateBundleURL URLByAppendingPathComponent:@"BackgroundKeepAlive"];
    associateBundleURL = [associateBundleURL URLByAppendingPathExtension:@"framework"];
    NSBundle *associateBundle = [NSBundle mainBundle];
    if([[NSFileManager defaultManager] fileExistsAtPath:associateBundleURL.path]){
        associateBundle = [NSBundle bundleWithURL:associateBundleURL];
    }
    associateBundleURL = [associateBundle URLForResource:@"BackgroundKeepAlive" withExtension:@"bundle"];
    
    NSString *filePath = [[NSBundle bundleWithURL:associateBundleURL] pathForResource:@"keep_alive" ofType:@"wav"];
    
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filePath];

    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    //静音
    self.audioPlayer.volume = 0;
    //播放一次
    self.audioPlayer.numberOfLoops = 1;
    [self.audioPlayer prepareToPlay];
}

#pragma mark - private method

//申请后台任务
- (void)applyforBackgroundTask{
    self.backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        if (self.backgroundTaskIdentifier!=UIBackgroundTaskInvalid) {
            [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
            self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
        }
        
        [self.audioPlayer play];
        [self applyforBackgroundTask];
    }];
}

#pragma mark - notification method

- (void)beginBackgroundTask
{
    if (!self.enabled) {
        return;
    }
    
    [self.audioPlayer play];
    [self applyforBackgroundTask];
}

- (void)endBackgroundTask
{
    if (self.backgroundTaskIdentifier != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask: self.backgroundTaskIdentifier];
        self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    }
    [self.audioPlayer stop];
}

-(void)setEnabled:(BOOL)enabled{
    _enabled = enabled;
    if(_enabled){
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
            [self beginBackgroundTask];
        }
    }
    else{
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
            [self endBackgroundTask];
        }
    }
}
@end

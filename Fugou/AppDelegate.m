//
//  AppDelegate.m
//  Fugou
//
//  Created by Aymen Furter on 17.06.20.
//  Copyright © 2020 Aymen Furter. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface AppDelegate ()

@end

@implementation AppDelegate
CBCentralManager *cbCentralManager;
CBPeripheralManager *cbPManager;

Boolean isSafe;
Boolean inProgress;
NSMutableSet *encounters;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    cbCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue: dispatch_get_main_queue()];
    isSafe = YES;
    inProgress = NO;
      
    return YES;
}

- (void)resetStatus
{
    isSafe = YES;
    inProgress = NO;
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central {
    NSDictionary *options = @{CBCentralManagerScanOptionAllowDuplicatesKey: @YES};
    if (central.state == CBManagerStatePoweredOn ){
        [ cbCentralManager scanForPeripheralsWithServices:nil options:options ];
    }
}

-(Boolean) isSafe {
    return isSafe;
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    [encounters addObject:[peripheral identifier].UUIDString];

    if (RSSI.integerValue > -62 && inProgress == NO){
        inProgress = YES;
        isSafe = NO;
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(resetStatus) userInfo:nil repeats:NO];
    }
}

#pragma mark - UISceneSession lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
   
}
@end


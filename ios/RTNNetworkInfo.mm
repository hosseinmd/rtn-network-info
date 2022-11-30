//
//  RTNNetworkInfo.m
//  RTNNetworkInfo
//
//  Created by Corey Wilson on 7/12/15.
//  Copyright (c) 2015 eastcodes. All rights reserved.
//

#import "RTNNetworkInfo.h"
#import "FGRoute.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#include <net/if.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <TargetConditionals.h>
#import <NetworkExtension/NetworkExtension.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
//#define IOS_VPN       @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

#import <SystemConfiguration/CaptiveNetwork.h>
#import <SystemConfiguration/SCNetworkReachability.h>

@implementation RTNNetworkInfo

RCT_EXPORT_MODULE();

- (void) getIsInternetAvailable:(RCTPromiseResolveBlock)resolve
           reject:(RCTPromiseRejectBlock)reject
{
    try {
        SCNetworkReachabilityFlags flags;
        SCNetworkReachabilityRef address;
        
        address = SCNetworkReachabilityCreateWithName(NULL, "www.google.com");
        Boolean success = SCNetworkReachabilityGetFlags(address, &flags);
        CFRelease(address);
        
        bool canReach = success
        && !(flags & kSCNetworkReachabilityFlagsConnectionRequired)
        && (flags & kSCNetworkReachabilityFlagsReachable);
        
        resolve(canReach ? @true : @false);
    } catch (NSException *exception) {
        resolve(@false);
    }
}

#if TARGET_OS_IOS
- (NSString*) getSyncSSID
{
    @try{
        NSString *SSID = [FGRoute getSSID];
        return SSID;
    }@catch (NSException *exception) {
        return @"";
    }
}

- (void) getSSID:(RCTPromiseResolveBlock)resolve
           reject:(RCTPromiseRejectBlock)reject
{
    resolve([self getSyncSSID]);
}
#endif

#if TARGET_OS_IOS
- (NSString*) getSyncBSSID
{
    @try{
        NSString *BSSID = [FGRoute getBSSID];
        return BSSID;
    }@catch (NSException *exception) {
        return @"";
    }
}

- (void)getBSSID:(RCTPromiseResolveBlock)resolve
            reject:(RCTPromiseRejectBlock)reject;
{
    resolve([self getSyncBSSID]);
}
#endif

- (NSString*) getSyncBroadcast
{
    @try{
        NSString *address = @"";
        NSString *netmask = @"error";
        
        struct ifaddrs *interfaces = NULL;
        struct ifaddrs *temp_addr = NULL;
        int success = 0;
        
        success = getifaddrs(&interfaces);
        
        if (success == 0) {
            temp_addr = interfaces;
            while(temp_addr != NULL) {
                if(temp_addr->ifa_addr->sa_family == AF_INET) {
                    if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                        address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                        netmask = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)];
                        
                        struct in_addr local_addr;
                        struct in_addr netmask_addr;
                        inet_aton([address UTF8String], &local_addr);
                        inet_aton([netmask UTF8String], &netmask_addr);
                        
                        local_addr.s_addr |= ~(netmask_addr.s_addr);
                        
                        address = [NSString stringWithUTF8String:inet_ntoa(local_addr)];
                    }
                }
                temp_addr = temp_addr->ifa_next;
            }
        }
        freeifaddrs(interfaces);
        return address;
    }@catch (NSException *exception) {
        return @"";
    }
}

- (void) getBroadcast:(RCTPromiseResolveBlock)resolve
            reject:(RCTPromiseRejectBlock)reject;
{
    resolve([self getSyncBroadcast]);
}

- (NSString*) getSyncIPAddress
{
    @try {
        NSString *address = [FGRoute getIPAddress];
        return address;
    }@catch (NSException *exception) {
        return @"";
    }
}

- (void) getIPAddress:(RCTPromiseResolveBlock)resolve
            reject:(RCTPromiseRejectBlock)reject
{
    resolve([self getSyncIPAddress]);
}

- (NSString*) getSyncGatewayIPAddress
{
    @try{
        NSString *ipString = [FGRoute getGatewayIP];
        return ipString;
    }@catch (NSException *exception) {
        return @"";
    }
}

- (void) getGatewayIPAddress:(RCTPromiseResolveBlock)resolve
            reject:(RCTPromiseRejectBlock)reject;
{
    resolve([self getSyncGatewayIPAddress]);
}

- (NSString*) getSyncIPV4Address
{
    @try{
        NSArray *searchArray = @[ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv4 ];
        NSDictionary *addresses = [self getAllIPAddresses];
        NSLog(@"addresses: %@", addresses);
        
        __block NSString *address;
        [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
         {
            address = addresses[key];
            if(address) *stop = YES;
        } ];
        NSString *addressToReturn = address ? address : @"0.0.0.0";
        return addressToReturn;
    }@catch (NSException *exception) {
        return @"";
    }
}

- (void)getIPV4Address:(RCTPromiseResolveBlock)resolve
            reject:(RCTPromiseRejectBlock)reject;
{
    resolve([self getSyncIPV4Address]);
}

/**
 Gets the device's WiFi interface IP address
 @return device's WiFi IP if connected to WiFi, else '0.0.0.0'
 */
- (NSString*) getSyncWIFIIPV4Address
{
    @try{
        NSArray *searchArray = @[ IOS_WIFI @"/" IP_ADDR_IPv4 ];
        NSDictionary *addresses = [self getAllIPAddresses];
        NSLog(@"addresses: %@", addresses);
        
        __block NSString *address;
        [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
         {
            address = addresses[key];
            if(address) *stop = YES;
        } ];
        NSString *addressToReturn = address ? address : @"0.0.0.0";
        return addressToReturn;
    }@catch (NSException *exception) {
        return @"";
    }
}

- (void) getWIFIIPV4Address:(RCTPromiseResolveBlock)resolve
            reject:(RCTPromiseRejectBlock)reject;
{
    resolve([self getSyncWIFIIPV4Address]);
}

- (NSString*) getSyncSubnet
{
    @try {
        NSString *netmask = @"error";
        struct ifaddrs *interfaces = NULL;
        struct ifaddrs *temp_addr = NULL;
        
        int success = 0;
        
        // retrieve the current interfaces - returns 0 on success
        success = getifaddrs(&interfaces);
        if (success == 0)
        {
            temp_addr = interfaces;
            
            while(temp_addr != NULL)
            {
                // check if interface is en0 which is the wifi connection on the iPhone
                if(temp_addr->ifa_addr->sa_family == AF_INET)
                {
                    if([@(temp_addr->ifa_name) isEqualToString:@"en0"])
                    {
                        netmask = @(inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr));
                    }
                }
                
                temp_addr = temp_addr->ifa_next;
            }
        }
        freeifaddrs(interfaces);
        
        NSString *addressToReturn = netmask ? netmask : @"0.0.0.0";
        return addressToReturn;
    } @catch (NSException *exception) {
        return @"";
    }
}

- (void) getSubnet:(RCTPromiseResolveBlock)resolve
            reject:(RCTPromiseRejectBlock)reject;
{
    resolve([self getSyncSubnet]);
}

- (NSDictionary *)getAllIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}


- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
(const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeNetworkInfoSpecJSI>(params);
}

@end


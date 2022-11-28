# rtn-network-info

React Native library for getting information about the devices network
This is a Fork of [react-native-network-info](https://github.com/pusherman/react-native-network-info) which supporting new Architecture

for React-native < 70 install [react-native-network-info](https://github.com/pusherman/react-native-network-info) or[@react-native-community/netinfo](https://github.com/react-native-netinfo/react-native-netinfo)

## Requirements

RN 0.70 or higher
Enabled new Architecture

## Installation

```javascript
npm install rtn-network-info --save
```

or

```javascript
yarn add rtn-network-info
```

### Linking the library

#### Android

Nothing to do

#### `iOS` also requires CocoaPods install

$ `cd ios && pod install && cd ..`

## Usage

```javascript
import { NetworkInfo } from "react-native-network-info";

// Get Local IP
NetworkInfo.getIPAddress().then((ipAddress) => {
  console.log(ipAddress);
});

// Get IPv4 IP (priority: WiFi first, cellular second)
NetworkInfo.getIPV4Address().then((ipv4Address) => {
  console.log(ipv4Address);
});

// Get Broadcast
NetworkInfo.getBroadcast().then((broadcast) => {
  console.log(broadcast);
});

// Get SSID
NetworkInfo.getSSID().then((ssid) => {
  console.log(ssid);
});

// Get BSSID
NetworkInfo.getBSSID().then((bssid) => {
  console.log(bssid);
});

// Get Subnet
NetworkInfo.getSubnet().then((subnet) => {
  console.log(subnet);
});

// Get Default Gateway IP
NetworkInfo.getGatewayIPAddress().then((defaultGateway) => {
  console.log(defaultGateway);
});

// Get frequency (supported only for Android)
NetworkInfo.getFrequency().then((frequency) => {
  console.log(frequency);
});
```

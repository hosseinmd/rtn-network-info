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

`$ cd ios && pod install && cd ..`

## Usage

### Get Local IP

```javascript
import NetworkInfo from "rtn-network-info";

// Async
NetworkInfo.getIPAddress().then((ipAddress) => {
  console.log(ipAddress);
});
// Sync
const ipAddress = NetworkInfo.getSyncIPAddress();
```

### Get IPv4 IP

(priority: WiFi first, cellular second)

```js
// Async
NetworkInfo.getIPV4Address().then((ipv4Address) => {
  console.log(ipv4Address);
});
// Sync
const ipv4Address = NetworkInfo.getSyncIPV4Address();
```

### Get Broadcast

```js
// Async
NetworkInfo.getBroadcast().then((broadcast) => {
  console.log(broadcast);
});
// Sync
const broadcast = NetworkInfo.getSyncBroadcast();
```

### Get SSID

```js
// Async
NetworkInfo.getSSID().then((ssid) => {
  console.log(ssid);
});
// Sync
const ssid = NetworkInfo.getSyncSSID();
```

### Get BSSID

```js
// Async
NetworkInfo.getBSSID().then((bssid) => {
  console.log(bssid);
});
// Sync
const bssid = NetworkInfo.getSyncBSSID();
```

### Get Subnet

```js
// Async
NetworkInfo.getSubnet().then((subnet) => {
  console.log(subnet);
});
// Sync
const subnet = NetworkInfo.getSyncSubnet();
```

### Get Default Gateway IP

```js
// Async
NetworkInfo.getGatewayIPAddress().then((defaultGateway) => {
  console.log(defaultGateway);
});
// Sync
const defaultGateway = NetworkInfo.getSyncGatewayIPAddress();
```

### Get frequency (supported only for Android)

```js
// Async
NetworkInfo.getFrequency().then((frequency) => {
  console.log(frequency);
});
// Sync
const frequency = NetworkInfo.getSyncFrequency();
```

### Get is internet available

```js
// Async
NetworkInfo.getIsNetworkAvailable().then((isNetworkAvailable) => {
  console.log(isNetworkAvailable);
});
```

import { Platform } from "react-native";
import RNNetworkInfo from "./NativeNetworkInfo";

export function getSyncSSID() {
  return RNNetworkInfo?.getSyncSSID();
}

export function getSyncBSSID() {
  return RNNetworkInfo?.getSyncBSSID();
}

export function getSyncBroadcast() {
  return RNNetworkInfo?.getSyncBroadcast();
}

export function getSyncIPAddress() {
  return RNNetworkInfo?.getSyncIPAddress();
}

export function getSyncIPV4Address() {
  const wifiIP = RNNetworkInfo?.getSyncWIFIIPV4Address();
  if (wifiIP && wifiIP !== "0.0.0.0") {
    return wifiIP;
  }

  return RNNetworkInfo?.getSyncIPV4Address();
}

export function getSyncSubnet() {
  return RNNetworkInfo?.getSyncSubnet();
}

export function getSyncGatewayIPAddress() {
  return RNNetworkInfo?.getSyncGatewayIPAddress();
}

/**
 * Android Only
 */
export function getSyncFrequency() {
  if (Platform.OS !== "android") {
    return null;
  }
}

export async function getIsNetworkAvailable() {
  return await RNNetworkInfo?.getIsNetworkAvailable();
}

export async function getSSID() {
  return await RNNetworkInfo?.getSSID();
}

export async function getBSSID() {
  return await RNNetworkInfo?.getBSSID();
}

export async function getBroadcast() {
  return await RNNetworkInfo?.getBroadcast();
}

export async function getIPAddress() {
  return await RNNetworkInfo?.getIPAddress();
}

export async function getIPV4Address() {
  const wifiIP = await RNNetworkInfo?.getWIFIIPV4Address();
  if (wifiIP && wifiIP !== "0.0.0.0") {
    return wifiIP;
  }

  return await RNNetworkInfo?.getIPV4Address();
}

export async function getGatewayIPAddress() {
  return await RNNetworkInfo?.getGatewayIPAddress();
}

export async function getSubnet() {
  return await RNNetworkInfo?.getSubnet();
}

/**
 * Android Only
 */
export async function getFrequency() {
  if (Platform.OS !== "android") {
    return null;
  }
  return await RNNetworkInfo?.getFrequency();
}

const NetworkInfo = {
  getSyncSSID,
  getSyncBSSID,
  getSyncBroadcast,
  getSyncIPAddress,
  getSyncIPV4Address,
  getSyncSubnet,
  getSyncGatewayIPAddress,
  getSyncFrequency,
  getIsNetworkAvailable,
  getSSID,
  getBSSID,
  getBroadcast,
  getIPAddress,
  getIPV4Address,
  getGatewayIPAddress,
  getSubnet,
  getFrequency,
};

export default NetworkInfo;
export { NetworkInfo };

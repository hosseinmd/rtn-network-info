import type { TurboModule } from "react-native";
import { TurboModuleRegistry } from "react-native";

export interface Spec extends TurboModule {
  getSSID(): Promise<string>;
  getBSSID(): Promise<string>;
  getBroadcast(): Promise<string>;
  getIPAddress(): Promise<string>;
  getIPV4Address(): Promise<string>;
  getWIFIIPV4Address(): Promise<string>;
  getSubnet(): Promise<string>;
  getGatewayIPAddress(): Promise<string>;
  getFrequency(): Promise<number>;
}

export default TurboModuleRegistry.get<Spec>("RTNNetworkInfo") as Spec | null;

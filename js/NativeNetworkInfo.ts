import type { TurboModule } from "react-native";
import { TurboModuleRegistry } from "react-native";

export interface Spec extends TurboModule {
  getSyncSSID(): string;
  getSyncBSSID(): string;
  getSyncBroadcast(): string;
  getSyncIPAddress(): string;
  getSyncIPV4Address(): string;
  getSyncWIFIIPV4Address(): string;
  getSyncSubnet(): string;
  getSyncGatewayIPAddress(): string;
  /**
   * Android Only
   */
  getSyncFrequency(): number;

  //Async

  getIsNetworkAvailable(): Promise<boolean>;
  getSSID(): Promise<string>;
  getBSSID(): Promise<string>;
  getBroadcast(): Promise<string>;
  getIPAddress(): Promise<string>;
  getIPV4Address(): Promise<string>;
  getWIFIIPV4Address(): Promise<string>;
  getSubnet(): Promise<string>;
  getGatewayIPAddress(): Promise<string>;
  /**
   * Android Only
   */
  getFrequency(): Promise<number>;
}

export default TurboModuleRegistry.get<Spec>("RTNNetworkInfo") as Spec | null;

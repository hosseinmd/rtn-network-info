package com.rtnnetworkinfo;

import androidx.annotation.NonNull;

import android.content.Context;
import android.net.DhcpInfo;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.net.wifi.SupplicantState;
import android.util.Log;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;

import java.net.Inet4Address;
import java.net.InetAddress;
import java.net.InterfaceAddress;
import java.net.NetworkInterface;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Arrays;
import java.util.List;
import java.net.Inet6Address;
import java.util.Map;
import java.util.HashMap;

public class NetworkInfoModule extends NativeNetworkInfoSpec {

    public static String NAME = "RTNNetworkInfo";

    NetworkInfoModule(ReactApplicationContext context) {
        super(context);

        wifi = (WifiManager) context.getApplicationContext().getSystemService(Context.WIFI_SERVICE);
    }

    @Override
    @NonNull
    public String getName() {
        return NAME;
    }

    WifiManager wifi;

    public static List<String> DSLITE_LIST = Arrays.asList("192.0.0.0", "192.0.0.1", "192.0.0.2", "192.0.0.3", "192.0.0.4", "192.0.0.5", "192.0.0.6", "192.0.0.7");

    @ReactMethod
    public String getSyncSSID() {
        try {
            WifiInfo info = wifi.getConnectionInfo();
            // This value should be wrapped in double quotes, so we need to unwrap it.
            // https://stackoverflow.com/a/34848930/5732760
            String ssid = "";
            if (info.getSupplicantState() == SupplicantState.COMPLETED) {
                ssid = info.getSSID();
                if (ssid.startsWith("\"") && ssid.endsWith("\"")) {
                    ssid = ssid.substring(1, ssid.length() - 1);
                }
            }

            return ssid;
        } catch (Exception e) {
            return "";
        }
    }

    @ReactMethod
    public void getSSID(Promise promise) {
        String ssid = this.getSyncSSID();
        promise.resolve(ssid);
    }

    @ReactMethod
    public String getSyncBSSID() {
        try {
            WifiInfo info = wifi.getConnectionInfo();

            // https://stackoverflow.com/a/34848930/5732760
            String bssid = "";
            if (info.getSupplicantState() == SupplicantState.COMPLETED) {
                bssid = wifi.getConnectionInfo().getBSSID();
            }
            return bssid;
        } catch (Exception e) {
            return "";
        }
    }

    @ReactMethod
    public void getBSSID(Promise promise) {
        String bssid = this.getSyncBSSID();

        promise.resolve(bssid);
    }

    @ReactMethod
    public String getSyncBroadcast() {
        try {
            String ipAddress = "";

            for (InterfaceAddress address : getInetAddresses()) {
                if (!address.getAddress().isLoopbackAddress()/*address.getAddress().toString().equalsIgnoreCase(ip)*/) {
                    InetAddress broadCast = address.getBroadcast();
                    if (broadCast != null) {
                        ipAddress = broadCast.toString();
                    }
                }
            }
            return ipAddress;
        } catch (Exception e) {
            return "";
        }

    }

    @ReactMethod
    public void getBroadcast(Promise promise) {
        String ipAddress = this.getSyncBroadcast();

        promise.resolve(ipAddress);
    }


    @ReactMethod
    public String getSyncIPAddress() {
        try {
            String ipAddress = "";
            String tmp = "0.0.0.0";

            for (InterfaceAddress address : getInetAddresses()) {
                if (!address.getAddress().isLoopbackAddress()) {
                    tmp = address.getAddress().getHostAddress().toString();
                    if (!inDSLITERange(tmp)) {
                        ipAddress = tmp;
                    }
                }
            }
            return ipAddress;
        } catch (Exception e) {
            return "";
        }
    }


    @ReactMethod
    public void getIPAddress(Promise promise) {
        String ipAddress = this.getSyncIPAddress();

        promise.resolve(ipAddress);
    }


    @ReactMethod
    public String getSyncIPV4Address() {
        try {
            String ipAddress = "";
            String tmp = "0.0.0.0";

            for (InterfaceAddress address : getInetAddresses()) {
                if (!address.getAddress().isLoopbackAddress() && address.getAddress() instanceof Inet4Address) {
                    tmp = address.getAddress().getHostAddress().toString();
                    if (!inDSLITERange(tmp)) {
                        ipAddress = tmp;
                    }
                }
            }
            return ipAddress;
        } catch (Exception e) {
            return "";
        }
    }

    @ReactMethod
    public void getIPV4Address(Promise promise) {
        String ipAddress = this.getSyncIPV4Address();

        promise.resolve(ipAddress);
    }


    /**
     * Gets the device's WiFi interface IP address
     *
     * @return device's WiFi IP if connected to WiFi, else '0.0.0.0'
     */
    @ReactMethod
    public String getSyncWIFIIPV4Address() {
        try {
            WifiInfo info = wifi.getConnectionInfo();
            int ipAddress = info.getIpAddress();
            String stringip = String.format("%d.%d.%d.%d", (ipAddress & 0xff), (ipAddress >> 8 & 0xff), (ipAddress >> 16 & 0xff), (ipAddress >> 24 & 0xff));
            return stringip;
        } catch (Exception e) {
            return "";
        }
    }

    @ReactMethod
    public void getWIFIIPV4Address(Promise promise) {
        String stringip = this.getSyncWIFIIPV4Address();
        promise.resolve(stringip);
    }

    @ReactMethod
    public String getSyncSubnet() {
        try {
            Enumeration<NetworkInterface> interfaces = NetworkInterface.getNetworkInterfaces();

            while (interfaces.hasMoreElements()) {
                NetworkInterface iface = interfaces.nextElement();
                if (iface.isLoopback() || !iface.isUp()) continue;

                Enumeration<InetAddress> addresses = iface.getInetAddresses();
                for (InterfaceAddress address : iface.getInterfaceAddresses()) {

                    InetAddress addr = addresses.nextElement();
                    if (addr instanceof Inet6Address) continue;

                    return intToIP(address.getNetworkPrefixLength());
                }
            }

            return "";
        } catch (Exception e) {
            return "";
        }
    }

    @ReactMethod
    public void getSubnet(Promise promise) {
        String subnet = this.getSyncSubnet();
        promise.resolve(subnet);
    }


    @ReactMethod
    public String getSyncGatewayIPAddress() {
        try {
            DhcpInfo dhcpInfo = wifi.getDhcpInfo();
            int gatewayIPInt = dhcpInfo.gateway;
            String gatewayIP = String.format("%d.%d.%d.%d", ((gatewayIPInt) & 0xFF), ((gatewayIPInt >> 8) & 0xFF), ((gatewayIPInt >> 16) & 0xFF), ((gatewayIPInt >> 24) & 0xFF));
            return gatewayIP;
        } catch (Exception e) {
            return "";
        }
    }

    @ReactMethod
    public void getGatewayIPAddress(Promise promise) {
        String gatewayIP = this.getSyncGatewayIPAddress();
        promise.resolve(gatewayIP);
    }

    @ReactMethod
    public double getSyncFrequency() {
        try {
            WifiInfo info = wifi.getConnectionInfo();
            double frequency = info.getFrequency();
            return frequency;
        } catch (Exception e) {
            return null;
        }
    }

    @ReactMethod
    public void getFrequency(Promise promise) {
        double frequency = this.getSyncFrequency();
        promise.resolve(frequency);
    }

    private String intToIP(int ip) {
        String[] finl = {"", "", "", ""};
        int k = 1;

        for (int i = 0; i < 4; i++) {
            for (int j = 0; j < 8; j++) {
                if (k <= ip) {
                    finl[i] += "1";
                } else {
                    finl[i] += "0";
                }
                k++;

            }
        }
        return Integer.parseInt(finl[0], 2) + "." + Integer.parseInt(finl[1], 2) + "." + Integer.parseInt(finl[2], 2) + "." + Integer.parseInt(finl[3], 2);
    }

    private Boolean inDSLITERange(String ip) {
        // Fixes issue https://github.com/pusherman/react-native-network-info/issues/43
        // Based on comment
        // https://github.com/pusherman/react-native-network-info/issues/43#issuecomment-358360692
        // added this check in getIPAddress and getIPV4Address
        return NetworkInfoModule.DSLITE_LIST.contains(ip);
    }

    private List<InterfaceAddress> getInetAddresses() {
        List<InterfaceAddress> addresses = new ArrayList<>();
        try {
            for (Enumeration<NetworkInterface> en = NetworkInterface.getNetworkInterfaces(); en.hasMoreElements(); ) {
                NetworkInterface intf = en.nextElement();

                for (InterfaceAddress interface_address : intf.getInterfaceAddresses()) {
                    addresses.add(interface_address);
                }
            }
        } catch (Exception ex) {
            Log.e(NAME, ex.toString());
        }
        return addresses;
    }
}
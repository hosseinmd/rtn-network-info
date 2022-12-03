/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * Generated with the TypeScript template
 * https://github.com/react-native-community/react-native-template-typescript
 *
 * @format
 */

import React, {useEffect, type PropsWithChildren} from 'react';
import {
  SafeAreaView,
  ScrollView,
  StatusBar,
  StyleSheet,
  Text,
  useColorScheme,
  View,
} from 'react-native';

import {
  Colors,
  DebugInstructions,
  Header,
  LearnMoreLinks,
  ReloadInstructions,
} from 'react-native/Libraries/NewAppScreen';
import NetworkInfo from 'rtn-network-info/js/NativeNetworkInfo';
console.log('start');

// for (let index = 0; index < 10000; index++) {
//   NetworkInfo?.getIPAddress()
//     .then(value => {
//       console.log({value});
//     })
//     .catch(error => {
//       console.log({error});
//     });
// }

const Section: React.FC<
  PropsWithChildren<{
    title: string;
  }>
> = ({children, title}) => {
  const isDarkMode = useColorScheme() === 'dark';
  return (
    <View style={styles.sectionContainer}>
      <Text
        style={[
          styles.sectionTitle,
          {
            color: isDarkMode ? Colors.white : Colors.black,
          },
        ]}>
        {title}
      </Text>
      <Text
        style={[
          styles.sectionDescription,
          {
            color: isDarkMode ? Colors.light : Colors.dark,
          },
        ]}>
        {children}
      </Text>
    </View>
  );
};

const App = () => {
  const isDarkMode = useColorScheme() === 'dark';

  const backgroundStyle = {
    backgroundColor: isDarkMode ? Colors.darker : Colors.lighter,
  };

  useEffect(() => {
    // // Async
    NetworkInfo?.getIPAddress().then(ipAddress => {
      console.log({ipAddress});
    });
    // Sync
    const syncIpAddress = NetworkInfo?.getSyncIPAddress();
    console.log({syncIpAddress});

    // Async
    NetworkInfo?.getIPV4Address().then(ipv4Address => {
      console.log({ipv4Address});
    });
    // Sync
    const syncIpv4Address = NetworkInfo?.getSyncIPV4Address();
    console.log({syncIpv4Address});

    // Async
    NetworkInfo?.getBroadcast().then(broadcast => {
      console.log({broadcast});
    });
    // Sync
    const syncBroadcast = NetworkInfo?.getSyncBroadcast();
    console.log({syncBroadcast});

    // Async
    NetworkInfo?.getSSID().then(ssid => {
      console.log({ssid});
    });
    // Sync
    const syncSsid = NetworkInfo?.getSyncSSID();
    console.log({syncSsid});

    // Async
    NetworkInfo?.getBSSID().then(bssid => {
      console.log({bssid});
    });
    // Sync
    const syncBssid = NetworkInfo?.getSyncBSSID();
    console.log({syncBssid});

    // Async
    NetworkInfo?.getSubnet().then(subnet => {
      console.log({subnet});
    });
    // Sync
    const syncSubnet = NetworkInfo?.getSyncSubnet();
    console.log({syncSubnet});

    // Async
    NetworkInfo?.getGatewayIPAddress().then(defaultGateway => {
      console.log({defaultGateway});
    });
    // Sync
    const syncDefaultGateway = NetworkInfo?.getSyncGatewayIPAddress();
    console.log({syncDefaultGateway});

    // Async
    NetworkInfo?.getFrequency().then(frequency => {
      console.log({frequency});
    });
    // Sync
    const syncFrequency = NetworkInfo?.getSyncFrequency();
    console.log({syncFrequency});

    // Async
    NetworkInfo?.getIsNetworkAvailable().then(isNetworkAvailable => {
      console.log({isNetworkAvailable});
    });

    console.log('end');
  });

  return (
    <SafeAreaView style={backgroundStyle}>
      <StatusBar
        barStyle={isDarkMode ? 'light-content' : 'dark-content'}
        backgroundColor={backgroundStyle.backgroundColor}
      />
      <ScrollView
        contentInsetAdjustmentBehavior="automatic"
        style={backgroundStyle}>
        <Header />
        <View
          style={{
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
          }}>
          <Section title="Step One">
            Edit <Text style={styles.highlight}>App.tsx</Text> to change this
            screen and then come back to see your edits.
          </Section>
          <Section title="See Your Changes">
            <ReloadInstructions />
          </Section>
          <Section title="Debug">
            <DebugInstructions />
          </Section>
          <Section title="Learn More">
            Read the docs to discover what to do next:
          </Section>
          <LearnMoreLinks />
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  sectionContainer: {
    marginTop: 32,
    paddingHorizontal: 24,
  },
  sectionTitle: {
    fontSize: 24,
    fontWeight: '600',
  },
  sectionDescription: {
    marginTop: 8,
    fontSize: 18,
    fontWeight: '400',
  },
  highlight: {
    fontWeight: '700',
  },
});

export default App;

import * as React from 'react';

import { Image, StyleSheet, View } from 'react-native';
import { MaskView } from 'react-native-mask';

const IMG_SOURCE =
  'https://upload.wikimedia.org/wikipedia/commons/b/b2/Hausziege_04.jpg';

export default function App() {
  return (
    <View style={styles.container}>
      {/* <View style={{ height: 400, width: 400, backgroundColor: '#f0f' }} /> */}
      <MaskView
        style={styles.maskView}
        MaskElement={() => <View style={styles.maskContainer} />}
      >
        <Image
          style={{ flex: 1, width: 600, backgroundColor: '#f0f' }}
          source={{ uri: IMG_SOURCE }}
        />
        {/* <View style={{ height: 300, width: 300, backgroundColor: '#f0f' }} /> */}
      </MaskView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#FFc',
  },
  maskView: {
    flex: 1,
  },
  maskContainer: {
    flex: 1,
    width: 300,
    backgroundColor: '#AAA',
  },
});

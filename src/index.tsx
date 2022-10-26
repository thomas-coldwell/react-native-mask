import React from 'react';
import {
  requireNativeComponent,
  UIManager,
  Platform,
  ViewStyle,
  StyleSheet,
  View,
} from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-mask' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

type NativeMaskProps = {
  style: ViewStyle;
  children: React.ReactNode;
};

const ComponentName = 'MaskView';

const NativeMaskView =
  UIManager.getViewManagerConfig(ComponentName) != null
    ? requireNativeComponent<NativeMaskProps>(ComponentName)
    : () => {
        throw new Error(LINKING_ERROR);
      };

export type MaskViewProps = NativeMaskProps & {
  MaskElement: () => React.ReactElement;
};

export const MaskView: React.FC<MaskViewProps> = ({
  style,
  children,
  MaskElement,
}) => {
  return (
    <NativeMaskView style={style}>
      <View style={StyleSheet.absoluteFill} pointerEvents="none">
        <MaskElement />
      </View>
      {children}
    </NativeMaskView>
  );
};

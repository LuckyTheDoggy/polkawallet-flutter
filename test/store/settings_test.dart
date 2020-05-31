import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/store/settings.dart';
import 'package:polka_wallet/utils/localStorage.dart';

class MockLocalStorage extends Mock implements LocalStorage {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsStore test', () {
    final AppStore root = AppStore();
    root.localStorage = MockLocalStorage();
    final store = SettingsStore(root);

    test('settings store created', () {
      expect(store.cacheNetworkStateKey, 'network');
      expect(store.localeCode, '');
    });
    test('set locale code properly', () async {
      await store.setLocalCode('_en');
      expect(store.localeCode, '_en');
      await store.setLocalCode('_zh');
      expect(store.localeCode, '_zh');
    });
    test('set network loading state properly', () async {
      expect(store.loading, true);
      store.setNetworkLoading(false);
      expect(store.loading, false);
      store.setNetworkLoading(true);
      expect(store.loading, true);
    });
    test('set network name properly', () async {
      expect(store.networkName, '');
      store.setNetworkName('Kusama');
      expect(store.networkName, 'Kusama');
      expect(store.loading, false);
    });
    test('set network state properly', () async {
      store.setNetworkState(Map<String, dynamic>.of({
        'ss58Format': 2,
        'tokenDecimals': 12,
        'tokenSymbol': 'KSM',
      }));
      expect(store.networkState.ss58Format, 2);
      expect(store.networkState.tokenDecimals, 12);
      expect(store.networkState.tokenSymbol, 'KSM');
    });
  });
}

import 'package:shared_preferences/shared_preferences.dart';

/// T144: "persist affirmed flag locally only" — a single boolean, nothing else.
/// Deliberately NOT part of the Drift local store (T029): that store is the synced
/// offline-content cache/workspace (R9); this flag is never synced, never sent to
/// the server, and has no relation to synced content, so a plain local key-value
/// store is the more honest fit. No date of birth, no "attempt" record, no
/// timestamp — just whether this device has ever affirmed.
class AgeGateLocalStore {
  static const _affirmedKey = 'age_gate_affirmed';

  Future<bool> isAffirmed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_affirmedKey) ?? false;
  }

  Future<void> setAffirmed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_affirmedKey, true);
  }
}

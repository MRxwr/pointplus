
import 'package:point/features/settings/settingsLocalDataSource.dart';

class SettingsRepository {

  final SettingsLocalDataSource _settingsLocalDataSource;

  SettingsRepository(this._settingsLocalDataSource);



  Map<String, dynamic> getCurrentSettings() {
    return {
      'showIntroSlider': _settingsLocalDataSource.showIntroSlider,
      'backgroundMusic': _settingsLocalDataSource.backgroundMusic,
      'sound': _settingsLocalDataSource.sound,
      'rewardEarned': _settingsLocalDataSource.rewardEarned,
      'vibration': _settingsLocalDataSource.vibration,
      'languageCode': _settingsLocalDataSource.languageCode,
      'theme': _settingsLocalDataSource.theme,
      'playAreaFontSize': _settingsLocalDataSource.playAreaFontSize,
    };
  }

  bool get showIntroSlider => _settingsLocalDataSource.showIntroSlider;

  set showIntroSlider(bool value) =>
      _settingsLocalDataSource.showIntroSlider = value;

  bool get sound => _settingsLocalDataSource.sound;

  set sound(bool value) => _settingsLocalDataSource.sound = value;

  bool get vibration => _settingsLocalDataSource.vibration;

  set vibration(bool value) => _settingsLocalDataSource.vibration = value;

  bool get backgroundMusic => _settingsLocalDataSource.backgroundMusic;

  set backgroundMusic(bool value) =>
      _settingsLocalDataSource.backgroundMusic = value;

  String get languageCode => _settingsLocalDataSource.languageCode;

  set languageCode(String value) =>
      _settingsLocalDataSource.languageCode = value;

  double get playAreaFontSize => _settingsLocalDataSource.playAreaFontSize;

  set playAreaFontSize(double value) =>
      _settingsLocalDataSource.playAreaFontSize = value;
}

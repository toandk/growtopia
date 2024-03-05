enum ScreenTrackingName { login }

extension Name on ScreenTrackingName {
  String get stringValue {
    switch (this) {
      case ScreenTrackingName.login:
        return 'LoginScreen';
    }
  }
}

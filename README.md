# flutter_ravepay

Flutter_Ravepay provides a wrapper that incorporate payments using [Ravepay](https://paystack.com/) within your flutter applications. The integration is achieved using Ravepay's [Android](https://github.com/PaystackHQ/paystack-android)/[iOS](https://github.com/PaystackHQ/paystack-ios) SDK libraries. It currently has full support for only Android. Getting it to work on iOS comes with a few more steps and configurations.

## Installing

```
flutter_ravepay:
    git:
      url: git://github.com/jogboms/flutter_ravepay
```

## How To Use

More info soon, but, so far.

### Import

```
import 'package:flutter_ravepay/flutter_ravepay.dart';
```

### Instantiate

```dart
// Instance
FlutterRavepay ravePay = FlutterRavepay.of(context);
```

### Charging a Card

```dart
// Result
FlutterRavepayResult result;

try {
  result = await ravePay.chargeCard({
    "amount": "4500.0",
    "country": "NG",
    "currency": "NGN",
    "email": "testemail@gmail.com",
    "firstname": "Jeremiah",
    "lastname": "Ogbomo",
    "narration": "Test Payment",
    "publicKey": "****",
    "secretKey": "****",
    "txRef": "ravePay-1234345",
    "useAccounts": false,
    "useCards": true,
    "isStaging": true,
    "useSave": true,
    "style": null,
  });
} on PlatformException {
  result = new FlutterRavepayResult({"message": 'Failed to communicate.'});
}
```

## Note

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

For help on editing plugin code, view the [documentation](https://flutter.io/platform-plugins/#edit-code).

## License

Apache License Version 2.0, January 2004

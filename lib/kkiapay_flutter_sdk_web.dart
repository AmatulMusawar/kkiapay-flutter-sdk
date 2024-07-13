// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'package:flutter/cupertino.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'kkiapay_flutter_sdk.dart';
import 'kkiapay_flutter_sdk_platform_interface.dart';

/// A web implementation of the KkiapayFlutterSdkPlatform of the KkiapayFlutterSdk plugin.
class KkiapayFlutterSdkWeb extends KkiapayFlutterSdkPlatform {
  /// Constructs a KkiapayFlutterSdkWeb
  KkiapayFlutterSdkWeb();

  static void registerWith(Registrar registrar) {
    KkiapayFlutterSdkPlatform.instance = KkiapayFlutterSdkWeb();
  }

  @override
  Future pay (
      KKiaPay paymentRequest,
      BuildContext context,
      Function(dynamic, BuildContext) callback) async {
    final data = js.JsObject.jsify({
      'amount': paymentRequest.amount.toString(),
      'key': paymentRequest.apikey.toString(),
      'sandbox': paymentRequest.sandbox.toString(),
      'name': paymentRequest.name.toString(),
      'phone': paymentRequest.phone.toString(),
      'email': paymentRequest.email.toString(),
      'data': paymentRequest.data.toString(),
      'theme': paymentRequest.theme.toString(),
      'reason': paymentRequest.reason.toString(),
      'partnerId': paymentRequest.partnerId.toString(),
      'countries': paymentRequest.countries,
    });

    void onSuccessListener(js.JsObject response) async {
      callback( {
        'requestData':  {
          'amount': paymentRequest.amount,
          'key': paymentRequest.apikey,
          'sandbox': paymentRequest.sandbox,
          'name': paymentRequest.name,
          'phone': paymentRequest.phone,
          'email': paymentRequest.email,
          'data': paymentRequest.data,
          'theme': paymentRequest.theme,
          'countries': paymentRequest.countries.toString(),
          'reason': paymentRequest.reason.toString(),
          'partnerId': paymentRequest.partnerId.toString(),
        },
        'transactionId': response["transactionId"],
        'status': PAYMENT_SUCCESS
      },context );
    }

    js.context.callMethod('addSuccessListener', [onSuccessListener]);

    js.context.callMethod('openKkiapayWidget', [data]);
  }

}

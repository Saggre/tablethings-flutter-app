import 'package:logging/logging.dart';
import 'package:tablething/stripe/src/resources/signature.dart';

final log = Logger('Stripe Webhook');

/// Returns true if the provided ip address is of of the white listed
/// Stripe webhook ip addresses.
bool isValidWebhookIpAddress(String ipAddress) {
  return [
    '54.187.174.169',
    '54.187.205.235',
    '54.187.216.72',
    '54.241.31.99',
    '54.241.31.102',
    '54.241.34.107',
  ].contains(ipAddress);
}

/// Returns wether the signature is correctly signed and within the
/// tolerated time window.
bool isValidWebhookSignature(String signature, String body, String signingSecret, Duration timeTolerance) {
  Signature sig;
  try {
    sig = Signature(signature);
  } catch (e) {
    log.severe(e);
    return false;
  }
  // Test for valid signature signing.
  if (!sig.isCorrectlySigned(body, signingSecret)) {
    log.severe('The signature is not correctly signed.');
    return false;
  }
  // Test for valid signature timestamp.
  if (!sig.isValidSignatureTimestamp(timeTolerance)) {
    log.severe('The signature is not inside the time tolerance.');
    return false;
  }
  return true;
}

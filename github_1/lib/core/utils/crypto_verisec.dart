import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/export.dart' as pc; // Alias 'pc' for PointyCastle
import 'package:encrypt/encrypt.dart'; // Import directly
import 'package:hex/hex.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:crypto/crypto.dart'; // For HMAC

/// --- Enums ---
enum RsaOperation { encrypt, decrypt }

enum CryptoError { generateKeyPairError }

enum SupportedHashFunction { md5, sha256, sha512 }

// Custom enum to clearly define RSA padding schemes for the method parameter.
// This bridges the gap between how Swift named them and how `encrypt` configures them.
enum RsaPaddingScheme {
  PKCS1, // Corresponds to encrypt.RSAPadding.PKCS1
  OAEP_SHA256, // Corresponds to encrypt.RSAPadding.OAEP with pc.SHA256Digest()
  // Add other specific OAEP_SHAXXX or PSS options here if needed in the future
}

/// --- Extensiones ---

extension DataExtensions on Uint8List {
  /// Convierte una lista de bytes (Uint8List) a una cadena hexadecimal.
  String toHexString() {
    return HEX.encode(this);
  }
}

extension StringExtensions on String {
  /// Convierte una cadena hexadecimal a una lista de bytes (Uint8List).
  /// Retorna `null` si la cadena no es un formato hexadecimal válido.
  Uint8List? hexadecimalToData() {
    try {
      return Uint8List.fromList(HEX.decode(this));
    } catch (e) {
      return null;
    }
  }

  /// Calcula el hash de la cadena usando la función de hash especificada.
  String hash(SupportedHashFunction hashFunction) {
    Uint8List encodedTextData = utf8.encode(this);
    Uint8List digest;

    switch (hashFunction) {
      case SupportedHashFunction.md5:
        final md5Digest = pc.MD5Digest();
        digest = md5Digest.process(encodedTextData);
        break;
      case SupportedHashFunction.sha256:
        final sha256Digest = pc.SHA256Digest();
        digest = sha256Digest.process(encodedTextData);
        break;
      case SupportedHashFunction.sha512:
        final sha512Digest = pc.SHA512Digest();
        digest = sha512Digest.process(encodedTextData);
        break;
    }
    return HEX.encode(digest);
  }

  /// Firma la cadena usando HMAC-SHA256 con una clave simétrica.
  String sign(String key) {
    final hmacKeyBytes = utf8.encode(key);
    final messageBytes = utf8.encode(this);

    final hmac = Hmac(sha256, hmacKeyBytes);
    final digest = hmac.convert(messageBytes);

    return HEX.encode(digest.bytes);
  }

  /// Elimina los encabezados y pies de página de una clave PEM, así como saltos de línea.
  String removeKeyHeaderAndFooter() {
    return replaceAll("-----BEGIN PUBLIC KEY-----", "")
        .replaceAll("-----END PUBLIC KEY-----", "")
        .replaceAll("-----BEGIN PRIVATE KEY-----", "")
        .replaceAll("-----END PRIVATE KEY-----", "")
        .replaceAll("-----BEGIN RSA PUBLIC KEY-----", "")
        .replaceAll("-----END RSA PUBLIC KEY-----", "")
        .replaceAll("-----BEGIN RSA PRIVATE KEY-----", "")
        .replaceAll("-----END RSA PRIVATE KEY-----", "")
        .replaceAll("\n", "")
        .replaceAll("\r", "");
  }
}

class CryptoVerisec {
  /// Cifra un mensaje usando AES-128 con una clave y un IV dados.
  /// Renombrado de 'encrypt' para evitar conflictos.
  String aesEncrypt({
    required String message,
    required String key,
    required String iv,
    bool isHexText = true,
  }) {
    final aesKey = Key.fromUtf8(key);
    final aesIv = IV.fromUtf8(iv);

    final encrypter = Encrypter(
      AES(
        aesKey,
        mode: AESMode.cbc,
        padding: 'PKCS7', // Equivalent to kCCOptionPKCS7Padding
      ),
    );

    final encrypted = isHexText
        ? encrypter.encryptBytes(message.hexadecimalToData()!, iv: aesIv)
        : encrypter.encrypt(message, iv: aesIv);

    return encrypted.bytes.toHexString();
  }

  /// Cifra un mensaje usando AES-128 con hexadecimal key y IV.
  /// Renombrado de 'encryptWithHex' para mantener la consistencia.
  String aesEncryptWithHex({
    required String message,
    required String hexKey,
    required String hexIv,
  }) {
    final aesKey = Key.fromBase64(base64Encode(hexKey.hexadecimalToData()!));
    final aesIv = IV.fromBase64(base64Encode(hexIv.hexadecimalToData()!));

    final encrypter = Encrypter(
      AES(aesKey, mode: AESMode.cbc, padding: 'PKCS7'),
    );

    final messageData = message.hexadecimalToData();
    if (messageData == null) return "";

    final encrypted = encrypter.encryptBytes(messageData, iv: aesIv);
    return encrypted.bytes.toHexString();
  }

  /// Descifra un mensaje cifrado con AES-128 usando una clave y un IV dados.
  /// Renombrado de 'decrypt' para evitar conflictos.
  String aesDecrypt({
    required String encryptedMessage,
    required String key,
    required String iv,
  }) {
    final aesKey = Key.fromUtf8(key);
    final aesIv = IV.fromUtf8(iv);

    final encrypter = Encrypter(
      AES(aesKey, mode: AESMode.cbc, padding: 'PKCS7'),
    );

    final encrypted = Encrypted.fromBase16(encryptedMessage);
    final decrypted = encrypter.decryptBytes(encrypted, iv: aesIv);

    return utf8.decode(decrypted);
  }

  /// Descifra un mensaje cifrado con AES-128 usando hexadecimal key y IV.
  /// Renombrado de 'decryptWithHex' para mantener la consistencia.
  String aesDecryptWithHex({
    required String message,
    required String hexKey,
    required String hexIv,
  }) {
    final aesKey = Key.fromBase64(base64Encode(hexKey.hexadecimalToData()!));
    final aesIv = IV.fromBase64(base64Encode(hexIv.hexadecimalToData()!));

    final encrypter = Encrypter(
      AES(aesKey, mode: AESMode.cbc, padding: 'PKCS7'),
    );

    final encrypted = Encrypted.fromBase16(message);
    final decrypted = encrypter.decryptBytes(encrypted, iv: aesIv);

    return utf8.decode(decrypted);
  }

  /// Generates a random AES-128 key and IV (both 16 bytes) in hexadecimal format.
  (String, String) generateAesKey() {
    final random = Random.secure();
    final keyBytes = Uint8List.fromList(
      List<int>.generate(16, (i) => random.nextInt(256)),
    );
    final ivBytes = Uint8List.fromList(
      List<int>.generate(16, (i) => random.nextInt(256)),
    );

    return (keyBytes.toHexString(), ivBytes.toHexString());
  }

  /// Performs RSA encryption or decryption.
  ///
  /// [key] should be a PEM-formatted public or private key string.
  /// [message] is the data to be processed.
  /// [operation] specifies whether to encrypt or decrypt.
  /// [rsaPadding] specifies the RSA padding scheme to use. Defaults to PKCS1.
  String rsa({
    required String key,
    required String message,
    required RsaOperation operation,
    required RsaPaddingScheme rsaPadding, // Uses custom enum
  }) {
    final strippedKey = key.removeKeyHeaderAndFooter();

    pc.RSAAsymmetricKey? rsaKey;
    try {
      if (operation == RsaOperation.encrypt) {
        rsaKey = CryptoUtils.rsaPublicKeyFromPem(key);
      } else {
        rsaKey = CryptoUtils.rsaPrivateKeyFromPem(key);
      }
    } catch (e) {
      print("Error parsing RSA key: $e");
      return "";
    }

    // Declare RSA instance
    RSA rsaAlgorithm;

    // Use a switch statement to determine the RSA padding based on RsaPaddingScheme
    switch (rsaPadding) {
      case RsaPaddingScheme.PKCS1:
        rsaAlgorithm = RSA(
          publicKey: operation == RsaOperation.encrypt
              ? (rsaKey as pc.RSAPublicKey)
              : null,
          privateKey: operation == RsaOperation.decrypt
              ? (rsaKey as pc.RSAPrivateKey)
              : null,
          encoding: RSAEncoding.PKCS1, // Use encrypt.RSAPadding.PKCS1
        );
        break;
      case RsaPaddingScheme.OAEP_SHA256:
        // For Swift's .rsaEncryptionOAEPSHA256, we specify OAEP padding AND SHA256 digest
        rsaAlgorithm = RSA(
          publicKey: operation == RsaOperation.encrypt
              ? (rsaKey as pc.RSAPublicKey)
              : null,
          privateKey: operation == RsaOperation.decrypt
              ? (rsaKey as pc.RSAPrivateKey)
              : null,
          encoding: RSAEncoding.OAEP, // Use encrypt.RSAPadding.OAEP
          digest: RSADigest.SHA256, // Specify SHA256 for OAEP
        );
        break;
      // You can add more cases for other specific OAEP/hash combinations or PSS if needed
    }

    final encrypter = Encrypter(
      rsaAlgorithm,
    ); // Pass the configured RSA instance

    if (operation == RsaOperation.encrypt) {
      final encrypted = encrypter.encrypt(message, iv: null);
      return encrypted.bytes.toHexString();
    } else {
      final encryptedMessageData = message.hexadecimalToData();
      if (encryptedMessageData == null) return "";
      final encrypted = Encrypted(encryptedMessageData);
      final decrypted = encrypter.decryptBytes(encrypted, iv: null);
      return utf8.decode(decrypted);
    }
  }

  /// Generates a new RSA key pair.
  /// Returns a tuple of (publicKey, privateKey) in PEM format.
  (String, String) generateRsaKeyPair({int keySize = 2048}) {
    final secureRandom = pc.FortunaRandom();
    final seed = List<int>.generate(32, (_) => Random.secure().nextInt(256));
    secureRandom.seed(pc.KeyParameter(Uint8List.fromList(seed)));

    final rsaParameters = pc.RSAKeyGeneratorParameters(
      BigInt.from(65537), // Public exponent F4
      keySize,
      64, // Certainty
    );

    final rsaKeyGenerator = pc.RSAKeyGenerator();
    rsaKeyGenerator.init(pc.ParametersWithRandom(rsaParameters, secureRandom));

    final pc.AsymmetricKeyPair keyPair = rsaKeyGenerator.generateKeyPair();
    final pc.RSAPublicKey publicKey = keyPair.publicKey as pc.RSAPublicKey;
    final pc.RSAPrivateKey privateKey = keyPair.privateKey as pc.RSAPrivateKey;

    final String publicKeyPem = CryptoUtils.encodeRSAPublicKeyToPem(publicKey);
    final String privateKeyPem = CryptoUtils.encodeRSAPrivateKeyToPem(
      privateKey,
    );

    return (publicKeyPem, privateKeyPem);
  }
}

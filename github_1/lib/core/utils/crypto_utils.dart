import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/rendering.dart' hide Key;
import 'package:pointycastle/asymmetric/api.dart';

class CryptoUtils {
  /// Convierte un string hexadecimal a bytes
  static List<int> hexToBytes(String hex) {
    hex = hex.replaceAll(RegExp(r'[^0-9a-fA-F]'), '');
    return List.generate(
      hex.length ~/ 2,
      (i) => int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16),
    );
  }

  /// Convierte bytes a string PEM
  static String bytesToPem(List<int> bytes) {
    final base64Key = base64.encode(bytes);
    final chunks = RegExp(
      '.{1,64}',
    ).allMatches(base64Key).map((m) => m.group(0));
    return [
      '-----BEGIN PUBLIC KEY-----',
      ...chunks,
      '-----END PUBLIC KEY-----',
    ].join('\n');
  }

  /// Convierte un string hexadecimal a String en claro (utf8)
  static String hexToUtf8String(String hex) {
    final bytes = hexToBytes(hex);
    return utf8.decode(bytes);
  }

  /// Convierte un String a hexadecimal (utf8 a hex)
  static String utf8StringToHex(String input) {
    final bytes = utf8.encode(input);
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  /// Convierte una llave pública hexadecimal a String PEM
  static String publicKeyHexToPem(String userPublicKey) {
    final bytes = hexToBytes(userPublicKey);
    return bytesToPem(bytes);
  }

  /// Cifra un mensaje con una llave pública RSA (hexadecimal)
  static String encryptWithPublicKeyHex({
    required String message,
    required String publicKeyHex,
    bool outputHex = false,
  }) {
    // Detecta si es PEM en claro o hex
    final isPem = publicKeyHex.trim().startsWith('-----BEGIN PUBLIC KEY-----');
    final publicKeyPem = isPem
        ? publicKeyHex
        : bytesToPem(hexToBytes(publicKeyHex));
    debugPrint(publicKeyPem);
    final parser = RSAKeyParser();
    final RSAPublicKey publicKey = parser.parse(publicKeyPem) as RSAPublicKey;
    final encrypter = Encrypter(
      RSA(publicKey: publicKey, encoding: RSAEncoding.PKCS1),
    );
    final encrypted = encrypter.encrypt(message);
    return outputHex
        ? encrypted.bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join()
        : encrypted.base64;
  }

  /// Genera una llave y un IV aleatorios de 16 bytes (AES-128), ambos en hexadecimal
  static Map<String, String> generateAesKeyAndIv() {
    final key = Key.fromSecureRandom(16);
    final iv = IV.fromSecureRandom(16);
    return {'key': key.base16, 'iv': iv.base16};
  }

  /// Descifra un mensaje AES-128 CBC en hexadecimal usando key e iv en hexadecimal
  static String aesDecryptHex({
    required String encryptedHex,
    required String keyHex,
    required String ivHex,
  }) {
    final key = Key.fromBase16(keyHex);
    final iv = IV.fromBase16(ivHex);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: null));
    final encrypted = Encrypted.fromBase16(encryptedHex);
    try {
      return encrypter.decrypt(encrypted, iv: iv);
    } catch (e) {
      return '';
    }
  }

  /// Cifra un mensaje AES-128 CBC usando key e iv en hexadecimal
  static String aesEncryptHex({
    required String message,
    required String keyHex,
    required String ivHex,
  }) {
    final key = Key.fromBase16(keyHex);
    final iv = IV.fromBase16(ivHex);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(message, iv: iv);
    return encrypted.base16;
  }

  /// Genera hash MD5, SHA256 o SHA512
  static String hash(String input, HashFunction hashFunction) {
    final bytes = utf8.encode(input);
    late Digest digest;

    switch (hashFunction) {
      case HashFunction.md5:
        digest = md5.convert(bytes);
        break;
      case HashFunction.sha256:
        digest = sha256.convert(bytes);
        break;
      case HashFunction.sha512:
        digest = sha512.convert(bytes);
        break;
    }

    return digest.toString();
  }

  /// Firma HMAC-SHA256
  static String hmacSha256(String message, String key) {
    final keyBytes = utf8.encode(key);
    final messageBytes = utf8.encode(message);
    final hmac = Hmac(sha256, keyBytes);
    final digest = hmac.convert(messageBytes);
    return digest.toString();
  }

  /// Remueve headers y footers de llaves PEM
  static String removeKeyHeaderAndFooter(String key) {
    return key
        .replaceAll('-----BEGIN PUBLIC KEY-----', '')
        .replaceAll('-----END PUBLIC KEY-----', '')
        .replaceAll('-----BEGIN PRIVATE KEY-----', '')
        .replaceAll('-----END PRIVATE KEY-----', '')
        .replaceAll('-----BEGIN RSA PUBLIC KEY-----', '')
        .replaceAll('-----END RSA PUBLIC KEY-----', '')
        .replaceAll('-----BEGIN RSA PRIVATE KEY-----', '')
        .replaceAll('-----END RSA PRIVATE KEY-----', '')
        .replaceAll('\n', '')
        .replaceAll('\r', '');
  }

  /// Descifra un mensaje RSA
  static String rsaDecrypt({
    required String encryptedMessage,
    required String privateKeyPem,
  }) {
    try {
      final parser = RSAKeyParser();
      final privateKey = parser.parse(privateKeyPem) as RSAPrivateKey;
      final encrypter = Encrypter(RSA(privateKey: privateKey));
      final encrypted = Encrypted.fromBase16(encryptedMessage);
      return encrypter.decrypt(encrypted);
    } catch (e) {
      return '';
    }
  }

  /// Cifra o descifra un mensaje RSA (equivalente al método Swift)
  static String rsa({
    required String key,
    required String message,
    required RsaOperation operation,
    RSAEncoding encoding = RSAEncoding.PKCS1,
  }) {
    try {
      final clearKey = removeKeyHeaderAndFooter(key);
      final keyData = base64.decode(clearKey);
      final keyPem = bytesToPem(keyData);

      final parser = RSAKeyParser();

      return operation == RsaOperation.encrypt
          ? _rsaEncrypt(message, keyPem, encoding)
          : _rsaDecrypt(message, keyPem, encoding);
    } catch (e) {
      return '';
    }
  }

  static String _rsaEncrypt(
    String message,
    String publicKeyPem,
    RSAEncoding encoding,
  ) {
    final publicKey = RSAKeyParser().parse(publicKeyPem) as RSAPublicKey;
    final encrypter = Encrypter(RSA(publicKey: publicKey, encoding: encoding));
    final encrypted = encrypter.encrypt(message);
    return encrypted.bytes
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();
  }

  static String _rsaDecrypt(
    String message,
    String privateKeyPem,
    RSAEncoding encoding,
  ) {
    final privateKey = RSAKeyParser().parse(privateKeyPem) as RSAPrivateKey;
    final encrypter = Encrypter(
      RSA(privateKey: privateKey, encoding: encoding),
    );
    final encrypted = Encrypted.fromBase16(message);
    return encrypter.decrypt(encrypted);
  }

  /// Cifra un mensaje con RSA OAEP SHA256
  static String encryptWithPublicKeyOAEP({
    required String message,
    required String publicKeyPem,
    bool outputHex = true,
  }) {
    try {
      final parser = RSAKeyParser();
      final publicKey = parser.parse(publicKeyPem) as RSAPublicKey;
      final encrypter = Encrypter(
        RSA(publicKey: publicKey, encoding: RSAEncoding.OAEP),
      );
      final encrypted = encrypter.encrypt(message);
      return outputHex
          ? encrypted.bytes
                .map((b) => b.toRadixString(16).padLeft(2, '0'))
                .join()
          : encrypted.base64;
    } catch (e) {
      return '';
    }
  }
}

enum HashFunction { md5, sha256, sha512 }

enum RsaOperation { encrypt, decrypt }

package com.example.encryption_file;

import android.util.Base64;
import android.util.Log;
import java.security.NoSuchAlgorithmException;
import javax.crypto.Cipher;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

public class CryptoHelper {
    static String keyValue;
    private final IvParameterSpec ivSpec;
    private final SecretKeySpec keySpec;
    private Cipher cipher;
    private final static String ivKey = "RF22SW76BV83EDH8"; //16 char secret key

    public CryptoHelper() {
        ivSpec = new IvParameterSpec(ivKey.getBytes());
        keySpec = new SecretKeySpec(keyValue.getBytes(), "AES");
        try {
            cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        } catch (NoSuchAlgorithmException | NoSuchPaddingException e) {
            e.printStackTrace();
        }
    }

    public static String encrypt(String valueToEncrypt, String key) throws Exception {
        keyValue = key;
        CryptoHelper enc = new CryptoHelper();
        return Base64.encodeToString(enc.encryptInternal(valueToEncrypt), Base64.DEFAULT);
    }

    public static String decrypt(String valueToDecrypt, String key) throws Exception {
        keyValue = key;
        CryptoHelper enc = new CryptoHelper();
        return new String(enc.decryptInternal(valueToDecrypt));
    }

    private byte[] encryptInternal(String text) throws Exception {
        if (text == null || text.length() == 0) {
            throw new Exception("Empty string");
        }
        byte[] encrypted;
        try {
            cipher.init(Cipher.ENCRYPT_MODE, keySpec, ivSpec);
            encrypted = cipher.doFinal(text.getBytes());
        } catch (Exception e) {
            throw new Exception("[encrypt] " + e.getMessage());
        }
        return encrypted;
    }

    private byte[] decryptInternal(String code) throws Exception {
        if (code == null || code.length() == 0) {
            throw new Exception("Empty string");
        }
        byte[] decrypted;
        try {
            cipher.init(Cipher.DECRYPT_MODE, keySpec, ivSpec);
            decrypted = cipher.doFinal(Base64.decode(code, Base64.DEFAULT));
        } catch (Exception e) {
            throw new Exception("[decrypt] " + e.getMessage());
        }
        return decrypted;
    }
}

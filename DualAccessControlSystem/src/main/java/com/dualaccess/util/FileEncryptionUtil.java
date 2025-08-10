package com.dualaccess.util;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;
import java.util.Base64;

public class FileEncryptionUtil {

    private static final String ALGORITHM = "AES";

    // ✅ Load AES Key securely from environment variable
    public static SecretKey getMasterKeyFromEnv() throws Exception {
        String base64Key = System.getenv("AES_MASTER_KEY");
        if (base64Key == null || base64Key.isEmpty()) {
            throw new IllegalStateException("❌ AES_MASTER_KEY is not set in the environment.");
        }

        byte[] decodedKey = Base64.getDecoder().decode(base64Key);
        return new SecretKeySpec(decodedKey, 0, decodedKey.length, ALGORITHM);
    }

    public static byte[] encrypt(byte[] inputBytes, SecretKey key) throws Exception {
        Cipher cipher = Cipher.getInstance(ALGORITHM);
        cipher.init(Cipher.ENCRYPT_MODE, key);
        return cipher.doFinal(inputBytes);
    }

    public static byte[] decrypt(byte[] encryptedBytes, SecretKey key) throws Exception {
        Cipher cipher = Cipher.getInstance(ALGORITHM);
        cipher.init(Cipher.DECRYPT_MODE, key);
        return cipher.doFinal(encryptedBytes);
    }
}

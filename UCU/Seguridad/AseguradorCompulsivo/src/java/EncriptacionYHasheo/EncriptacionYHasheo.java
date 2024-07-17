/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package EncriptacionYHasheo;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.security.Key;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.Signature;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import org.apache.commons.codec.binary.Hex;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import static org.apache.commons.codec.binary.Base64.encodeBase64;
import org.apache.tomcat.util.codec.binary.Base64;
import static org.apache.tomcat.util.codec.binary.Base64.decodeBase64;
//import static org.apache.tomcat.util.net.SSLHostConfigCertificate.Type.RSA;
//import static org.apache.tomcat.util.net.openssl.ciphers.Authentication.RSA;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

/**
 *
 * @author user
 */
public class EncriptacionYHasheo {
    public static String hashing(String cadena) throws NoSuchAlgorithmException{
        MessageDigest md = null;
        md= MessageDigest.getInstance("SHA-512");
        md.update(cadena.getBytes());
        byte[] mb = md.digest();
        
        return String.valueOf(Hex.encodeHex(mb));
    }
    
    private static String encriptarCoso(String cadena) throws Exception {
        String key = "92AE31A79FEEB2A3"; //llave
        String iv = "0123456789ABCDEF"; // vector de inicialización
        //System.out.println("Texto encriptado: "+encrypt.StringEncrypt.encrypt(key, iv,cleartext));
        //System.out.println("Texto desencriptado: "+encrypt.StringEncrypt.decrypt(key, iv,encrypt.StringEncrypt.encrypt(key, iv,cleartext)));
        
        return encrypt(key, iv, cadena);
    }
    
    private static String desEncriptarCoso(String cadena) throws Exception {
        String key = "92AE31A79FEEB2A3"; // llave
        String iv = "0123456789ABCDEF"; // vector de inicialización
        //System.out.println("Texto encriptado: "+encrypt.StringEncrypt.encrypt(key, iv,cleartext));
        //System.out.println("Texto desencriptado: "+encrypt.StringEncrypt.decrypt(key, iv,encrypt.StringEncrypt.encrypt(key, iv,cleartext)));
        
        return decrypt(key, iv, cadena);
    }
    
    // Definición del tipo de algoritmo a utilizar (AES, DES, RSA)
    private final static String alg = "AES";
    // Definición del modo de cifrado a utilizar
    private final static String cI = "AES";
 
    /**
     * Función de tipo String que recibe una llave (key), un vector de inicialización (iv)
     * y el texto que se desea cifrar
     * @param key la llave en tipo String a utilizar
     * @param iv el vector de inicialización a utilizar
     * @param cleartext el texto sin cifrar a encriptar
     * @return el texto cifrado en modo String
     * @throws Exception puede devolver excepciones de los siguientes tipos: NoSuchAlgorithmException, InvalidKeyException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, NoSuchPaddingException
     */
    public static String encrypt(String key, String iv, String cleartext) throws Exception {
            /*Cipher cipher = Cipher.getInstance(cI);
            SecretKeySpec skeySpec = new SecretKeySpec(key.getBytes(), alg);
            IvParameterSpec ivParameterSpec = new IvParameterSpec(iv.getBytes());
            cipher.init(Cipher.ENCRYPT_MODE, skeySpec, ivParameterSpec);
            byte[] encrypted = cipher.doFinal(cleartext.getBytes());
            return new String(encodeBase64(encrypted));*/
            
            try {
                IvParameterSpec vectObj = new IvParameterSpec(iv.getBytes("UTF-8"));
                SecretKeySpec skeySpec = new SecretKeySpec(key.getBytes("UTF-8"), "AES");

                Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5PADDING");
                cipher.init(Cipher.ENCRYPT_MODE, skeySpec, vectObj);

                byte[] encrypted = cipher.doFinal(cleartext.getBytes());
                return Base64.encodeBase64String(encrypted);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            
            return null;
    }
    
    public static String md5(String texto) throws NoSuchAlgorithmException{
        MessageDigest md = null;
        md= MessageDigest.getInstance("MD5");
        md.update(texto.getBytes());
        byte[] mb = md.digest();
        
        return String.valueOf(Hex.encodeHex(mb));
    }
 
    /**
     * Función de tipo String que recibe una llave (key), un vector de inicialización (iv)
     * y el texto que se desea descifrar
     * @param key la llave en tipo String a utilizar
     * @param iv el vector de inicialización a utilizar
     * @param encrypted el texto cifrado en modo String
     * @return el texto desencriptado en modo String
     * @throws Exception puede devolver excepciones de los siguientes tipos: NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException, IllegalBlockSizeException
     */
    public static String decrypt(String key, String iv, String encrypted) throws Exception {
            /*Cipher cipher = Cipher.getInstance(cI);
            SecretKeySpec skeySpec = new SecretKeySpec(key.getBytes(), alg);
            IvParameterSpec ivParameterSpec = new IvParameterSpec(iv.getBytes());
            byte[] enc = decodeBase64(encrypted);
            cipher.init(Cipher.DECRYPT_MODE, skeySpec, ivParameterSpec);
            byte[] decrypted = cipher.doFinal(enc);
            return new String(decrypted);*/
            
            try {
                IvParameterSpec vectObj = new IvParameterSpec(iv.getBytes("UTF-8"));
                SecretKeySpec skeySpec = new SecretKeySpec(key.getBytes("UTF-8"), "AES");

                Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5PADDING");
                cipher.init(Cipher.DECRYPT_MODE, skeySpec, vectObj);
                byte[] original = cipher.doFinal(Base64.decodeBase64(encrypted));

                return new String(original);
            } catch (Exception ex) {
                ex.printStackTrace();
            }

            return null;
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    public static byte[] encrypt(String key2, String vector, byte[] textoPlano) throws Exception {
      // Alternativamente, una clave que queramos que tenga al menos 16 bytes
      // y nos quedamos con los bytes 0 a 15
      Key key = new SecretKeySpec(key2.getBytes(), "AES");
      //IvParameterSpec vectObj = new IvParameterSpec("92AE31A79FEEB2A3".getBytes("UTF-8"));
      IvParameterSpec vectObj = new IvParameterSpec(vector.getBytes("UTF-8"));
      //92AE31A79FEEB2A3
      // Ver como se puede guardar esta clave en un fichero y recuperarla
      // posteriormente en la clase RSAAsymetricCrypto.java

      // Texto a encriptar

      // Se obtiene un cifrador AES
      //Cipher aes = Cipher.getInstance("AES/ECB/PKCS5Padding");
      Cipher aes = Cipher.getInstance("AES/CBC/PKCS5Padding");

      // Se inicializa para encriptacion y se encripta el texto,
      // que debemos pasar como bytes.
      aes.init(Cipher.ENCRYPT_MODE, key, vectObj);
      byte[] encriptado = aes.doFinal(textoPlano);
      
      return encriptado;
    }
    
    public static byte[] decrypt(String key2, String vector, byte[] textoEncriptado) throws Exception {
      Key key = new SecretKeySpec(key2.getBytes(), "AES");
//      IvParameterSpec vectObj = new IvParameterSpec("92AE31A79FEEB2A3".getBytes("UTF-8"));
      IvParameterSpec vectObj = new IvParameterSpec(vector.getBytes("UTF-8"));
      
      // Se obtiene un cifrador AES
      //Cipher aes = Cipher.getInstance("AES/ECB/PKCS5Padding");
      Cipher aes = Cipher.getInstance("AES/CBC/PKCS5Padding");
      
      // Se iniciliza el cifrador para desencriptar, con la
      // misma clave y se desencripta
      aes.init(Cipher.DECRYPT_MODE, key, vectObj);
      
      byte[] desencriptado = aes.doFinal(textoEncriptado);
      
      return desencriptado;
    }
    
    public static byte[] encryptRSA(byte[] textoPlano, String clavePrivada) throws Exception {
        PKCS8EncodedKeySpec specPriv = new PKCS8EncodedKeySpec(Base64.decodeBase64(clavePrivada));
        KeyFactory kf = KeyFactory.getInstance("RSA");
        PrivateKey privateKey = kf.generatePrivate(specPriv);
        
        // Obtener la clase para encriptar/desencriptar
        Cipher rsa = Cipher.getInstance("RSA/ECB/PKCS1Padding");

        // Se encripta
        rsa.init(Cipher.ENCRYPT_MODE, privateKey);
        byte[] encriptado = rsa.doFinal(textoPlano);
        
        return encriptado;
    }
    
    /*
    public static byte[] decryptRSA(byte[] textoEncriptado, String clavePublica) throws Exception {
        X509EncodedKeySpec spec = new X509EncodedKeySpec(Base64.decodeBase64(clavePublica));
        KeyFactory kf = KeyFactory.getInstance("RSA");
        PublicKey publicKey = kf.generatePublic(spec);
        
        // Obtener la clase para encriptar/desencriptar
        Cipher rsa = Cipher.getInstance("RSA/ECB/PKCS1Padding");

        // Se desencripta
        rsa.init(Cipher.DECRYPT_MODE, publicKey);
        byte[] bytesDesencriptados = rsa.doFinal(textoEncriptado);
        
        return bytesDesencriptados;
    }

    public static byte[] signFile(byte[] archivoBytes, String clavePrivada) {
        byte[] pSignature = new byte[1024];
        Signature sign;
        FileInputStream inStream;

        try {
            PKCS8EncodedKeySpec specPriv = new PKCS8EncodedKeySpec(Base64.decodeBase64(clavePrivada));
            KeyFactory kf = KeyFactory.getInstance("RSA");
            PrivateKey privateKey = kf.generatePrivate(specPriv);

            //Creamos la firma
            sign = Signature.getInstance("SHA256withRSA");

            //Firmamos el archivo y lo actualizamos
            sign.initSign(privateKey);
            sign.update(archivoBytes);

            //Almacenamos la firma
            pSignature = sign.sign();
            
        } catch (Exception ex) {
            String holui = "HOOOOOOOLUUUUUUU";
        }
        
        return pSignature;
        
    }*/
    
    public static byte[] decryptRSA(byte[] textoEncriptado, byte[] clavePublica) throws Exception {
        X509EncodedKeySpec spec = new X509EncodedKeySpec(Base64.decodeBase64(clavePublica));
        KeyFactory kf = KeyFactory.getInstance("RSA");
        PublicKey publicKey = kf.generatePublic(spec);
        
        // Obtener la clase para encriptar/desencriptar
        Cipher rsa = Cipher.getInstance("RSA/ECB/PKCS1Padding");

        // Se desencripta
        rsa.init(Cipher.DECRYPT_MODE, publicKey);
        byte[] bytesDesencriptados = rsa.doFinal(textoEncriptado);
        
        return bytesDesencriptados;
    }

    public static byte[] signFile(byte[] archivoBytes, byte[] clavePrivada) {
        byte[] pSignature = new byte[1024];
        Signature sign;
        FileInputStream inStream;

        try {
            /*PKCS8EncodedKeySpec specPriv = new PKCS8EncodedKeySpec(Base64.decodeBase64(clavePrivada));
            KeyFactory kf = KeyFactory.getInstance("RSA");
            PrivateKey privateKey = kf.generatePrivate(specPriv);*/

            PrivateKey privateKey = getPrivateKeyFromFile(clavePrivada);
            //Creamos la firma
            sign = Signature.getInstance("SHA256withRSA");

            //Firmamos el archivo y lo actualizamos
            sign.initSign(privateKey);
            sign.update(archivoBytes);

            //Almacenamos la firma
            pSignature = sign.sign();
            
        } catch (Exception ex) {
            String holui = "HOOOOOOOLUUUUUUU";
        }
        
        return pSignature;
    }
    
    public static boolean verificarFirma(byte[] firmaBytes, byte[] pClavePublica, byte[] archivoBytes) {
        boolean retorno = false;
        
        try {
            PublicKey publicKey = getPublicKeyFromFile(pClavePublica);
            
            /*X509EncodedKeySpec spec = new X509EncodedKeySpec(Base64.decodeBase64(clavePublica));
            KeyFactory kf = KeyFactory.getInstance("RSA");
            PublicKey publicKey = kf.generatePublic(spec);*/

            Signature sign = Signature.getInstance("SHA256withRSA");
            sign.initVerify(publicKey);
            
            sign.update(archivoBytes, 0, archivoBytes.length);
            retorno = sign.verify(firmaBytes);
            
        } catch (Exception ex) {
            String holui = "HOOOOOOOLUUUUUUU";
        }

        return retorno;
    }
    
    
    
    
    
    
    
    
    
    
    
    
    public static void generarParDeClaves() {
        try {
            // Generar el par de claves
            KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance("RSA");
            KeyPair keyPair = keyPairGenerator.generateKeyPair();
            PublicKey publicKey = keyPair.getPublic();
            PrivateKey privateKey = keyPair.getPrivate();
            
            String tiempo = String.valueOf(System.currentTimeMillis());
            saveToDiskPrivateKey(privateKey, tiempo);
            saveToDiskPublicKey(publicKey, tiempo);
            
            String publicString = new String(Base64.encodeBase64(publicKey.getEncoded()));
            String privateString = new String(Base64.encodeBase64(privateKey.getEncoded()));
        }
        catch (Exception ex) {
            
        }
    }
    
    public static void saveToDiskPrivateKey(PrivateKey privateKey, String tiempo) {
		try {
                        byte[] privateKeyBytes = privateKey.getEncoded();

                        
                        FileOutputStream fos = new FileOutputStream("Archivos/" + tiempo + "_privateKey.priv");
                        fos.write(privateKeyBytes);
                        fos.close();
		} catch (Exception e) {
                    
		}
	}
	
	public static void saveToDiskPublicKey(PublicKey publicKey, String tiempo) {
		try {
			byte[] publicKeyBytes = publicKey.getEncoded();

                        FileOutputStream fos = new FileOutputStream("Archivos/" + tiempo + "_publicKey.pub");
                        fos.write(publicKeyBytes);
                        fos.close();
		} catch (Exception e) {
			// TODO: handle exception
		}
	}
        
        public static PublicKey getPublicKeyFromFile(byte[] pPublico) throws Exception{
            PublicKey pk = null;

            X509EncodedKeySpec spec = new X509EncodedKeySpec(pPublico);
            KeyFactory kf = KeyFactory.getInstance("RSA");
            pk = kf.generatePublic(spec);
            
            return pk;
        }
        
        public static PrivateKey getPrivateKeyFromFile(byte[] pPrivado) throws Exception{
            PrivateKey pk = null;
            
            PKCS8EncodedKeySpec specPriv = new PKCS8EncodedKeySpec(pPrivado);
            KeyFactory kf = KeyFactory.getInstance("RSA");
            pk = kf.generatePrivate(specPriv);
            
            return pk;
        }
        
        /*public static Key getKeyFromFile(String fileName) throws Exception{
            Key pk = null;
            File f = new File(fileName);
            FileInputStream fis = new FileInputStream(f);
            DataInputStream dis = new DataInputStream(fis);
            byte[] keyBytes = new byte[(int)f.length()];
            dis.readFully(keyBytes);
            dis.close();

            X509EncodedKeySpec spec = new X509EncodedKeySpec(keyBytes);
            KeyFactory kf = KeyFactory.getInstance("RSA");
            pk = kf.generatePublic(spec);
            return pk;
        }*/
}

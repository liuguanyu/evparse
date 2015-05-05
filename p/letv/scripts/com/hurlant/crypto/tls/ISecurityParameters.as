package com.hurlant.crypto.tls
{
   import ͠.version;
   import ͠.reset;
   import ͠.getBulkCipher;
   import ͠.getCipherType;
   import ͠.getMacAlgorithm;
   import ͠.setCipher;
   import ͠.setCompression;
   import ͠.setPreMasterSecret;
   import flash.utils.ByteArray;
   import ͠.setClientRandom;
   import ͠.setServerRandom;
   import ͠.useRSA;
   import ͠.computeVerifyData;
   import ͠.computeCertificateVerify;
   import ͠.getConnectionStates;
   
   public interface ISecurityParameters
   {
      
      ͠ function get version() : uint;
      
      ͠ function reset() : void;
      
      ͠ function getBulkCipher() : uint;
      
      ͠ function getCipherType() : uint;
      
      ͠ function getMacAlgorithm() : uint;
      
      ͠ function setCipher(param1:uint) : void;
      
      ͠ function setCompression(param1:uint) : void;
      
      ͠ function setPreMasterSecret(param1:ByteArray) : void;
      
      ͠ function setClientRandom(param1:ByteArray) : void;
      
      ͠ function setServerRandom(param1:ByteArray) : void;
      
      ͠ function get useRSA() : Boolean;
      
      ͠ function computeVerifyData(param1:uint, param2:ByteArray) : ByteArray;
      
      ͠ function computeCertificateVerify(param1:uint, param2:ByteArray) : ByteArray;
      
      ͠ function getConnectionStates() : Object;
   }
}

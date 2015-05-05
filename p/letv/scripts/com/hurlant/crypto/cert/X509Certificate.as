package com.hurlant.crypto.cert
{
   import flash.utils.ByteArray;
   import com.hurlant.util.der.PEM;
   import com.hurlant.util.der.DER;
   import com.hurlant.util.der.Type;
   import com.hurlant.crypto.rsa.RSAKey;
   import com.hurlant.crypto.hash.IHash;
   import com.hurlant.crypto.hash.SHA1;
   import com.hurlant.util.der.OID;
   import com.hurlant.crypto.hash.MD2;
   import com.hurlant.crypto.hash.MD5;
   import ȴ.hash;
   import com.hurlant.util.ArrayUtil;
   import com.hurlant.util.der.Sequence;
   import com.hurlant.util.der.ObjectIdentifier;
   import com.hurlant.util.der.ByteString;
   import com.hurlant.util.Base64;
   import com.hurlant.util.der.PrintableString;
   
   public class X509Certificate extends Object
   {
      
      private var _loaded:Boolean;
      
      private var _param;
      
      private var _obj:Object;
      
      public function X509Certificate(param1:*)
      {
         super();
         this._loaded = false;
         this._param = param1;
      }
      
      private function load() : void
      {
         var _loc2_:ByteArray = null;
         if(this._loaded)
         {
            return;
         }
         var _loc1_:* = this._param;
         if(_loc1_ is String)
         {
            _loc2_ = PEM.readCertIntoArray(_loc1_ as String);
         }
         else if(_loc1_ is ByteArray)
         {
            _loc2_ = _loc1_;
         }
         
         if(_loc2_ != null)
         {
            this._obj = DER.parse(_loc2_,Type.TLS_CERT);
            this._loaded = true;
            return;
         }
         throw new Error("Invalid x509 Certificate parameter: " + _loc1_);
      }
      
      public function isSigned(param1:X509CertificateCollection, param2:X509CertificateCollection, param3:Date = null) : Boolean
      {
         this.load();
         if(param3 == null)
         {
            var param3:Date = new Date();
         }
         var _loc4_:Date = this.getNotBefore();
         var _loc5_:Date = this.getNotAfter();
         if(param3.getTime() < _loc4_.getTime())
         {
            return false;
         }
         if(param3.getTime() > _loc5_.getTime())
         {
            return false;
         }
         var _loc6_:String = this.getIssuerPrincipal();
         var _loc7_:X509Certificate = param2.getCertificate(_loc6_);
         var _loc8_:* = false;
         if(_loc7_ == null)
         {
            _loc7_ = param1.getCertificate(_loc6_);
            if(_loc7_ == null)
            {
               return false;
            }
         }
         else
         {
            _loc8_ = true;
         }
         if(_loc7_ == this)
         {
            return false;
         }
         if(!((_loc8_) && (_loc7_.isSelfSigned(param3))) && !_loc7_.isSigned(param1,param2,param3))
         {
            return false;
         }
         var _loc9_:RSAKey = _loc7_.getPublicKey();
         return this.verifyCertificate(_loc9_);
      }
      
      public function isSelfSigned(param1:Date) : Boolean
      {
         this.load();
         var _loc2_:RSAKey = this.getPublicKey();
         return this.verifyCertificate(_loc2_);
      }
      
      private function verifyCertificate(param1:RSAKey) : Boolean
      {
         var _loc3_:IHash = null;
         var _loc4_:String = null;
         var _loc2_:String = this.getAlgorithmIdentifier();
         switch(_loc2_)
         {
            case OID.SHA1_WITH_RSA_ENCRYPTION:
               _loc3_ = new SHA1();
               _loc4_ = OID.SHA1_ALGORITHM;
               break;
            case OID.MD2_WITH_RSA_ENCRYPTION:
               _loc3_ = new MD2();
               _loc4_ = OID.MD2_ALGORITHM;
               break;
            case OID.MD5_WITH_RSA_ENCRYPTION:
               _loc3_ = new MD5();
               _loc4_ = OID.MD5_ALGORITHM;
               break;
            default:
               return false;
         }
         var _loc5_:ByteArray = this._obj.signedCertificate_bin;
         var _loc6_:ByteArray = new ByteArray();
         param1.verify(this._obj.encrypted,_loc6_,this._obj.encrypted.length);
         _loc6_.position = 0;
         _loc5_ = _loc3_.hash(_loc5_);
         var _loc7_:Object = DER.parse(_loc6_,Type.RSA_SIGNATURE);
         if(_loc7_.algorithm.algorithmId.toString() != _loc4_)
         {
            return false;
         }
         if(!ArrayUtil.equals(_loc7_.hash,_loc5_))
         {
            return false;
         }
         return true;
      }
      
      private function signCertificate(param1:RSAKey, param2:String) : ByteArray
      {
         var _loc3_:IHash = null;
         var _loc4_:String = null;
         switch(param2)
         {
            case OID.SHA1_WITH_RSA_ENCRYPTION:
               _loc3_ = new SHA1();
               _loc4_ = OID.SHA1_ALGORITHM;
               break;
            case OID.MD2_WITH_RSA_ENCRYPTION:
               _loc3_ = new MD2();
               _loc4_ = OID.MD2_ALGORITHM;
               break;
            case OID.MD5_WITH_RSA_ENCRYPTION:
               _loc3_ = new MD5();
               _loc4_ = OID.MD5_ALGORITHM;
               break;
            default:
               return null;
         }
         var _loc5_:ByteArray = this._obj.signedCertificate_bin;
         _loc5_ = _loc3_.hash(_loc5_);
         var _loc6_:Sequence = new Sequence();
         _loc6_[0] = new Sequence();
         _loc6_[0][0] = new ObjectIdentifier(0,0,_loc4_);
         _loc6_[0][1] = null;
         _loc6_[1] = new ByteString();
         _loc6_[1].writeBytes(_loc5_);
         _loc5_ = _loc6_.toDER();
         var _loc7_:ByteArray = new ByteArray();
         param1.sign(_loc5_,_loc7_,_loc5_.length);
         return _loc7_;
      }
      
      public function getPublicKey() : RSAKey
      {
         this.load();
         var _loc1_:ByteArray = this._obj.signedCertificate.subjectPublicKeyInfo.subjectPublicKey as ByteArray;
         _loc1_.position = 0;
         var _loc2_:Object = DER.parse(_loc1_,[{"name":"N"},{"name":"E"}]);
         return new RSAKey(_loc2_.N,_loc2_.E.valueOf());
      }
      
      public function getSubjectPrincipal() : String
      {
         this.load();
         return Base64.encodeByteArray(this._obj.signedCertificate.subject_bin);
      }
      
      public function getIssuerPrincipal() : String
      {
         this.load();
         return Base64.encodeByteArray(this._obj.signedCertificate.issuer_bin);
      }
      
      public function getAlgorithmIdentifier() : String
      {
         return this._obj.algorithmIdentifier.algorithmId.toString();
      }
      
      public function getNotBefore() : Date
      {
         return this._obj.signedCertificate.validity.notBefore.date;
      }
      
      public function getNotAfter() : Date
      {
         return this._obj.signedCertificate.validity.notAfter.date;
      }
      
      public function getCommonName() : String
      {
         var _loc1_:Sequence = this._obj.signedCertificate.subject;
         return (_loc1_.findAttributeValue(OID.COMMON_NAME) as PrintableString).getString();
      }
   }
}

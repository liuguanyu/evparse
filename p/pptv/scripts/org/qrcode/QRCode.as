package org.qrcode
{
   import flash.events.IEventDispatcher;
   import flash.display.BitmapData;
   import org.qrcode.enum.QRCodeEncodeType;
   import org.qrcode.input.QRInput;
   import org.qrcode.utils.QRCodeTool;
   import flash.geom.Point;
   import org.qrcode.specs.QRSpecs;
   import org.qrcode.enum.QRCodeErrorLevel;
   import org.qrcode.encode.QRRawCode;
   import org.qrcode.utils.FrameFiller;
   import mx.events.PropertyChangeEvent;
   import flash.events.EventDispatcher;
   import flash.events.Event;
   
   public class QRCode extends Object implements IEventDispatcher
   {
      
      private var data:Array;
      
      private var level:int;
      
      private var type:int;
      
      private var version:int = 1;
      
      private var width:int;
      
      private var text:String;
      
      private var _1743837831bitmapData:BitmapData;
      
      private var _bindingEventDispatcher:EventDispatcher;
      
      public function QRCode(param1:int = 0.0, param2:int = 2.0)
      {
         this.data = [];
         this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
         super();
         this.level = param1;
         this.type = param2;
      }
      
      public function encode(param1:String) : void
      {
         this.version = 1;
         this.text = param1;
         this.encodeString(true);
         this.encodeBitmap();
      }
      
      private function encodeBitmap() : void
      {
         this.bitmapData = QRImage.image(this.data);
      }
      
      private function encodeString(param1:Boolean = true) : void
      {
         if(!(this.type == QRCodeEncodeType.QRCODE_ENCODE_BYTES) && !(this.type == QRCodeEncodeType.QRCODE_ENCODE_KANJI))
         {
            throw new Error("bad hint");
         }
         else
         {
            var _loc2_:QRInput = new QRInput(this.version,this.level);
            if(_loc2_ == null)
            {
               return;
            }
            _loc2_ = QRSplit.splitStringToQRinput(this.text,_loc2_,this.type,param1);
            var _loc3_:Array = this.encodeInput(_loc2_);
            this.data = QRCodeTool.binarize(_loc3_);
            return;
         }
      }
      
      private function encodeMask(param1:QRInput, param2:int) : QRCode
      {
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         var _loc9_:Array = null;
         var _loc10_:* = 0;
         var _loc11_:* = 0;
         var _loc12_:Point = null;
         if(param1.version < 0 || param1.version > QRSpecs.QRSPEC_VERSION_MAX)
         {
            throw new Error("wrong version");
         }
         else if(param1.errorCorrectionLevel > QRCodeErrorLevel.QRCODE_ERROR_LEVEL_HIGH)
         {
            throw new Error("wrong level");
         }
         else
         {
            var _loc3_:QRRawCode = new QRRawCode(param1);
            this.version = _loc3_.version;
            this.width = QRSpecs.getWidth(this.version);
            var _loc4_:Array = QRSpecs.newFrame(this.version);
            var _loc5_:FrameFiller = new FrameFiller(this.width,_loc4_);
            if(_loc5_ == null)
            {
               return null;
            }
            _loc6_ = 0;
            while(_loc6_ < _loc3_.dataLength + _loc3_.eccLength)
            {
               _loc10_ = _loc3_.getCode();
               _loc11_ = 128;
               _loc7_ = 0;
               while(_loc7_ < 8)
               {
                  _loc12_ = _loc5_.next();
                  _loc5_.setFrameAt(_loc12_,2 | int(!((_loc11_ & _loc10_) == 0)));
                  _loc11_ = _loc11_ >> 1;
                  _loc7_++;
               }
               _loc6_++;
            }
            _loc7_ = QRSpecs.getRemainder(this.version);
            _loc6_ = 0;
            while(_loc6_ < _loc7_)
            {
               _loc12_ = _loc5_.next();
               _loc5_.setFrameAt(_loc12_,2);
               _loc6_++;
            }
            _loc4_ = _loc5_.frame;
            var _loc8_:QRMask = new QRMask(_loc4_);
            if(param2 < 0)
            {
               _loc9_ = _loc8_.mask(this.width,param1.errorCorrectionLevel);
            }
            else
            {
               _loc9_ = _loc8_.makeMask(this.width,param2,param1.errorCorrectionLevel);
            }
            if(_loc9_ == null)
            {
               return null;
            }
            this.data = _loc9_;
            return this;
         }
         
      }
      
      private function encodeInput(param1:QRInput) : Array
      {
         return this.encodeMask(param1,-1).data;
      }
      
      private function encodeString8bit(param1:String, param2:int, param3:int) : Array
      {
         if(param1 == "")
         {
            throw new Error("empty string!");
         }
         else
         {
            var _loc4_:QRInput = new QRInput(param2,param3);
            if(_loc4_ == null)
            {
               return null;
            }
            var _loc5_:int = _loc4_.append(QRCodeEncodeType.QRCODE_ENCODE_BYTES,param1.length,param1.split(""));
            if(_loc5_ < 0)
            {
               return null;
            }
            return this.data = QRCodeTool.binarize(this.encodeInput(_loc4_));
         }
      }
      
      public function get bitmapData() : BitmapData
      {
         return this._1743837831bitmapData;
      }
      
      public function set bitmapData(param1:BitmapData) : void
      {
         var _loc2_:Object = this._1743837831bitmapData;
         if(_loc2_ !== param1)
         {
            this._1743837831bitmapData = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bitmapData",_loc2_,param1));
            }
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
   }
}

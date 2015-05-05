package cn.pplive.player.utils
{
   import flash.utils.ByteArray;
   
   public class FlvParser extends Object
   {
      
      private static var _hasVideoTags:Boolean = true;
      
      private static var _hasAudioTags:Boolean = true;
      
      private static const TAG_TYPE_AUDIO:int = 8;
      
      private static const TAG_TYPE_VIDEO:int = 9;
      
      private static const TAG_TYPE_SCRIPT:int = 18;
      
      private static const TAG_HEADER_BYTE_COUNT:int = 11;
      
      private static const PREV_TAG_BYTE_COUNT:int = 4;
      
      private var rtmpAccess:Array;
      
      private var initTimestamp:int = 0;
      
      private var isFirstTag:Boolean = true;
      
      private var prevData:ByteArray;
      
      public function FlvParser()
      {
         this.rtmpAccess = [18,0,0,24,0,0,0,0,0,0,0,2,0,17,124,82,116,109,112,83,97,109,112,108,101,65,99,99,101,115,115,1,1,1,1,0,0,0,35];
         this.prevData = new ByteArray();
         super();
      }
      
      public function writeHeader() : ByteArray
      {
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeByte(70);
         _loc1_.writeByte(76);
         _loc1_.writeByte(86);
         _loc1_.writeByte(1);
         var _loc2_:uint = 0;
         if(_hasAudioTags)
         {
            _loc2_ = _loc2_ | 4;
         }
         if(_hasVideoTags)
         {
            _loc2_ = _loc2_ | 1;
         }
         _loc1_.writeByte(_loc2_);
         _loc1_.writeUnsignedInt(9);
         _loc1_.writeUnsignedInt(0);
         var _loc3_:ByteArray = new ByteArray();
         var _loc4_:* = 0;
         while(_loc4_ < this.rtmpAccess.length)
         {
            _loc3_.writeByte(this.rtmpAccess[_loc4_]);
            _loc4_++;
         }
         _loc1_.writeBytes(_loc3_);
         return _loc1_;
      }
      
      private function writeUI24(param1:*, param2:uint) : void
      {
         param1.writeByte(param2 >> 16 & 255);
         param1.writeByte(param2 >> 8 & 255);
         param1.writeByte(param2 & 255);
      }
      
      private function writeUI16(param1:*, param2:uint) : void
      {
         param1.writeByte(param2 >> 8);
         param1.writeByte(param2 & 255);
      }
      
      private function writeUI4_12(param1:*, param2:uint, param3:uint) : void
      {
         param1.writeByte((param2 << 4) + (param3 >> 8));
         param1.writeByte(param3 & 255);
      }
      
      public function getTagTimestamp(param1:ByteArray) : ByteArray
      {
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         var _loc8_:* = 0;
         var _loc9_:* = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc2_:ByteArray = this.prevData;
         _loc2_.writeBytes(param1);
         this.prevData = new ByteArray();
         var _loc3_:ByteArray = new ByteArray();
         var _loc4_:* = 0;
         try
         {
            loop0:
            while(true)
            {
               while(_loc4_ < _loc2_.length)
               {
                  if(_loc2_[_loc4_] == TAG_TYPE_AUDIO || _loc2_[_loc4_] == TAG_TYPE_VIDEO || _loc2_[_loc4_] == TAG_TYPE_SCRIPT)
                  {
                     if(_loc4_ + 3 >= _loc2_.length)
                     {
                        break loop0;
                     }
                     _loc5_ = _loc4_ + 1;
                     _loc6_ = _loc2_[_loc4_ + 1] << 16;
                     _loc6_ = _loc6_ | _loc2_[_loc4_ + 2] << 8;
                     _loc6_ = _loc6_ | _loc2_[_loc4_ + 3];
                     if(_loc4_ + TAG_HEADER_BYTE_COUNT + _loc6_ + 4 >= _loc2_.length - 1)
                     {
                        break loop0;
                     }
                     _loc7_ = _loc4_ + TAG_HEADER_BYTE_COUNT + _loc6_;
                     _loc8_ = _loc2_[_loc7_ + 1] << 16;
                     _loc8_ = _loc8_ | _loc2_[_loc7_ + 2] << 8;
                     _loc8_ = _loc8_ | _loc2_[_loc7_ + 3];
                     if(_loc8_ == _loc6_ + TAG_HEADER_BYTE_COUNT)
                     {
                        _loc9_ = _loc4_ + 4;
                        _loc10_ = _loc2_[_loc9_ + 3] << 24;
                        _loc10_ = _loc10_ | _loc2_[_loc9_ + 0] << 16;
                        _loc10_ = _loc10_ | _loc2_[_loc9_ + 1] << 8;
                        _loc10_ = _loc10_ | _loc2_[_loc9_ + 2];
                        if((this.isFirstTag) && !(_loc10_ == 0))
                        {
                           this.initTimestamp = _loc10_;
                           this.isFirstTag = false;
                        }
                        _loc11_ = _loc10_ != 0?_loc10_ - this.initTimestamp:0;
                        _loc3_.writeBytes(_loc2_,_loc4_,4);
                        this.writeUI24(_loc3_,_loc11_);
                        _loc3_.writeByte(_loc11_ >> 24 & 255);
                        _loc3_.writeBytes(_loc2_,_loc4_ + 8,3 + _loc6_ + 4);
                        _loc4_ = _loc4_ + (_loc8_ + 4);
                     }
                     else
                     {
                        _loc4_++;
                     }
                     continue loop0;
                  }
                  _loc4_++;
               }
               return _loc3_;
            }
            this.prevData.writeBytes(_loc2_,_loc4_);
         }
         catch(evt:Error)
         {
         }
         return _loc3_;
      }
   }
}

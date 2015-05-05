package com.hls_p2p.loaders.descLoader
{
   import com.hls_p2p.data.vo.class_2;
   import com.hls_p2p.data.vo.Clip;
   import com.p2p.utils.console;
   import com.hls_p2p.data.vo.LiveVodConfig;
   import com.hls_p2p.statistics.Statistic;
   import com.hls_p2p.data.LIVE_TIME;
   import com.p2p.utils.ParseUrl;
   
   public class ParseM3U8_uniform extends Object
   {
      
      private static var var_290:Number = 0;
      
      {
         var_290 = 0;
      }
      
      public var isDebug:Boolean = true;
      
      private var var_181:Number = 0;
      
      private var var_182:Boolean = true;
      
      public var groupID:String = "";
      
      public var width:Number = 0;
      
      public var height:Number = 0;
      
      public var totalDuration:Number = 0;
      
      public var mediaDuration:Number = 0;
      
      public function ParseM3U8_uniform()
      {
         super();
      }
      
      public function method_203(param1:*, param2:class_2, param3:Function, param4:String = "", param5:Array = null, param6:Array = null) : Boolean
      {
         var _loc9_:String = null;
         var _loc15_:Clip = null;
         var _loc17_:Object = null;
         var _loc20_:* = NaN;
         var _loc21_:Array = null;
         if("" == param1)
         {
            return false;
         }
         var _loc7_:* = "";
         var _loc8_:Object = {
            "fileMSG":new Object(),
            "dataMSG":new Object()
         };
         var _loc10_:* = false;
         if(param2.encrypt)
         {
            _loc9_ = param2.encrypt["decodeB2T"](param1);
            if(!_loc9_ || _loc9_ == "")
            {
               return false;
            }
         }
         else
         {
            _loc9_ = param1;
         }
         _loc9_ = _loc9_.replace(new RegExp("\\r","g"),"");
         console.log(this,"\r\n" + _loc9_);
         var _loc11_:RegExp = new RegExp("(\\.ts\\S{0,})\\n","ig");
         _loc9_ = _loc9_.replace(_loc11_,this.method_207);
         var _loc12_:Array = _loc9_.split("~_~");
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc16_:Object = new Object();
         var _loc18_:Vector.<Clip> = new Vector.<Clip>();
         var _loc19_:* = "";
         _loc13_ = 0;
         while(_loc13_ < _loc12_.length)
         {
            _loc21_ = _loc12_[_loc13_].split("\n");
            _loc15_ = new Clip();
            if(0 != _loc13_)
            {
               _loc14_ = 0;
               for(; _loc14_ < _loc21_.length; _loc14_++)
               {
                  if(_loc21_[_loc14_].length > 0)
                  {
                     _loc17_ = this.method_206(_loc21_[_loc14_]);
                     if((_loc17_) && (_loc17_.hasOwnProperty("key")))
                     {
                        if(_loc17_["key"] != "")
                        {
                           if(_loc17_["key"] == "pieceInfoArray")
                           {
                              _loc15_.pieceInfoArray.push(_loc17_["value"]);
                              continue;
                           }
                           _loc15_[_loc17_["key"]] = _loc17_["value"];
                           if(_loc17_["key"] == "timestamp")
                           {
                              if(this.hasOwnProperty("DESC_LASTSTARTTIME"))
                              {
                                 this["DESC_LASTSTARTTIME"] = _loc17_["value"];
                              }
                           }
                           else if(_loc17_["key"] == "url_ts")
                           {
                              _loc15_.name = this.method_208(_loc17_["value"]);
                           }
                           
                        }
                     }
                     else
                     {
                        _loc17_ = this.method_205(_loc21_[_loc14_]);
                        if((_loc17_) && (_loc17_.hasOwnProperty("key")))
                        {
                           if(_loc17_["key"] != "")
                           {
                              if("M3U8_ERROR" == _loc17_["key"])
                              {
                                 return false;
                              }
                              if(!(LiveVodConfig.TYPE == LiveVodConfig.LIVE) && (this.hasOwnProperty(_loc17_["key"])))
                              {
                                 this[_loc17_["key"]] = _loc17_["value"];
                              }
                              else if(LiveVodConfig.TYPE == LiveVodConfig.LIVE && (this.hasOwnProperty(_loc17_["key"])) && !(_loc17_["key"] == "totalDuration"))
                              {
                                 this[_loc17_["key"]] = _loc17_["value"];
                              }
                              
                           }
                        }
                        continue;
                     }
                  }
               }
            }
            else if(0 == _loc13_)
            {
               _loc14_ = 0;
               for(; _loc14_ < _loc21_.length; _loc14_++)
               {
                  if(_loc21_[_loc14_].length > 0)
                  {
                     _loc17_ = this.method_204(_loc21_[_loc14_]);
                     if((_loc17_) && (_loc17_.hasOwnProperty("key")))
                     {
                        if(_loc17_["key"] != "")
                        {
                           if(_loc17_["key"] == "EXT_LETV_M3U8_VER")
                           {
                              _loc7_ = _loc17_["value"];
                           }
                        }
                     }
                     else
                     {
                        _loc17_ = this.method_205(_loc21_[_loc14_]);
                        if((_loc17_) && (_loc17_.hasOwnProperty("key")))
                        {
                           if(_loc17_["key"] != "")
                           {
                              if("M3U8_ERROR" == _loc17_["key"])
                              {
                                 return false;
                              }
                              if(!(LiveVodConfig.TYPE == LiveVodConfig.LIVE) && (this.hasOwnProperty(_loc17_["key"])))
                              {
                                 this[_loc17_["key"]] = _loc17_["value"];
                              }
                              else if(LiveVodConfig.TYPE == LiveVodConfig.LIVE && (this.hasOwnProperty(_loc17_["key"])) && !(_loc17_["key"] == "totalDuration"))
                              {
                                 this[_loc17_["key"]] = _loc17_["value"];
                              }
                              
                           }
                        }
                        else
                        {
                           _loc17_ = this.method_206(_loc21_[_loc14_]);
                           if((_loc17_) && (_loc17_.hasOwnProperty("key")))
                           {
                              if(_loc17_["key"] != "")
                              {
                                 if(_loc17_["key"] == "pieceInfoArray")
                                 {
                                    _loc15_.pieceInfoArray.push(_loc17_["value"]);
                                    continue;
                                 }
                                 _loc15_[_loc17_["key"]] = _loc17_["value"];
                                 if(_loc17_["key"] == "timestamp")
                                 {
                                    if(var_290 == 0)
                                    {
                                       var_290 = _loc17_["value"];
                                    }
                                    else if(var_290 == _loc17_["value"])
                                    {
                                       var_290 = _loc17_["value"];
                                    }
                                    
                                    if(this.hasOwnProperty("DESC_LASTSTARTTIME"))
                                    {
                                       this["DESC_LASTSTARTTIME"] = _loc17_["value"];
                                    }
                                 }
                                 else if(_loc17_["key"] == "url_ts")
                                 {
                                    _loc15_.name = this.method_208(_loc17_["value"]);
                                 }
                                 
                              }
                           }
                           continue;
                        }
                     }
                  }
               }
            }
            
            if(LiveVodConfig.TYPE == LiveVodConfig.VOD)
            {
               if(LiveVodConfig.IS_CHANGE_KBPS == false)
               {
                  _loc15_.groupID = this.groupID + _loc7_ + LiveVodConfig.method_264();
                  if(false == param2.var_53)
                  {
                     LiveVodConfig.currentVid = _loc15_.groupID;
                  }
                  if(true == param2.var_53 && false == param2.var_54)
                  {
                     LiveVodConfig.nextVid = _loc15_.groupID;
                  }
                  _loc15_.var_2 = this.groupID;
               }
               else
               {
                  _loc15_.groupID = this.groupID + _loc7_ + LiveVodConfig.method_264();
                  if((param2.method_70) && (param2.method_70[0]["kbps"]) && param4 == param2.method_70[0]["kbps"])
                  {
                     LiveVodConfig.currentChangeVid = _loc15_.groupID;
                  }
                  _loc15_.var_2 = this.groupID;
               }
            }
            else
            {
               _loc15_.groupID = this.groupID + _loc7_ + LiveVodConfig.method_264();
               _loc15_.var_2 = this.groupID;
            }
            _loc15_.width = this.width;
            _loc15_.height = this.height;
            _loc15_.totalDuration = this.totalDuration;
            _loc15_.mediaDuration = this.mediaDuration;
            _loc15_.playerKbps = param4;
            if(_loc15_.name != "")
            {
               if(_loc15_.timestamp == 0)
               {
                  console.log(this,"_clip.timestamp is 0" + _loc15_.url_ts);
               }
               _loc18_.push(_loc15_);
               if(_loc18_.length == 2)
               {
                  _loc18_[0].nextID = _loc18_[1].timestamp;
                  _loc19_ = _loc19_ + (" bID:" + _loc18_[0].timestamp + " nextID:" + _loc18_[0].nextID + " duration:" + _loc18_[0].duration + " discontinuity:" + _loc18_[0].discontinuity + " pieceInfo:" + _loc18_[0].pieceInfoArray + " name:" + _loc18_[0].name + " groupID:" + _loc18_[0].groupID + "\n");
                  param3(_loc18_.shift(),_loc20_,param5,param6);
                  _loc10_ = true;
               }
            }
            _loc13_++;
         }
         if(LiveVodConfig.currentChangeVid == "" || false == LiveVodConfig.IS_CHANGE_KBPS)
         {
            if(LiveVodConfig.currentVid == _loc15_.groupID)
            {
               param2.totalDuration = this.totalDuration;
               param2.mediaDuration = this.mediaDuration;
               param2.totalSize = this.var_181;
            }
            else if(LiveVodConfig.TYPE != LiveVodConfig.LIVE)
            {
               param2.var_65.totalDuration = this.totalDuration;
               param2.var_65.mediaDuration = this.mediaDuration;
               param2.var_65.totalSize = this.var_181;
               Statistic.method_261().method_95("loadNextM3U8 ok",_loc15_.groupID);
            }
            
         }
         else
         {
            param2.var_62 = this.totalDuration;
            param2.var_63 = this.mediaDuration;
            param2.var_64 = this.var_181;
         }
         if(_loc18_.length == 1 && LIVE_TIME.method_260() - LiveVodConfig.method_267 > 30)
         {
            console.log(this,"返回m3u8一个");
         }
         if(_loc18_.length > 0)
         {
            LiveVodConfig.method_267 = _loc18_[_loc18_.length - 1].timestamp;
         }
         _loc20_ = 0;
         if(LiveVodConfig.TYPE != LiveVodConfig.LIVE)
         {
            _loc20_ = Math.round(this.var_181 * 8 / this.totalDuration / 1024);
         }
         if(_loc18_.length > 0)
         {
            _loc19_ = _loc19_ + (" bID:" + _loc18_[0].timestamp + " nextID:" + _loc18_[0].nextID + " duration:" + _loc18_[0].duration + " discontinuity:" + _loc18_[0].discontinuity + " pieceInfo:" + _loc18_[0].pieceInfoArray + " name:" + _loc18_[0].name + " groupID:" + _loc18_[0].groupID + "\n");
            _loc10_ = true;
         }
         console.log(this,"clip:\n" + _loc19_);
         param3(_loc18_.shift(),_loc20_,param5,param6);
         return _loc10_;
      }
      
      private function method_204(param1:String) : Object
      {
         var _loc2_:Object = new Object();
         var _loc3_:* = "";
         var _loc4_:String = param1;
         var _loc5_:int = _loc4_.indexOf(":");
         _loc4_ = _loc4_.substr(0,_loc5_ + 1);
         switch(_loc4_)
         {
            case "#EXTM3U":
               _loc2_.key = "";
               break;
            case "#EXT-X-VERSION:":
               _loc2_.key = "";
               break;
            case "#EXT-X-MEDIA-SEQUENCE:":
               _loc2_.key = "";
               break;
            case "#EXT-X-ALLOW-CACHE:":
               _loc2_.key = "";
               break;
            case "#EXT-X-TARGETDURATION:":
               _loc2_.key = "";
               break;
            case "#EXT-LETV-M3U8-TYPE:":
               _loc3_ = this.getValue(param1,"#EXT-LETV-M3U8-TYPE:");
               if(_loc3_ != "")
               {
                  _loc2_.key = "str_EXT_LETV_M3U8_TYPE";
                  _loc2_.value = _loc3_;
                  return _loc2_;
               }
               break;
            case "#EXT-LETV-M3U8-VER:":
               _loc3_ = this.getValue(param1,"#EXT-LETV-M3U8-VER:");
               if(_loc3_ != "")
               {
                  _loc2_.key = "EXT_LETV_M3U8_VER";
                  _loc2_.value = _loc3_;
                  return _loc2_;
               }
               break;
         }
         return _loc2_;
      }
      
      private function method_205(param1:String) : Object
      {
         var _loc2_:Object = new Object();
         var _loc3_:* = "";
         var _loc4_:String = param1;
         var _loc5_:int = _loc4_.indexOf(":");
         if(-1 != _loc5_)
         {
            _loc4_ = _loc4_.substr(0,_loc5_ + 1);
         }
         switch(_loc4_)
         {
            case "#EXT-LETV-X-DISCONTINUITY:":
               _loc2_.key = "";
               break;
            case "#EXT-LETV-PROGRAM-ID:":
               _loc3_ = this.getValue(param1,"#EXT-LETV-PROGRAM-ID:");
               if(_loc3_ != "")
               {
                  _loc2_.key = "groupID";
                  _loc2_.value = _loc3_;
                  return _loc2_;
               }
               break;
            case "#EXT-LETV-PIC-WIDTH:":
               _loc3_ = this.getValue(param1,"#EXT-LETV-PIC-WIDTH:");
               if(_loc3_ != "")
               {
                  _loc2_.key = "width";
                  _loc2_.value = _loc3_;
                  return _loc2_;
               }
               break;
            case "#EXT-LETV-PIC-HEIGHT:":
               _loc3_ = this.getValue(param1,"#EXT-LETV-PIC-HEIGHT:");
               if(_loc3_ != "")
               {
                  _loc2_.key = "height";
                  _loc2_.value = _loc3_;
                  return _loc2_;
               }
               break;
            case "#EXT-LETV-TOTAL-TS-LENGTH:":
               _loc2_.key = "";
               break;
            case "#EXT-LETV-TOTAL-ES-LENGTH:":
               _loc2_.key = "";
               break;
            case "#EXT-LETV-TOTAL-SEGMENT:":
               _loc2_.key = "";
               break;
            case "#EXT-LETV-TOTAL-P2P-PIECE:":
               _loc2_.key = "";
               break;
            case "#EXT-LETV-TOTAL-DURATION:":
               _loc3_ = this.getValue(param1,"#EXT-LETV-TOTAL-DURATION:");
               if(_loc3_ != "")
               {
                  _loc2_.key = "totalDuration";
                  _loc2_.value = _loc3_;
                  return _loc2_;
               }
               break;
            case "#EXT-LETV-TOTAL-MEDIADURATION:":
               _loc3_ = this.getValue(param1,"#EXT-LETV-TOTAL-MEDIADURATION:");
               if(_loc3_ != "")
               {
                  _loc2_.key = "mediaDuration";
                  _loc2_.value = _loc3_;
                  return _loc2_;
               }
               break;
            case "#EXT-LETV-M3U8-ERRCODE:":
               _loc3_ = this.getValue(param1,"#EXT-LETV-M3U8-ERRCODE:");
               if(_loc3_ != "")
               {
                  LiveVodConfig.EXT_LETV_M3U8_ERRCODE = _loc3_;
                  return false;
               }
         }
         return _loc2_;
      }
      
      private function method_206(param1:String) : Object
      {
         var _loc5_:* = 0;
         var _loc2_:Object = new Object();
         var _loc3_:* = "";
         var _loc4_:String = param1;
         if(_loc4_.indexOf("#") != -1)
         {
            _loc5_ = _loc4_.indexOf(":");
            if(-1 != _loc5_)
            {
               _loc4_ = _loc4_.substr(0,_loc5_ + 1);
            }
            switch(_loc4_)
            {
               case "#EXT-X-DISCONTINUITY":
                  _loc2_.key = "discontinuity";
                  _loc2_.value = 1;
                  return _loc2_;
               case "#EXT-LETV-START-TIME:":
                  _loc3_ = this.getValue(param1,"#EXT-LETV-START-TIME:");
                  if(_loc3_ != "")
                  {
                     _loc2_.key = "timestamp";
                     _loc2_.value = parseFloat(_loc3_);
                     return _loc2_;
                  }
                  break;
               case "#EXT-LETV-P2P-PIECE-NUMBER:":
                  _loc3_ = this.getValue(param1,"#EXT-LETV-P2P-PIECE-NUMBER:");
                  if(_loc3_ != "")
                  {
                     _loc2_.key = "p2pPieceNumber";
                     _loc2_.value = _loc3_;
                     return _loc2_;
                  }
                  break;
               case "#EXT-LETV-SEGMENT-ID:":
                  _loc3_ = this.getValue(param1,"#EXT-LETV-SEGMENT-ID:");
                  if(_loc3_ != "")
                  {
                     _loc2_.key = "sequence";
                     _loc2_.value = int(_loc3_);
                     return _loc2_;
                  }
                  break;
               case "#EXT-LETV-CKS:":
                  _loc3_ = this.getValue(param1,"#EXT-LETV-CKS:");
                  if(_loc3_ != "")
                  {
                     _loc2_.key = "pieceInfoArray";
                     _loc2_.value = _loc3_;
                     _loc2_.size = parseFloat(ParseUrl.getParam(_loc2_.value,"SZ"));
                     this.var_181 = this.var_181 + _loc2_.size;
                     return _loc2_;
                  }
                  break;
               case "#EXTINF:":
                  _loc3_ = this.getValue(param1,"#EXTINF:");
                  if(_loc3_ != "")
                  {
                     _loc2_.key = "duration";
                     _loc2_.value = parseFloat(_loc3_);
                     return _loc2_;
                  }
                  break;
            }
         }
         else if(_loc4_.length > 0)
         {
            _loc2_.key = "url_ts";
            _loc2_.value = _loc4_;
            return _loc2_;
         }
         
         return null;
      }
      
      private function getValue(param1:String, param2:String) : String
      {
         var _loc3_:* = "";
         if(param1.indexOf(param2) == 0)
         {
            _loc3_ = param1.replace(param2,"");
         }
         return _loc3_;
      }
      
      public function method_207(param1:String, param2:String, param3:int, param4:String) : String
      {
         return param2 + "~_~";
      }
      
      private function method_208(param1:String) : String
      {
         var _loc2_:* = "";
         _loc2_ = ParseUrl.parseUrl(param1).path;
         if(null == _loc2_)
         {
            return param1;
         }
         var _loc3_:Number = _loc2_.lastIndexOf("/");
         _loc2_ = _loc2_.substr(_loc3_ + 1,_loc2_.length);
         return _loc2_;
      }
   }
}

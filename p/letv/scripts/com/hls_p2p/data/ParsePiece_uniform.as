package com.hls_p2p.data
{
   import com.p2p.utils.ParseUrl;
   import com.hls_p2p.data.vo.LiveVodConfig;
   import com.p2p.utils.console;
   
   public class ParsePiece_uniform extends Object
   {
      
      public var isDebug:Boolean = false;
      
      private var var_8:class_3;
      
      public function ParsePiece_uniform(param1:class_3)
      {
         super();
         this.var_8 = param1;
      }
      
      public function method_126(param1:Array, param2:String, param3:String, param4:Object, param5:Array, param6:Number) : void
      {
         var _loc7_:uint = 0;
         _loc7_ = 0;
         var _loc8_:Piece = null;
         var _loc9_:* = "";
         _loc7_ = 0;
         while(_loc7_ < param1.length)
         {
            _loc8_ = new Piece(this.var_8);
            _loc8_.id = _loc7_;
            _loc8_.groupID = param2;
            _loc8_.var_2 = param3;
            _loc8_.checkSum = ParseUrl.getParam(String(param1[_loc7_]),"CKS");
            _loc8_.size = int(ParseUrl.getParam(String(param1[_loc7_]),"SZ"));
            if(_loc8_.size == 0)
            {
               _loc8_.from = "http";
               _loc8_.name_1 = true;
               _loc8_.iLoadType = 3;
            }
            _loc8_.type = String(param1[_loc7_]).indexOf("PN") > -1?"PN":String(param1[_loc7_]).indexOf("TN") > -1?"TN":"";
            _loc8_.pieceKey = ParseUrl.getParam(String(param1[_loc7_]),_loc8_.type);
            if(!param4)
            {
               var param4:Object = new Object();
            }
            if(param4[_loc8_.groupID] == null)
            {
               param4[_loc8_.groupID] = new Object();
            }
            if(param4[_loc8_.groupID][_loc8_.type] == null)
            {
               param4[_loc8_.groupID][_loc8_.type] = new Object();
            }
            if(param4[_loc8_.groupID][_loc8_.type][_loc8_.pieceKey] == null)
            {
               _loc8_.blockIDArray.push(param6);
               if(LiveVodConfig.TYPE == LiveVodConfig.LIVE)
               {
                  _loc8_.var_25 = Math.random() < LiveVodConfig.DAT_LOAD_RATE?true:false;
                  if(true == _loc8_.var_25)
                  {
                     this.var_8.name_2.push({
                        "piece":_loc8_,
                        "blockID":param6
                     });
                  }
               }
               param4[_loc8_.groupID][_loc8_.type][_loc8_.pieceKey] = _loc8_;
               param5.push({
                  "groupID":_loc8_.groupID,
                  "type":_loc8_.type,
                  "pieceKey":_loc8_.pieceKey
               });
               if(0 == _loc7_ || 1 == _loc7_ || _loc7_ == param1.length - 1)
               {
                  _loc9_ = _loc9_ + (_loc7_ + " key:" + _loc8_.pieceKey + " bID:" + param6 + " type:" + _loc8_.type + "\n");
               }
            }
            else if(-1 == param4[_loc8_.groupID][_loc8_.type][_loc8_.pieceKey].blockIDArray.indexOf(param6))
            {
               param4[_loc8_.groupID][_loc8_.type][_loc8_.pieceKey].blockIDArray.push(param6);
               param5.push({
                  "groupID":_loc8_.groupID,
                  "type":_loc8_.type,
                  "pieceKey":_loc8_.pieceKey
               });
            }
            
            _loc7_++;
         }
         console.log(this,"emptyPiece:\n" + _loc9_);
         this.var_8 = null;
      }
   }
}

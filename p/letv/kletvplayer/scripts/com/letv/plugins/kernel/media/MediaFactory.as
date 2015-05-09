package com.letv.plugins.kernel.media
{
   import com.letv.plugins.kernel.model.Model;
   import com.letv.plugins.kernel.interfaces.IMedia;
   import com.letv.plugins.kernel.media.p2p.P2P_M3U8_TryMedia;
   import com.letv.plugins.kernel.media.p2p.P2P_FLV_TryMedia;
   import com.letv.plugins.kernel.media.p2p.P2P_M3U8_VodMedia;
   import com.letv.plugins.kernel.media.http.m3u8.HTTP_M3U8_VodMedia;
   import com.letv.plugins.kernel.media.p2p.P2P_FLV_VodMedia;
   import com.letv.plugins.kernel.media.http.dataMode.HTTPDataMedia;
   
   public class MediaFactory extends Object
   {
      
      public function MediaFactory()
      {
         super();
      }
      
      public static function getP2PLibURL(param1:Model, param2:String) : String
      {
         if(param2 == PlayMode.P2P_VOD)
         {
            return param1.config.p2pflvurl;
         }
         return param1.config.p2pm3u8url;
      }
      
      public static function getMediaType(param1:Model) : String
      {
         if(param1.isTrylook)
         {
            if(param1.isM3U8)
            {
               return PlayMode.P2P_M3U8_TRY;
            }
            return PlayMode.P2P_TRY;
         }
         if(param1.isM3U8)
         {
            if(param1.config.p2p)
            {
               return PlayMode.P2P_M3U8_VOD;
            }
            return PlayMode.HTTP_M3U8_VOD;
         }
         if(param1.config.p2p)
         {
            return PlayMode.P2P_VOD;
         }
         return PlayMode.HTTP_DATA;
      }
      
      public static function isP2P(param1:String) : Boolean
      {
         return param1 == PlayMode.P2P_VOD || param1 == PlayMode.P2P_M3U8_VOD;
      }
      
      public static function create(param1:Model, param2:Boolean = true) : IMedia
      {
         if(param1.isTrylook)
         {
            if(param1.isM3U8)
            {
               return P2P_M3U8_TryMedia.getInstance();
            }
            return P2P_FLV_TryMedia.getInstance();
         }
         if(param1.isM3U8)
         {
            if(!(param1.p2p.p2pM3U8 == null) && (param1.config.p2p) && (param1.gslb.usep2p) && (param2))
            {
               return P2P_M3U8_VodMedia.getInstance();
            }
            return HTTP_M3U8_VodMedia.getInstance();
         }
         if((param1.config.p2p) && (param1.gslb.usep2p) && (param2) && !(param1.p2p.p2pFLV == null))
         {
            return P2P_FLV_VodMedia.getInstance();
         }
         return HTTPDataMedia.getInstance();
      }
   }
}

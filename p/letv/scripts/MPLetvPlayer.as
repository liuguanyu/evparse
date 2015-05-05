package
{
   import flash.display.Sprite;
   import flash.net.NetStream;
   import com.hls_p2p.stream.HTTPNetStream;
   import flash.system.Security;
   
   public class MPLetvPlayer extends Sprite
   {
      
      private var object;
      
      public function MPLetvPlayer()
      {
         super();
         Security.allowDomain("*");
         Security.allowInsecureDomain("*");
      }
      
      public function create() : NetStream
      {
         if(this.object)
         {
            this.object.close();
            this.object = null;
         }
         this.object = new HTTPNetStream({"playType":"VOD"});
         return this.object as NetStream;
      }
   }
}

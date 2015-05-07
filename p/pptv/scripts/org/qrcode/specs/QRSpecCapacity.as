package org.qrcode.specs
{
   public class QRSpecCapacity extends Object
   {
      
      private static const capacity:Array = [[0,0,0,[0,0,0,0]],[21,26,0,[7,10,13,17]],[25,44,7,[10,16,22,28]],[29,70,7,[15,26,36,44]],[33,100,7,[20,36,52,64]],[37,134,7,[26,48,72,88]],[41,172,7,[36,64,96,112]],[45,196,0,[40,72,108,130]],[49,242,0,[48,88,132,156]],[53,292,0,[60,110,160,192]],[57,346,0,[72,130,192,224]],[61,404,0,[80,150,224,264]],[65,466,0,[96,176,260,308]],[69,532,0,[104,198,288,352]],[73,581,3,[120,216,320,384]],[77,655,3,[132,240,360,432]],[81,733,3,[144,280,408,480]],[85,815,3,[168,308,448,532]],[89,901,3,[180,338,504,588]],[93,991,3,[196,364,546,650]],[97,1085,3,[224,416,600,700]],[101,1156,4,[224,442,644,750]],[105,1258,4,[252,476,690,816]],[109,1364,4,[270,504,750,900]],[113,1474,4,[300,560,810,960]],[117,1588,4,[312,588,870,1050]],[121,1706,4,[336,644,952,1110]],[125,1828,4,[360,700,1020,1200]],[129,1921,3,[390,728,1050,1260]],[133,2051,3,[420,784,1140,1350]],[137,2185,3,[450,812,1200,1440]],[141,2323,3,[480,868,1290,1530]],[145,2465,3,[510,924,1350,1620]],[149,2611,3,[540,980,1440,1710]],[153,2761,3,[570,1036,1530,1800]],[157,2876,0,[570,1064,1590,1890]],[161,3034,0,[600,1120,1680,1980]],[165,3196,0,[630,1204,1770,2100]],[169,3362,0,[660,1260,1860,2220]],[173,3532,0,[720,1316,1950,2310]],[177,3706,0,[750,1372,2040,2430]]];
      
      public var width:int;
      
      public var words:int;
      
      public var remainder:uint;
      
      public var ec:Array;
      
      public function QRSpecCapacity(param1:int)
      {
         super();
         this.width = capacity[param1][0];
         this.words = capacity[param1][1];
         this.remainder = capacity[param1][2];
         this.ec = capacity[param1][3];
      }
   }
}
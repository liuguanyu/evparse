package com.qiyi.player.base.uuid
{
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import com.qiyi.player.base.utils.MD5;
	import flash.utils.getTimer;
	import flash.net.SharedObject;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import flash.net.URLRequest;
	import com.adobe.serialization.json.JSON;
	
	public class UUIDManager extends EventDispatcher
	{
		
		public static const READY:String = "ready";
		
		private static var _instance:UUIDManager = null;
		
		private const COOKIE:String = "qiyi_statistics";
		
		private const UUID_URL:String = "http://data.video.qiyi.com/uid";
		
		private const MAX_RETRY:int = 3;
		
		private var _inited:Boolean = false;
		
		private var _uuid:String = "";
		
		private var _webEventId:String = "";
		
		private var _videoEventID:String = "";
		
		private var _isNewUser:Boolean = false;
		
		private var _loader:URLLoader;
		
		private var _curRetryCount:int = 0;
		
		private var _timeout:uint = 0;
		
		public function UUIDManager(param1:SingletonClass)
		{
			super();
			this.load();
		}
		
		public static function get instance() : UUIDManager
		{
			if(_instance == null)
			{
				_instance = new UUIDManager(new SingletonClass());
			}
			return _instance;
		}
		
		public function load() : void
		{
			if(!this._inited)
			{
				this.loadFromLocal();
				if(this._uuid == null || !(this._uuid.length == 32))
				{
					this.loadFromServer();
				}
				this._inited = true;
			}
		}
		
		public function get uuid() : String
		{
			if(this._uuid)
			{
				return this._uuid;
			}
			return "";
		}
		
		public function get isNewUser() : Boolean
		{
			return this._isNewUser;
		}
		
		public function set isNewUser(param1:Boolean) : void
		{
			this._isNewUser = param1;
		}
		
		public function buildVideoEventID() : void
		{
			this._videoEventID = MD5.calculate(this._uuid + getTimer() + Math.random());
		}
		
		public function getVideoEventID() : String
		{
			return this._videoEventID;
		}
		
		public function setWebEventID(param1:String) : void
		{
			this._webEventId = param1;
		}
		
		public function getWebEventID() : String
		{
			return this._webEventId;
		}
		
		private function loadFromLocal() : void
		{
			var so:SharedObject = null;
			try
			{
				so = SharedObject.getLocal(this.COOKIE,"/");
				this._uuid = so.data.uuid;
				if(this._uuid == null || !(this._uuid.length == 32) || (UUIDManager.inList(this._uuid)))
				{
					this._uuid = "";
					so.data.uuid = this._uuid;
					so.flush();
				}
			}
			catch(e:Error)
			{
				_uuid = "";
			}
		}
		
		private function loadFromServer() : void
		{
			this._isNewUser = true;
			if(this._loader)
			{
				this._loader.removeEventListener(Event.COMPLETE,this.onCompleteHandler);
				this._loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onErrorHander);
				this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onErrorHander);
			}
			this._loader = new URLLoader();
			this._loader.addEventListener(Event.COMPLETE,this.onCompleteHandler);
			this._loader.addEventListener(IOErrorEvent.IO_ERROR,this.onErrorHander);
			this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onErrorHander);
			clearTimeout(this._timeout);
			this._timeout = setTimeout(this.onErrorHander,2000);
			this._loader.load(new URLRequest(this.UUID_URL + "?tn=" + Math.random()));
		}
		
		private function retry() : void
		{
			if(this._curRetryCount < this.MAX_RETRY)
			{
				this._curRetryCount++;
				this.loadFromServer();
			}
			else
			{
				this.onCompleteHandler();
			}
		}
		
		private function onErrorHander(param1:Event = null) : void
		{
			clearTimeout(this._timeout);
			this.retry();
		}
		
		private function onCompleteHandler(param1:Event = null) : void
		{
			var strContent:String = null;
			var indexLift:int = 0;
			var indexRight:int = 0;
			var obj:Object = null;
			var so:SharedObject = null;
			var event:Event = param1;
			clearTimeout(this._timeout);
			this.loadFromLocal();
			if(this._uuid)
			{
				dispatchEvent(new Event(READY));
			}
			else
			{
				try
				{
					if(event)
					{
						strContent = this._loader.data;
						indexLift = strContent.indexOf("{");
						indexRight = strContent.indexOf("}",-1);
						strContent = strContent.slice(indexLift,indexRight + 1);
						obj = com.adobe.serialization.json.JSON.decode(strContent);
						this._uuid = obj.uid;
					}
					else
					{
						this._uuid = "";
					}
				}
				catch(e:Error)
				{
					_uuid = "";
				}
				if(this._uuid == null || this._uuid == "")
				{
					this._uuid = UUIDManager.createUUID();
				}
				try
				{
					so = SharedObject.getLocal(this.COOKIE,"/");
					so.data.uuid = this._uuid;
					so.flush();
				}
				catch(e:Error)
				{
				}
				dispatchEvent(new Event(READY));
			}
			if(this._uuid)
			{
				return;
			}
		}
	}
}

class SingletonClass extends Object
{
	
	function SingletonClass()
	{
		super();
	}
}

class UUID extends Object
{
	
	function UUID()
	{
		super();
	}
	
	public static function createUUID() : String
	{
		var _loc1:Array = new Array("8","9","A","B");
		var _loc2:String = createRandomIdentifier(8,15) + "-" + createRandomIdentifier(4,15) + "-4" + createRandomIdentifier(3,15) + "-" + _loc1[randomIntegerWithinRange(0,3)] + createRandomIdentifier(3,15) + "-" + createRandomIdentifier(12,15);
		return _loc2;
	}
	
	private static function createRandomIdentifier(param1:uint, param2:uint = 61) : String
	{
		var _loc3:Array = new Array("0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z");
		var _loc4:Array = new Array();
		var param2:uint = param2 > 61?61:param2;
		while(param1--)
		{
			_loc4.push(_loc3[randomIntegerWithinRange(0,param2)]);
		}
		return _loc4.join("");
	}
	
	private static function randomWithinRange(param1:Number, param2:Number) : Number
	{
		return param1 + Math.random() * (param2 - param1);
	}
	
	private static function randomIntegerWithinRange(param1:int, param2:int) : int
	{
		return Math.round(randomWithinRange(param1,param2));
	}
}

class IDFilter extends Object
{
	
	private static const ID_LIST:Array = ["3865f2f68bf2d158e478d0a67b8354e6","f050e8be6e739b73d65ce059fa20b0db","79f0a822f35243d4ad09012c419a0395","14b2febb3992498c3dd13e9d26860c24","90f6988078a0c8fb683a0b0bc505a9fd","603ddfd98dee394e3a83b8f4b5c2d911","f3519ae57d2a99103d0ae41e638f352a","00f44da4b027734cb8cc3bdd77f117fa","095ed9bbb635ef70ec2537c3791eb950","39c3b125a1bd1b5526d8f4fb678023c4","33f239a816a4ec295521ff74012c6e91","6701c578bd174f0b99293b484d3176c7","25bbb65aa840a17e9b40b7673535060e","c4c7ce8497249310762209f5893b822e","65acae9ab392b8d7db484468156fad62","fcc60612dd31d06156b4df8bf263e556","ff3e272ad0bd8c050fd843b6f3efc500","9cf74aa12cc1d475aaff6127f9e8640d","37d859847ace5bbf95329a8ab98ce75b","e81fcf0d46593a67074c73f527ffe697","f3ad2bc65f372c8fd694e118c4b18270","66e7f4d33a9e403d5cf3e49dcf078b3c","583be8b02ec4f842f3b4aec0be91fa47","8c05db512858956ee55379428a28fa73","4503212d6ec397f862e91a732a47b07d","58939c1961c5087acfa35ea0eb7ab4b9","1bda67bacbc07fbead24b4a9ee376655","ab1af359eb201f7a1a3ddd55fa776342","f04918ffe6012d761c629a79e65b8c3e","f48229348d61e4f3340b5086233c347f","d52afec82c5afdeffaf57decc71f8c32","7b460a8c3fef1a00c431cea13fa63792","12c95ac2bd29c318ea43907ddb1b0c48","edff3e5c1c2bb19b14d84ad251a76eb8","b4d2e5efc8384195fcb6e012d5148d43","7516232d9d729604b4d92ff4f59aff74","a375ffc930d6a317ad51d564f08ab387","8699d5d01be29d7d7e861014881f76e3","3ad052dac5efdeb066ba656c3153ee6e","f3cbe1d570d224336b429af74715a25e","a572a95ddb1d16367de2f5c01952f0ca","c1d673a7207b518247862498c24065db","24c4cb11b9886a4d8a50d3ff7a56622f","45d2dbf67404a0591f87097da696fe16","521fd7114e7e81192fde6cc655e9f179","83818031f1282ac3bea2a6d27d70dbae","332244f039ca8d9fa8bcbaf3f9941064","a2680e0ec34038d546fae21d63746474","589fd5cb89281191f029cacca9ba3ad8","175544f0812199fd1c1e8506a50f14e7","53a16fee58af6f432d79c8909842785e","2312b7fe7f66dd375907f7e206ec19b0","351c6eb7ede8fc9f4a9bba908434b4a4","e0a51c584e47552e71c2a95e2912b2fe","ed73adb57436fd115cebc6d30dfbe21f","9a29147b45c3609614ce21d8472cba3c","cc4890cf00671a561d79efb5c8ad09fd","45b19d2ce12ff297c687fe72b572a7aa","419f4d9f88d2a1bcfaaa6f5f092f536e","02f2aab0ef2147017488ba163ef4e32c","3a5c1d51e72461d905fa600f6d1ef0be","03d2f1bf1c0835c34601a2809e5f5fd2","3ab21bfb9fc84bc881db2496605396cf","6ed169cea0d02c55136922f93ad7eda7","a5f7c409404c8165f803170f28f2141b","49e54c63c7eeed9fde30ce0dbc82d1e1","faab35bd839738930cfb48c315fadcf8","2f572e57e674ac437662e8e7179e6b0a","574ecab58f461844c7f80e92a500faa6","57c631394f8c8b37b499c9895a61fb72","4b3913da36430a16106daafabb7ad56e","41d1d0951b34876e808e86f53a9c63ff","34c1446de28479d0fa13ecc899a09153","dc6766854626c61df43ca28e1ef100d2","ba04f7d6632a481fe56e02d871433e9b","c6ac340ce4723430b8b95a641199671f","22ac85c5f99534b78d72e4c4ac99977a","4983db2fdc5a769312ea1b2038e77aa0","62f9ea6de065893071e12c96554b05ce","19de8797faa5ce4b42bcc61835c50fa6","ccd266b7ba320b89a9492205094c09d7","f738e262d2a88f1eeb01620c112e190c","5833557d1e6145b2b1523279ba2daff6","4e16e3d53d7ddc8c27f3e0fff075786b","f0fc03901726c6f52fb5338794110995","9a66748b8fe632a71882d6666c414396","57ba8b0c237b7bdfab5b88e9cab976b6","cf4a1e4d91cc273cab39a3c068984010","9ee1b4cf295a0768983c225e1bf30422","915537a43224a67227736e1dab45e52c","1d4f905fd84d68c2acbfb6e4fefe5fa9","11511d62f3750cc9fd75e9434b5e5198","e836319aa81b08fba5096e10293de068","6df4702e37f1ea41fe5f4fd5d2957bde","bce9499b0d046ea190848eace8456a5d","859fb7675d0154176c139188eca69ecb","977e62dff6d4530f82a9ac9e602b27a8","c960e577f813ea3a1620d3a1ffbd213a","45a5826ea9613250f43ae0c2c723e8bf","0feb58738e68aad4fd93efa6abbd6923","7371ebb3ee036bb23dd0fb64af12ab44","1936b0526a61d7511eed2f9691827c32","ed5e2cc95dfce0fd2ab1a3dd4ad8b8f7","a8cf38c438dc654522e6324dbc8887f9","1dc8503243a7f0a9464d604f53895b21","53fffc32680c5d0ef2e44956ac57f88f","680d4d146e1aa6468d373c29d162b2bd","af20e905839db4e404296768f5f9fdea","688ae57723d201e5e20f227cef9d0a2f","643eda3dfe9ff0595337e02f59a619e7","17980d22094dee4e460f3e7bd03f944e","d9a86e18ba8730111311372c1d600026","4e9aad7ea7beb5f80d70f80a6b565fae","3bb2023ebe93576c756b51b2455a9e2a","468017128175200aa04f49993297e951","f6cfa361c23a5d93244fbbba43273ea0","d4e4572d9a180483406cfce08c05145d","dc9d02915b286fb0b06ed80bba84b92c","8ab717810a749867e6b36ef268551634","cea8bd7c5c0001678799e31e9e9e18c2","4aa22e3b55281e9b193c016cf6b9d5cc","5e18a5130a4e1e71455dd224f3334a5f","52b5fb4dba71346f4ed3d814fee5cc70","c5cd62555d4054486e1db6f84c97a7d9","dfc29ac7e347b78b6a1ae0fbfce225ce","823d5b38ecae8b2d31a198d18ea0e2df","c12fc6ca3dd00323351e273e06634fd1","73f0dca8d393900963bd36651a261d17","339a9a8dd50f13096c2b0608a5392d92","854238739e5ad5dceaf7e6164ecace1a","e6cbd84f0359f6a5cd812041684cb467","9bdc79d3e9565f9d45dca19c82af96d9","fd3bd4a8b453f70f158fad655a532bfd","916daeccefd6c21c7f062ba040495acf","a1e18fae227581154635933926a9ed23","8ba4ccf0b415c181e50cd7597feb5bc7","eb0f9a9512f6ce22c30dc3b2880fff49","08d0216e912cee371265b0d21631baff","dc69a0e92803be9f4ab6d6debfc59c65","682da207dd6f481144edb2407010ff12","646046a7b86b40b27564000f56aace89","9920362ba9805439e20a05403238b06e","1218d5fb7a22eafa23c3628677a3c37b","4bc941cc0823c019f29c908e52f5160d","42128e8283454d1c38453bacb9ea7d30","edcea35a2e7eb248b61765e1cab7ac41","cc7e5441c7608fca0b4253e2aab7626c","703fb0af205eb64fd49fa1a4615f5683","3bd89be1b6bcf3ea93aa8229a014dc18","483d7cab5e39f2f587ff387f576d1d46","1f391420d7e4536b9f061a75546f6189","573a8ae3ee1f47d886a05aa5d08aed27","085c092b2221ad419fd8f1e9f7b610d5","a35f8149a7a74cdfa2f06b07ab062813","3708a4082a00d2a2d88e1f48a5ab003b","e4c73c5f0bcd450b198675151c8b3790","a557f61925a14bd4a15e8c95dd365b02","7199f5cf5e2db2a5dde1b10754e96ff4","275b0beda33843a0a87b7d2c76c2e4e8","7397d6e5499fc181e4e43c20523a4469","179ef7b2acad8f4042200becf253675b","727cb6a2c7e73b77a5b9ff172bc2f472","56f27358dd335c5a571cd24cfca17512","132bcaf4f3053831e60b05ce4f5d4559","08b66da22fb7f1cf79d67ecb0213c227","c26c273d893b59d0faf6d36a362f065b","d08e3bae5216f04ec7be558641cc2310","0ab68575cc474b2656abaaafb4462684","4c791b670689dbf5b3351c1bac46c52a","f6949075d8d2ba22c73a318257688092","758b5354b5e5b9da8837864af44d21ca","cacbfb4c82cc03be355ca71d1028df5b","224e3619e6942bd28972aa5ec68acf18","bb1fa6f3873c4bb493a6ceb0d0110816","5bea5a74fc244789845aea9177153ab7","a08b9b5ca521b820ca494534780924ed","403426078e66ff3e5dca5c69085a0b97","5d04e056e53b220355cab22848125691","fe9b5687bd66a324351cf32761b50667","30a30aad4da65014ce38042b653e10a9","9fe5342fe5315c457ee4f4325081e7f9","0fcc1655e580e9833c16484cf59ccc93","e95c55c721560565a942252b73df4263","e6a61886876506516b450ac45d5b3a1a","d2eec497e1b9231b92e6f910b279a58f","0a6f1a180a60321cd699285ee2a4b05e","67ab6412f7358a3c4412b9dafc9c6103","540a049b57017ba16ebfe088f88ce228","438faf119b5e5997432520df5f7ac0e2","20bab14ba8a284eb10e1fcea3beb65a2","94bef9279a2f02bce51dd0edaf043a16","f200014e988ab54c8bd7ab381137d0f6","00e018db1841e5b207cfb9c1135bee5c","45a9beeb6142e3f5c09a942bcdb0d75c","c507bc55d1b90c7871661b89d1454090","5b63294c6c94e67ba621bd964a32907a","f8332cd1882431ed2dcbbe971677acb6","87927c787911279101cf9c21ee4da431","db46618afc3c3c01cbba68a1d86cf0ee","5ca839a9be8db87f13bb9df1d306714c","b305c013267a1ccee8b34d26db3b7eb1","abe1e198adeb962c52b02096615b6211","6612d88098c0e1eb326e4beab3c74de6","c9638dceed37399319887262658d5212","128fb016bafa161f462c5a4a18840320","bc20b327769db5cda7ee1e0e7d5acac6","a83f6aa5bd4f1587f1136893f5341311","c968872a93b8a7443645dc44c4204a40","79044da4ad20eca8ce769b3f515f0408","c8381c0021ed113a0e9e3fb899b32ee8","f5a83a4eef871a253c9f44e7437d1110","ca656d5a9f084254bf3240fd09b74e4c","333c502c84751bd3bb00425eb39541df","94edae091228f0d0cf428f7d389f2d79","ef531b87f5ba1e9a3ead83b8141a93bb","0bf9087ba38b50eb1f6d7a0c3f74a78b","bf74a7577dbd3bea63e02d6158abf4e3","c02a09826e5c743b9302046f23a57462","c74d81c801644d1dbd24b482c09333ca","8d4587518adf79e687053cb3169101b6","2ccbfd5f4cf1236315f92ed1759be5d6","97f9efba9dd26a490151c8e43b1a3aae","6b2dfd9268295157b50eee5b7f195cc7","1e8c8c192bb3b055763aa58b53fa8282","e33611444d2ab4aee9aa90b24b7381c8","5c15dab8776d1e4944c90f488f7f0a7b","c4641d5e52c892a85e384ef0fc0aee5a","42212db15ffd2a54b75a8a65d18e4191","d6d1a2736363a5619c3f59f14489be4f","5597620597f2d2f5d81a258df5d390f7","d55b9e48d85d019788129bc5526f8b7f","3f87e7b3d6b87799e29ae7a38e21c339","b4ee69d05988db10d761ad87a0259897","35cd7f90fdf28a14f527f0d313347d8c","a41a56e2b4877071961e57d5e9a07c27","6edbde2799bf1f8efc118db553cb09b4","bd421e3edcfd7a0b61eff5a7eed8564e","bc6e0bf6be9c51936258c86207f92369","a614bc53f13d160255bf6189c07f058b","f69987918397621580790216662b9668","8ea53fdbe36218911a401185febf5350","6fbbbf684acb8ab8672c8878710d86e2","2d664a105eb4efa67b37c2b28a50f022","48ff0694e08ff795fd588fe4a79b36a1","4fb18088905e751a8e88feee646458fa","a7a54f2ec20c842f3aa0ec117a4738dd","540faf86449a889cd9b64b0d2292115b","0145416f37a90c323c63e4f03f316c87","dc1fdd74aa4d18acfe3c673d39892783","65429833129e43ac86ecb6157835c733","0fc6f34eb2689607282dc0d2754229e0","013753ae29e503da003cfbd510d8885a","6b1e898ba77afa992db6ecdb9974e8cc","76c84f2878731b7df6522fa3a8314a79","cabecd5535c08ce67819997e48f25787","09ca9d0d7246dfdd6f368174ca145a0c","92eeacd3e101d956b90b123fedef53cb","a8015796e1c2dce40ac0bc51f157a4b9","b36eed44621f5e6e34be512817ecc37a","d521b2d08571a2d007b62008711e0817","b50446b46e754a8552b13fbc578bbdda","0e9c11648eb665be7f5c0710482a60c1","9f06aa80bbb60f3e1cb6ed2150f9ffd3","3993aaf2ea53483be0fac3749422e814","2d58050c7784e56bd7d349438719726f","70295eb7e277b5c06265bb8699d1fb4a","6799719e14daf9f8aa756940abebfa37","ba826f8726ce8b5ecf72d510fde8f68f","c03bfe41dabdc307a3c310b07b16e4d0","5b3b16c855e39c795f953a9e172bcc9b","d5ea6e39d37cd725b56c3e7a76336cc4","f8d2942369ebbbbbb4eb3fccb7549023","1380247eb7b7ecfd1c9e5582b151eba0","370d86e060db7dfea5abf4a05562beb0","dadbd7530bb5b39caabf6b94c7d3873e","79dcb3da30d4ad2bd5036cd1ae5279e9","bb8e393205e8edd3f90aeb4145eea127","e28a3c5cfce53f37ca95eaf96b7bcd33","247962b9524cfd49b448a228545db6f0","594f988c281de62fd6de8d6e7ff452ea","15a01759aba45482f09d8c5a497de7ed","9124c157cf8c70f9907dc7f21ffafe3f","9982a33ab72aaedef7e329d5bdf273bd","2ecc220f51bfeeeae803ff692e92a980","5341af843153506ac0def08b3c110442","ae754a6acd14cf8eeb5922ff17cdd1c1","5998254fddddd891b8e3654b7eb35809","dc552950115051db63e597f19f894e8e","40ab7afacff2c6897d53fbf53f00b0b2","876416b60ab4b797bba5845e548a1441","894a51f00961aa51c4da3cc919a491ab","37e90514906462352317568b4b4dc9a0","c68723c0a821f0f70b30cc999eeaac4b","3b62a0cd252a48a5a6f8227cb0dacafa","869620f9ba809a57b543c392496bc449","a69aa10281cc6e28b71485bcaadd960e","f16d3ccaffaef25b4df4fa7d066ec195","aa6d90c6f3e271a3be65cc59197b5632","466b7a8113ce64478fe0732cea117078","cff6b628e0a367f4cae36a9bbc610c6b","b7a8f17ab9ccf671c6a7bed5346b6095","b9771a9eea58f7c53e51f31b49e55726","2345f3fd9dbc0a2710d3a7518b9ccd2b","c2b62a718e80ea24107bd7569697c923","c17780fc9d14780aeec599e2912997fb","9aa88ddd0d5fded44db3b5d8a074b29b","d145911cd4c90fd0bba7a94915f3a0ca","02bb0aeae053530cc6a3791d7d5c579c","3480f2e5a04d6ff729052adf385333e2","4f546e42429a947d324052d984fecece","661d8fd4d2eec8c890f30d96ac3e41bc","b72d9d0b855fafa1e306c99e0d125816","2e6da41a4d3986fafb7fea3a513cbc81","4616f0c1583d3578f77440b7347cdd68","cfd9ae10f06b68d70bc5628858fe194f","249257352e1ed1b56a295da909544a1f","3e33115f8dcb07346675ece04c48ebd5","a66260712eed3e026dafb9125519361c","1c5a27bd7698d58df3ad7be28dfcd317","8ac7701d6455d56177839be7c98c255f","e7e7979e4cc129bb8305f98d12a0cb24","79c8b311f97c2b588403c07efba1d26f","d7b134e7a4eef8349b6c3db2afac66aa","497a11a96b2f8dc45c8135c8d3cf1387","dbd712eff4237e86d33e6e668db80e7b","55d821464fbd49778b46f4f1e7a42fbf","9685f46971bdab76b12fe2916129987c","d7e7a1c0cb33dc073042689d187a6b23","6dc0792e8e5a6e9b2c032fe6243c8e92","bce7b149e1abc72924eae2975578fbde","501cceb04d1ac15223b2d2c74b11a883","3a8c5555ad709555019b1116ac8ba668","77200966308d1e7df387cfae82f9a14b","357c31327cb8c1a2aedee7f89cb37409","d956f925e537e3fc4d6152f48d3a6e06","f9b8cdb0445f2091ec511fefbfdb38b4","4541bc6201a6b60ebfbe68dbf73a37a0","f429b4840d3bc50e2aa6d64bcce806de","e1886c3ebed0cf894c159094564369be","d573f8b303e2ccfa1c53f0865950fa6c","e23f72f666f926044b9cd3ceda12fc16","e2841ad2c4bed8f298a30b74fbc5bee9","dde35730a37a6ac08ee49cc86b235251","53b329309ed8d03e654682e7f0680af0","2e0adae47267a0163036513e97f89d32","3d72213e6da4d5381ed21c0c12203731","7a1656cca024ff9cb2b899bfaed9c492","fb317c6987708bb4f73affbe9d89c6c2","024b34e1d483fbc096ee790aa94c7147","1d544359f30e6a083726e071810a19b0","fadd1b1c3a1d15250d80b3eb61e0ffc1","2263e9bf5fb470756b5643c71259df59","879e318033c06ff6beba7a788d0085b2","ba2271892778d1b96af955eef0f1f422","3bd35d44e4012a9fb8902a99acbcb71b","35a09ff2a49244a1a8081ab49e13a951","25fa4bd590c58bd208827908b51f6052","324202a8d75d5684aa101e67d078d4f3","e010883ce07d8cf55b6777a3e817b9f6","f3a2abb8ecd916e0baecc148a39caf10","c67300913cb087d1b96a5999d40ad9e5","704c1febb9db879c16865e81ea22e4ef","0fa0a572d8f1b665f8975ed0087a3492","d15676c4a0f2772f666d1cf7a83e25d7","9681e6a9c0024a89cc87462080b6cad5","651ae6843d1de8de2b065ff120e2c208","d8b548af87218df056ac662734c996c3","4c8944b4304c37a35ad0c351d06c4d20","1a921117385ab469421f8e570f398f19","08005f8ca01e43ebab586e6cec0c7e44","6077fa6f8b3928814489cf50d5e00f4a","996a0dd3e5580188ee27b37ca1ee8754","0e5c1a5ae543b888f31df254803f5316","b0af2b9f45d9b8e270abf27748ea706d","50fc61128f941ebcff984be81e12c7cf","1d512dcee8ae85087650093b85ee5b2f","bbe1656ccce245af9b95e7ef8c0ee6bd","a8be107da67121b975e0e0a723337233","1b86a68fe5d5f077ad7e51012bea5325","0bdc04b4b4d7f595f595b693e9db1c67","56cd38496af445df69b18e8ab7729bd5","d365d110bbcf01f1b433c39ff42e6443","05e630aeeabb6380a791d8c75765aa46","39e62fea0c6615a8201116efdf449dc2","b302ece4ebe63fa490a8652b8d260011","1f886fb8442dfbed04392822806d9545","4546342646be316043a56246d9649563","a200b83eb3b61e7812cfde2aea5cf961","c9ffd2a603d4bb2572b7fc39ca6a2867","6011fb21b4574ebd23d1eb5f5fa1b67f","2af0a7ed4283bedc13137bc1ec610943","d6b2907e5ddcb4bcc4c49fe5589f8965","f8549671e82d4eac5a79132c43eb93c7","cdf90b43f5ba71f4aa9c374f33dfbbe4","aafa9a5aa80159faba2b518faacdaa8d","2c7928e259fadd21dafdd311c9e43ae2","e521d812533ecf0493397bef5488d810","c174c384364c9b25d00bccbc6c8e8d21","bce12f69a0676331e829d6b9fa5f97ee","c635da58be27eae519bd076f856c8eb5","bc77f6ba632d55d37f806458170e19bc","4369885bca3aad917bbb923ccedb6905","0cb25e5235cf450374c9f890d064752a","e85c524313bf716fd6252ee4ab6c90e0","bc0bfa1cc9b0d2ccf13b7a440d7c213f","5449a47c3d919018ffab2bbe19fd9105","d0be40f09994d8b687589f4477b894d5","b979379601f2d7f261e8ebd2af2d2df1","96195a23f71b7f22c0a8c51ee32d9c3d","cb5be15eb6c22eec762d27d37304ce9e","760d2fb23eb47c73b70229c904e5ca4e","706845832b025b2d8c9bc099fa3e2047","076fad946bfcf2bf45687079f5d755c5","6e84b1665739a88bae792311452928a9","2383559f0c92ed6cba2c685366847d2d","350afa4617cdd0a054dfeb2601040c6b","e19eb10e33dae8d42b89a2bb42f70cf7","b449ec609f395269bd38a00562816e15","0dcbd737d94070cbcf23b361661637f5","f008460cc46c751878403cc659b05b07","8b936b16cbf6cb28df70d2ddceca52c6","9c167aee71889fc3d57ad8614c825457","ed697f8a9a2fe72e5add240fcbd76677","38d38263afccee6a4672003ad5b390b3","78a37e31a0c0ae5c20d191f9357e35dd","0ca2bd70dbae56ab77769630509180e2","cd5e552c2187df84360184f28f66e05d","415a41d16e9b7cbfc4215bf18c997425","d078fe91c3804e810556b5192c313da7","af72864fae2d9f29c88af016222ea5ff","60323b0bdac14ac98798a0455d910cc0","a8dfea4bfe205c6441ae962be4ebdf58","47882e7ef5967a53a684620098fbece4","63b76cc5784f3cfd6676d63a5fbc8c49","65c7cd15f51958993ef967f29fbbf9b2","1b52a34d8d3f4c7ba0e17c33209db476","128671ae5efe63160133d4dfd421972a","b1fc8781f468b88e1c37e3463e2624f9","0c008ecbf8df3351ae5d38ddf16c0f9f","e92feac1324def829c78c5f78db0bc9c","3f47a9b2ad7ad515257b0bf8c2f82f9b","01de5acd58601a50a36c7e9aa7cf198d","847a4c8c24f5f3d56aaacd22a49b13c0","0f50f07daa9eca16c71a581ad9f04cab","5a866181abd77253e087ee091f6d7779","f2022ac3a29020d916a7da9b587d158e","1216b6fd3bd8b3e2177359fc86b922eb","ae6404832fa7dcfeb53f60976fb6e06b","16e0f4109cb6482fb1110645ac81ba8e","8cda0d7c8118701a3a46b46fbbe6eafe","f0afa8e7fc7508d322ce2564a0df4e02","7592926732965e3927b2b535146537da","5aa06b4b478699eb45a45f7145a14d0e","b2a282d3515ea358ab778d1bfe87cd1b","5c0c405fe1fb61f9508fb3a49bb935b1","77af8ac002c53c3857214619d54f8808","efefc8aab45d64b83690d427255229b6","83aa20fa41fd48569967453a9a40eb81","f7ef2162604d89fbf3d91024d9dfa410","801106bb69d543a98564fea0d681efe7","ae9162cea4037995d0839d2c84ded57d","6f4b1665a373c70f8483237c6ae080f8","94b338c2581e6a30b2e978699cb54d26","2bc3ea133cf8fe1e65eb5203529cbcf1","e86789ab91cea3818755761a73eae110","8d73c491b01129f259ededbd957ec51f","0be0d16621774a3c8c61e52ea1d9f373","8b5f1664d890cead6ccbcc5eea21b7fc","d8fda4b09a0ee37b4ab8b8a8ec5ea316","f1302205a47d68889dcc6231027d756d","8069d5989bf79e0f0013a50c11b2e692","d85e6da7c424b45cbd6637dabbacad67","99eef2c485b8113fe8046aa0430e9b78","fd00313bac0e192b31f4f12d9f09740d","b470a7d7cc6a4e1f961205435f79841a","a794152ffd7298e84921d2894b50c868","cf7bf56b04c527d640f30c20acff31cc","0cc3719eb7cf17843b4cbbee134d8547","7a696d0b6cbce3021226c5f53a676c69","4c67b4ab27c6664bb127eea63b892583","21123f220c064d14a95c9489853e1fc5","d1bdbc2c93c3222df8207f761fade8bf","53b2d915716ceb5f0eb172dae66c0345","a298b5831e039e20b0506f57f6a6b073","2c160f137378474689628a61dce193b3","1ad5abeb9d2acc38f6583b5188423277","4ff6a938e5aee0f4b6aa4f0894ed340b","38050afdcacef564a4f8b914cdba129f","d3eb7c7f2ece9ec65d60dad6771489f8","bf271663038ef0e186c80554032526e9","dd290cfd3e95f2cb261a81159b950afd","9d281aaf887f2c674c55e48064c2fb68","39e7dcfe7e2129576c6b203eae88a108","dade91bb5c46929181ab3c9f887da62e","b260f1570f1f7ff58c014e85644944ef","e0eaf165cd1df94514316b9b65cb0e47","bb310cdfe8812a4b181ec87c300add7b","c82b18687b78fd46a4bdbfbbf5ab9a49","7d27629acbc400c346c0aa04e78088c8","70e5f857f46bf778f8417171347bf4da"];
	
	function IDFilter()
	{
		super();
	}
	
	public static function inList(param1:String) : Boolean
	{
		var _loc3:* = 0;
		var _loc2:int = ID_LIST.length;
		if((param1) && _loc2 > 0)
		{
			_loc3 = 0;
			while(_loc3 < _loc2)
			{
				if(param1 == ID_LIST[_loc3])
				{
					return true;
				}
				_loc3++;
			}
		}
		return false;
	}
}

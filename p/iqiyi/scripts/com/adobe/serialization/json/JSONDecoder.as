package com.adobe.serialization.json
{
	public class JSONDecoder extends Object
	{
		
		private var strict:Boolean;
		
		private var value;
		
		private var tokenizer:JSONTokenizer;
		
		private var token:JSONToken;
		
		public function JSONDecoder(param1:String, param2:Boolean)
		{
			super();
			this.strict = param2;
			tokenizer = new JSONTokenizer(param1,param2);
			nextToken();
			value = parseValue();
			if((param2) && !(nextToken() == null))
			{
				tokenizer.parseError("Unexpected characters left in input stream");
			}
		}
		
		private function nextToken() : JSONToken
		{
			return token = tokenizer.getNextToken();
		}
		
		private function parseObject() : Object
		{
			var _loc2:String = null;
			var _loc1:Object = new Object();
			nextToken();
			if(token.type == JSONTokenType.RIGHT_BRACE)
			{
				return _loc1;
			}
			if(!strict && token.type == JSONTokenType.COMMA)
			{
				nextToken();
				if(token.type == JSONTokenType.RIGHT_BRACE)
				{
					return _loc1;
				}
				tokenizer.parseError("Leading commas are not supported.  Expecting \'}\' but found " + token.value);
			}
			while(true)
			{
				if(token.type == JSONTokenType.STRING)
				{
					_loc2 = String(token.value);
					nextToken();
					if(token.type == JSONTokenType.COLON)
					{
						nextToken();
						_loc1[_loc2] = parseValue();
						nextToken();
						if(token.type == JSONTokenType.RIGHT_BRACE)
						{
							break;
						}
						if(token.type == JSONTokenType.COMMA)
						{
							nextToken();
							if(!strict)
							{
								if(token.type == JSONTokenType.RIGHT_BRACE)
								{
									return _loc1;
								}
							}
						}
						else
						{
							tokenizer.parseError("Expecting } or , but found " + token.value);
						}
					}
					else
					{
						tokenizer.parseError("Expecting : but found " + token.value);
					}
				}
				else
				{
					tokenizer.parseError("Expecting string but found " + token.value);
				}
			}
			return _loc1;
		}
		
		private function parseArray() : Array
		{
			var _loc1:Array = new Array();
			nextToken();
			if(token.type == JSONTokenType.RIGHT_BRACKET)
			{
				return _loc1;
			}
			if(!strict && token.type == JSONTokenType.COMMA)
			{
				nextToken();
				if(token.type == JSONTokenType.RIGHT_BRACKET)
				{
					return _loc1;
				}
				tokenizer.parseError("Leading commas are not supported.  Expecting \']\' but found " + token.value);
			}
			while(true)
			{
				_loc1.push(parseValue());
				nextToken();
				if(token.type == JSONTokenType.RIGHT_BRACKET)
				{
					break;
				}
				if(token.type == JSONTokenType.COMMA)
				{
					nextToken();
					if(!strict)
					{
						if(token.type == JSONTokenType.RIGHT_BRACKET)
						{
							return _loc1;
						}
					}
				}
				else
				{
					tokenizer.parseError("Expecting ] or , but found " + token.value);
				}
			}
			return _loc1;
		}
		
		public function getValue() : *
		{
			return value;
		}
		
		private function parseValue() : Object
		{
			if(token == null)
			{
				tokenizer.parseError("Unexpected end of input");
			}
			switch(token.type)
			{
				case JSONTokenType.LEFT_BRACE:
					return parseObject();
				case JSONTokenType.LEFT_BRACKET:
					return parseArray();
				case JSONTokenType.STRING:
				case JSONTokenType.NUMBER:
				case JSONTokenType.TRUE:
				case JSONTokenType.FALSE:
				case JSONTokenType.NULL:
					return token.value;
				case JSONTokenType.NAN:
					if(!strict)
					{
						return token.value;
					}
					tokenizer.parseError("Unexpected " + token.value);
				default:
					tokenizer.parseError("Unexpected " + token.value);
					return null;
			}
		}
	}
}

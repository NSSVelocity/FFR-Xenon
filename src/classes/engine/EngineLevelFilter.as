package classes.engine
{
	import classes.user.User;
	import com.flashfla.utils.StringUtil;
	
	public class EngineLevelFilter
	{
		/// Filter Types
		public static const FILTER_AND:String = "and";
		public static const FILTER_OR:String = "or";
		public static const FILTER_STYLE:String = "Style";
		public static const FILTER_NAME:String = "Name";
		public static const FILTER_ARTIST:String = "Artist";
		public static const FILTER_STEPARTIST:String = "StepArtist";
		public static const FILTER_BPM:String = "BPM";
		public static const FILTER_DIFFICULTY:String = "Difficulty";
		public static const FILTER_ARROWCOUNT:String = "Arrows";
		public static const FILTER_ID:String = "ID";
		public static const FILTER_MIN_NPS:String = "MinNPS";
		public static const FILTER_MAX_NPS:String = "MaxNPS";
		public static const FILTER_RANK:String = "Rank";
		public static const FILTER_SCORE:String = "Score";
		public static const FILTER_STATS:String = "Stats";
		public static const FILTER_TIME:String = "Time";
		
		public static const FILTERS:Array = [FILTER_AND, FILTER_OR, FILTER_STYLE, FILTER_NAME, FILTER_ARTIST, FILTER_STEPARTIST, FILTER_BPM, FILTER_DIFFICULTY, FILTER_ARROWCOUNT, FILTER_ID, FILTER_MIN_NPS, FILTER_MAX_NPS, FILTER_RANK, FILTER_SCORE, FILTER_STATS, FILTER_TIME];
		public static const FILTERS_STAT:Array = ["amazing", "perfect", "average", "miss", "boo", "combo"];
		public static const FILTERS_NUMBER:Array = ["=", "!=", "<=", ">=", "<", ">"];
		public static const FILTERS_STRING:Array = [["Equal", "equal"], ["Start With", "start_with"], ["End With", "end_with"], ["Contains", "contains"]];
		
		public var name:String;
		public var type:String;
		public var comparison:String;
		public var inverse:Boolean = false;
		
		public var filters:Array = [];
		public var input_number:Number = 0;
		public var input_string:String = "";
		public var input_stat:String; // Display4
		
		/**
		 * Process the engine level to see if it has passed the requirements of the filters currently set.
		 *
		 * @param	songData	Engine Level to be processed.
		 * @param	userData	User Data from comparisons.
		 * @return	Song passed filter.
		 */
		public function process(songData:EngineLevel, userData:User):Boolean
		{
			switch (type)
			{
				case FILTER_AND: 
					if (!filters || filters.length == 0)
						return true;
					
					// Check ALL Sub Filters Pass
					for each (var filter_and:EngineLevelFilter in filters)
					{
						if (!filter_and.process(songData, userData))
							return false;
					}
					return true;
				
				case FILTER_OR: 
					if (!filters || filters.length == 0)
						return true;
					
					var out:Boolean = false;
					// Check if any Sub Filters Pass
					for each (var filter_or:EngineLevelFilter in filters)
					{
						if (filter_or.process(songData, userData))
							out = true;
					}
					return out;
				
				case FILTER_ID: 
					return compareString(songData.id, input_string);
				
				case FILTER_NAME: 
					return compareString(songData.name, input_string);
				
				case FILTER_STYLE: 
					return compareString(songData.style, input_string);
				
				case FILTER_ARTIST: 
					return compareString(songData.author, input_string);
				
				case FILTER_STEPARTIST: 
					return compareString(songData.stepauthor, input_string);
				
				case FILTER_BPM: 
					return false; //compareNumber(songData.bpm, input_number);
				
				case FILTER_DIFFICULTY: 
					return compareNumber(songData.difficulty, input_number);
				
				case FILTER_ARROWCOUNT: 
					return compareNumber(songData.notes, input_number);
				
				case FILTER_MIN_NPS: 
					return compareNumber(songData.min_nps, input_number);
				
				case FILTER_MAX_NPS: 
					return compareNumber(songData.max_nps, input_number);
				
				case FILTER_RANK: 
					return compareNumber(userData.levelranks.getEngineRanks(songData.source).getRank(songData.id).rank, input_number);
				
				case FILTER_SCORE: 
					return compareNumber(userData.levelranks.getEngineRanks(songData.source).getRank(songData.id).score, input_number);
				
				case FILTER_STATS: 
					return compareNumber(userData.levelranks.getEngineRanks(songData.source).getRank(songData.id)[input_stat], input_number);
				
				case FILTER_TIME: 
					return compareNumber(songData.time_secs, input_number);
			}
			return true;
		}
		
		/**
		 * Compares 2 Number values with the selected comparision.
		 * @param	value1	Input Value
		 * @param	value2	Value to compare to.
		 * @param	comparison	Method of comparision.
		 * @return	If comparision was successful.
		 */
		private function compareNumber(value1:Number, value2:Number):Boolean
		{
			switch (comparison)
			{
				case "=": 
					return value1 == value2;
				
				case "!=": 
					return value1 != value2;
				
				case "<=": 
					return value1 <= value2;
				
				case ">=": 
					return value1 >= value2;
				
				case "<": 
					return value1 < value2;
				
				case ">": 
					return value1 > value2;
			}
			return false;
		}
		
		/**
		 * Compares 2 String values with the selected comparision.
		 * @param	value1	Input Value
		 * @param	value2	Value to compare to.
		 * @param	comparison	Method of comparision.
		 * @param	inverse	Use inverse comparisions.
		 * @return	If comparision was successful.
		 */
		private function compareString(value1:String, value2:String):Boolean
		{
			var out:Boolean = false;
			value1 = value1.toLowerCase();
			value2 = value2.toLowerCase();
			
			switch (comparison)
			{
				case "equal": 
					out = (value1 == value2);
				
				case "start_with": 
					out = StringUtil.beginsWith(value1, value2);
				
				case "end_with": 
					out = StringUtil.endsWith(value1, value2);
				
				case "contains": 
					out = (value1.indexOf(value2) >= 0);
			}
			return inverse ? !out : out;
		}
		
		public function setup(obj:Object):void
		{
			if (obj.hasOwnProperty("filters"))
			{
				var in_filter:EngineLevelFilter;
				var in_filters:Array = obj["filters"];
				for (var i:int = 0; i < in_filters.length; i++)
				{
					in_filter = new EngineLevelFilter();
					in_filter.setup(in_filters[i]);
					filters.push(in_filter);
				}
			}
			
			if (obj.hasOwnProperty("comparison"))
				comparison = obj["comparison"];
				
			if (obj.hasOwnProperty("name"))
				name = obj["name"];
				
			if (obj.hasOwnProperty("type"))
				type = obj["type"];
				
			if (obj.hasOwnProperty("input_number"))
				input_number = obj["input_number"];
				
			if (obj.hasOwnProperty("input_string"))
				input_string = obj["input_string"];
				
			if (obj.hasOwnProperty("input_stat"))
				input_stat = obj["input_stat"];
		}
		
		public function export():Object
		{
			var obj:Object = {};
			if (type == FILTER_AND || type == FILTER_OR)
			{
				var ex_array:Array = [];
				for (var i:int = 0; i < filters.length; i++)
				{
					ex_array.push(filters[i].export());
				}
				obj["filters"] = ex_array;
			}
			obj["type"] = type;
			
			if (comparison && comparison != "")
				obj["comparison"] = comparison;
			if (name && name != "")
				obj["name"] = name;
			if (input_number)
				obj["input_number"] = input_number;
			if (input_string && input_string != "")
				obj["input_string"] = input_string;
			if (input_stat && input_stat != "")
				obj["input_stat"] = input_stat;
			
			return obj;
		}
		
		public function toString():String
		{
			return type + " [" + comparison + "]" 
					+ (!isNaN(input_number) ? " input_number=" + input_number : "") 
					+ (input_string != null ? " input_string=" + input_string : "") 
					+ (input_stat != null ? " input_stat=" + input_stat : "");
		}
	}
}
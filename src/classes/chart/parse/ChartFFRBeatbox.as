package classes.chart.parse {
	import classes.chart.BPMSegment;
	import classes.chart.Note;
	import classes.chart.NoteChart;
	import classes.chart.Stop;
	
	public class ChartFFRBeatbox extends NoteChart {
		private static const DIRECTION_MAP:Object = {
			"L": "left",
			"R": "right",
			"D": "down",
			"U": "up"
		};

		//- Input:
		// _root.beatBox = [[66, "L", "blue"], ......... , [4375, "R", "red"]];
		
		public function ChartFFRBeatbox(inData:String, framerate:int = 30):void {
			type = NoteChart.FFR_BEATBOX;
			super(inData.replace(/\s|"|;/g, "").replace("_root.beatBox=", "").split("],["), framerate);
			
			// Extract Notes
			for (var i:int = 0; i < this.chartData.length; i++) {
				var note:Array = this.chartData[i].split(",").map(clean);
				if (note.length >= 2)
					this.Notes.push(new Note(DIRECTION_MAP[note[1]], Number(note[0]) / 30, note[2]));
			}
		}
		
		private function clean(ins:String, param2:Object = null, param3:Object = null):String {
			return String(ins).replace(/[[\]]|\s|"|'/g, "");
		}
	}
}
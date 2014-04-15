package 
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class Base
	{
		private var s:Stage;//舞台
		private var s_width = 1024;//舞台的宽度
		private var s_height = 768;//舞台的高度
		public function Base()
		{
			// constructor code
		}
		//创建鱼群（1s创建一条鱼）
		public function createFish(_s:Stage):void
		{
			s = _s;
			var timer:Timer = new Timer(1000,0);
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
			timer.start();
		}
		private function timerHandler(e:TimerEvent):void
		{
			var num:Number = Math.ceil(Math.random() * 7);
			var mc:MovieClip = createOneFish(num);
			s.addChild(mc);
		}
		/*创建一条鱼
		type=1代表Fish1*/
		private function createOneFish(type:Number):MovieClip
		{
			var mc:MovieClip;
			switch (type)
			{
				case 1 :
					mc=new Fish1();
					break;
				case 2 :
					mc=new Fish2();
					break;
				case 3 :
					mc=new Fish3();
					break;
				case 4 :
					mc=new Fish4();
					break;
				case 5 :
					mc=new Fish5();
					break;
				case 6 :
					mc=new Fish6();
					break;
				case 7 :
					mc=new Fish7();
					break;
				default :
					mc=new Fish1();
					break;
			}
			mc["f_v"] = type / 2 + 0.5;
			mc.x =  -  mc.width;
			//鱼的Y轴坐标(80-668)
			mc.y = Math.random() * (s_height - 80) + 40;
			mc.addEventListener(Event.ENTER_FRAME, fishMoving);
			return mc;
		}
		//鱼游动
		private function fishMoving(e:Event):void
		{
			var mc:MovieClip = e.target as MovieClip;
			mc.x +=  mc["f_v"];
			//当鱼游出舞台，移除鱼
			if (mc.x > s_width)
			{
				mc.removeEventListener(Event.ENTER_FRAME, fishMoving);
				s.removeChild(mc);
			}
		}
	}

}
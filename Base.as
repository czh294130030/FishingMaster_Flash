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
		public var f_array:Array = new Array  ;//用来存储生成的鱼
		public function Base()
		{
			// constructor code
		}
		//创建鱼群（1s创建一条鱼）
		public function createFish(_s:Stage):void
		{
			s = _s;
			var createTimer:Timer = new Timer(1000,0);
			createTimer.addEventListener(TimerEvent.TIMER,crateTimerHandler);
			createTimer.start();
		}
		//创建鱼;
		private function crateTimerHandler(e:TimerEvent):void
		{
			var num:Number = Math.ceil(Math.random() * 7);
			var mc:MovieClip = createOneFish(num);
			s.addChild(mc);
			//将鱼添加到数组
			f_array.push(mc);
		}
		//删除鱼
		private function removeTimerHandler(e:TimerEvent,mc:MovieClip):void
		{
			//如果舞台包含鱼就删除
			if (s.contains(mc))
			{
				s.removeChild(mc);
			}
			//将鱼从数组中删除
			f_array.splice(f_array.indexOf(mc),1);
		}
		//鱼被抓住了
		public function fishIsCatched(mc:MovieClip):void
		{
			//鱼跳到抓住状态
			switch (mc["f_t"])
			{
				case 6 :
					mc.gotoAndPlay(40);
					break;
				case 7 :
					mc.gotoAndPlay(30);
					break;
				default :
					mc.gotoAndPlay(20);
					break;
			}
			//鱼停止游动
			mc.removeEventListener(Event.ENTER_FRAME,fishMoving);
			var removeTimer:Timer = new Timer(500,1);
			removeTimer.addEventListener(TimerEvent.TIMER,function(e:TimerEvent){removeTimerHandler(e,mc)});
			removeTimer.start();
		}
		/*创建一条鱼
		type=1代表Fish1
		type=2代表Fish2
		type=3代表Fish3
		type=4代表Fish4
		type=5代表Fish5
		type=6代表Fish6
		type=7代表Fish7*/
		private function createOneFish(type:Number):MovieClip
		{
			var mc:MovieClip;
			switch (type)
			{
				case 1 :
					mc = new Fish1  ;
					break;
				case 2 :
					mc = new Fish2  ;
					break;
				case 3 :
					mc = new Fish3  ;
					break;
				case 4 :
					mc = new Fish4  ;
					break;
				case 5 :
					mc = new Fish5  ;
					break;
				case 6 :
					mc = new Fish6  ;
					break;
				case 7 :
					mc = new Fish7  ;
					break;
				default :
					mc = new Fish1  ;
					break;
			}
			//鱼的类型
			mc["f_t"] = type;
			//鱼的价值
			mc["f_m"] = type;
			//鱼的速度
			mc["f_v"] = type / 2 + 0.5;
			//鱼的X轴坐标
			mc.x =  -  mc.width;
			//鱼的Y轴坐标(80-668)
			mc.y = Math.random() * (s_height - 72-mc.height);
			mc.addEventListener(Event.ENTER_FRAME,fishMoving);
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
				mc.removeEventListener(Event.ENTER_FRAME,fishMoving);
				s.removeChild(mc);
				//将鱼从数组中删除
				f_array.splice(f_array.indexOf(mc),1);
			}
		}
	}

}
package 
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.Sprite;

	public class Base
	{
		private var s:Sprite;//容器
		private var s_width = 1024;//舞台的宽度
		private var s_height = 768;//舞台的高度
		public var f_array:Array = new Array  ;//用来存储生成的鱼
		private var coin_target_x:Number = 180;//硬币移动的目标X坐标
		private var coin_target_y:Number = 670;//硬币移动的目标Y坐标
		private var black1,black2,black3,black4,black5,black6:BlackNum;//用户金额容器
		private var blacks:Array=new Array();//数组用来存放金额容器
		public var my_money:Number = 10000;//用户拥有的金额
		private var max_money:Number = 999999;//最大金额
		private var coin_speed:Number = 10;//硬币运动的速度
		public function Base()
		{
			// constructor code
		}
		//创建鱼群（1s创建一条鱼）
		public function createFish(_s:Sprite):void
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
		/*获取长方形元件的中心点与鼠标点击点连线和长方形的角度  
		x1代表中心点的X坐标  
		y1代表中心点的Y坐标  
		x2代表鼠标点的X坐标  
		y2代表鼠标垫的Y坐标*/
		public function getAngleBy2Points(x1:Number,y1:Number,x2:Number,y2:Number):Number
		{
			//获取长方形元件的中心点与鼠标点击点连线和长方形的弧度  
			var radian1:Number=Math.atan((x2-x1)/(y1-y2));
			//根据弧度获取角度  
			var angle1:Number=radian1/(Math.PI/180);
			if (x2 >= x1)
			{
				if (y2 <= y1)
				{
					angle1 = angle1;
				}
				else
				{
					angle1 +=  180;
				}
			}
			else
			{
				if (y2 > y1)
				{
					angle1 +=  180;
				}
				else
				{
					angle1 +=  360;
				}
			}
			return angle1;
		}
		//显示硬币
		private function appearCoin(fish_mc:MovieClip):void
		{
			var coin_mc:Coin=new Coin();
			//将鱼的x轴坐标，y轴坐标，价值传递给硬币
			coin_mc.x = fish_mc.x;
			coin_mc.y = fish_mc.y;
			coin_mc["f_m"] = fish_mc["f_m"];
			//获取硬币的坐标和硬币目标坐标的夹角
			var angle1:Number = getAngleBy2Points(coin_target_x,coin_target_y,coin_mc.x,coin_mc.y);
			var radian1=angle1*(Math.PI/180);
			coin_mc["v_x"] =  -  coin_speed * Math.sin(radian1);
			coin_mc["v_y"] = coin_speed * Math.cos(radian1);
			coin_mc.addEventListener(Event.ENTER_FRAME, moveCoin);
			s.addChild(coin_mc);
		}
		//移动硬币
		private function moveCoin(e:Event):void
		{
			var coin_mc:Coin = e.target as Coin;
			coin_mc.x +=  coin_mc["v_x"];
			coin_mc.y +=  coin_mc["v_y"];
			//当硬币运动到目标位置，删除硬币，我的金额增加并显示
			if (coin_mc.y >= coin_target_y)
			{
				my_money +=  coin_mc["f_m"];
				coin_mc.removeEventListener(Event.ENTER_FRAME, moveCoin);
				s.removeChild(coin_mc);
				displayMoney(my_money);
			}
		}
		//显示金色数字（鱼的金额）
		private function appearGoldenNum(fish_mc:MovieClip):void
		{
			var golden_mc:GoldenNum=new GoldenNum();
			golden_mc.x = fish_mc.x;
			golden_mc.y = fish_mc.y;
			golden_mc.gotoAndStop(Number(fish_mc["f_m"])+1);
			golden_mc.addEventListener(Event.ENTER_FRAME, disappearGoldenNum);
			s.addChild(golden_mc);
		}
		//隐藏金色数字
		private function disappearGoldenNum(e:Event):void
		{
			var golden_mc:MovieClip = e.target as MovieClip;
			//改变数字的透明度，当字体的透明度小于等于0就删除字体
			golden_mc.alpha -=  0.02;
			golden_mc.y -=  2;
			if (golden_mc.alpha <= 0)
			{
				golden_mc.removeEventListener(Event.ENTER_FRAME, disappearGoldenNum);
				s.removeChild(golden_mc);
			}
		}
		//删除鱼
		private function removeTimerHandler(e:TimerEvent,mc:MovieClip):void
		{
			//根据鱼的坐标和价值显示金色数字
			appearGoldenNum(mc);
			//根据鱼的坐标显示硬币
			appearCoin(mc);
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
			//鱼停止游动，500ms后从舞台上删除鱼，从数组中删除鱼
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
				//鱼停止游动，将鱼从舞台上删除，将鱼从数组中删除
				mc.removeEventListener(Event.ENTER_FRAME,fishMoving);
				s.removeChild(mc);
				f_array.splice(f_array.indexOf(mc),1);
			}
		}
		//显示金额
		public function displayMoney(money:Number):void
		{
			if (money<=max_money)
			{
				var m_string:String = money.toString();
				//需要补充的0的个数
				var need_zero:Number = max_money.toString().length - m_string.length;
				//为m_string补充0
				if (need_zero>0)
				{
					for (var j:Number=0; j<need_zero; j++)
					{
						m_string = "0" + m_string;
					}
				}
				//显示金额
				if (m_string.length > 0)
				{
					for (var i:Number=0; i<m_string.length; i++)
					{
						var m_char = m_string.charAt(i);
						blacks[i].gotoAndStop(Number(m_char)+1);
					}
				}
			}
		}
		//用户金额容器显示初始化
		public function initUserMoney():void
		{
			black1=new BlackNum();
			black1.x = 155;
			black1.y = 742;
			blacks.push(black1);
			s.addChild(black1);
			black2=new BlackNum();
			black2.x = 178;
			black2.y = 742;
			blacks.push(black2);
			s.addChild(black2);
			black3=new BlackNum();
			black3.x = 201;
			black3.y = 742;
			blacks.push(black3);
			s.addChild(black3);
			black4=new BlackNum();
			black4.x = 223;
			black4.y = 742;
			blacks.push(black4);
			s.addChild(black4);
			black5=new BlackNum();
			black5.x = 246;
			black5.y = 742;
			blacks.push(black5);
			s.addChild(black5);
			black6=new BlackNum();
			black6.x = 270;
			black6.y = 742;
			blacks.push(black6);
			s.addChild(black6);
		}
	}
}
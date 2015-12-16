require("app/Tools.lua")
local ACT = require("app/Actor.lua")
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)
ui_ = function(nativeWidget, name)
  local u = ccui.Helper:seekWidgetByName( nativeWidget, name)
  return u
end
local tt={
    __index = function(t,k)
      local u = ui_(t.nativeUI, k)
      rawset(t,k,u)
      return u
    end
  }
function ui_delegate(nativeUI)
  if(nativeUI == nil)then
    return nil
  end
  
  local r = { ["nativeUI"] = nativeUI }
  setmetatable( r, tt)
  return r
end
function ui_add_click_listener(ui, f ,sound) 
    ui:addTouchEventListener(
        function(sender,eventType)
            if eventType == ccui.TouchEventType.ended then
                
                f(sender,eventType)
            end
        end
    )
end


function MainScene:ctor()
    self.music = {"bgwar","jyqxz","Theme"}
    self.layer = cc.Layer:create()
    self:addChild(self.layer)
    printf("add layer")
    local temp = ccs.GUIReader:getInstance():widgetFromJsonFile("testUI.json")
    temp:setTag(7)
    self.layer:addChild(temp)
    local frameSize = cc.Director:getInstance():getWinSize()
    printf(frameSize.height..","..frameSize.width)
    local tbl_act = {left = 0,top = 0, right =0, bottom = 10+(frameSize.height-960)/2}
    self.ui = ui_delegate(self.layer:getChildByTag(7))
    --定时器
     local function tick()
    	self.time=self.time+1
    	local formatTime = Tools.timeFormatNumber(self.time)
        self.ui.lb_time:setString(formatTime)
    	
    end
     self.handle = Scheduler.scheduleGlobal(tick, 1)
     --背景音乐
     
   -- printf(self.ui.Panel_2:getLayoutParameter())
   -- self.ui.Panel_2:getLayoutParameter():setMargin(tbl_act)
    self.ui.pnl_1:setVisible(true)
    self.ui.pnl_2:setVisible(false)
    self.ui.pnl_2.visible = false
    self.time = 0
    for k=1,3 do 
    	local rd = math.random(1,18)
    	self.ui[string.format("img_%d",k)]:loadTexture(string.format("hero/hero_%d.png",rd))
    end
    self.ui.lb_start:setString("一群怀揣梦想的小伙伴起航了，你会选择谁加入你的团队?")
    if self.ui.pnl_2.visible then
    	self.ui.btn_next:setTitleText("游戏上线")
    else
    	self.ui.btn_next:setTitleText("开始制作")
    end
    ui_add_click_listener(self.ui.btn_next,function()
    	    self.ui.pnl_2.visible = not self.ui.pnl_2.visible
    		self.ui.pnl_2:setVisible(self.ui.pnl_2.visible)
    		if self.ui.pnl_2.visible then
		    	self.ui.btn_next:setTitleText("游戏上线")
		    else
		    	self.ui.btn_next:setTitleText("开始制作")
		    end
    	end)
    ui_add_click_listener(self.ui.btn_next1,function()
    	   local rd = math.random(1,3)
    	   local money = Tools["question"][toint(self.player.uquality)]["money"]
    	   printf(money)
    	   self.ui.lb_next:setString(Tools[money][rd])
    		
    	end)
    
   
     self.player = ACT.new()
     self.player:setActor()
     local bg = self.player:getActorStage()

    -- printf(bg[2])
     local bgMusicPath = cc.FileUtils:getInstance():fullPathForFilename(string.format("res/music/%s.mp3",bg[2]))
     printf(bgMusicPath)
     audio.playMusic(bgMusicPath, true)

     printf("quality:"..toint(self.player.uquality))
     printf("goldTime:"..self.player.goldTime)
    -- printf("sex1:"..player.usex.."  quality:"..Tools["qulity"][toint(self.player.uquality)][toint(self.player.usex)])
     self.ui.lb_1:setString("工作时间："..self.player.goldTime)
     self.ui.lb_1:setColor(cc.c3b(255,0,0))
     self.ui.lb_2:setString(Tools["qulity"][toint(self.player.uquality)][toint(self.player.usex)])
     self.ui.lb_2:setColor(cc.c3b(0,255,0))
     self.ui.lb_next:setString(Tools["question"][toint(self.player.uquality)]["text"])




    
     





   

end



function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene

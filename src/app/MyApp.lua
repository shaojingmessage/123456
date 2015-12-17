
require("config")
require("cocos.init")
require("framework.init")
require("app/Tools.lua")
require("app/DialogManager") 


local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    -- cc.FileUtils:getInstance():addSearchPath("res/")
     cc.FileUtils:getInstance():addSearchPath("src/")
    local frameSize = cc.Director:getInstance():getWinSize()
    local p=frameSize.height/frameSize.width;
    local gameUI = require("app/GameUI")
    if(p<1.5)then    --ipad
        globalOrigin = cc.p((frameSize.width-640)/2,0)
    else
        globalOrigin = cc.p(0,0)
    end
    gameUI:doEnterGame()
   -- self:enterScene("MainScene")
end


return MyApp

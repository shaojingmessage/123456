DialogManager = {
    dialogs = {}
}

local frameSize = cc.Director:getInstance():getWinSize()

function DialogManager:showDialog(dialog,...)
  local arg = {...}
  
  return self:showSubDialog( nil, dialog, unpack(arg)) -- 普通Dialog Zorder = 10
end

function DialogManager:showSubDialog(parent, dialog, ...)
    local arg = {...}
    local ed = nil

    if(self.dialogs[dialog] == nil)then
        ed = require("app/scenes/"..dialog)
        ed:create()
        ed.ui.nativeUI:retain()
        self.dialogs[dialog] = ed

        -- 居中
        --local size = cc.Director:getInstance():getWinSize()
        --local s2 = ed.ui.nativeUI:getContentSize()
        --ed.ui.nativeUI:setPosition(cc.p( (size.width-s2.width) /2 , (size.height - s2.height) / 2 ))
    else
        ed = self.dialogs[dialog]
    end

    -- 关闭当前对话框
    --if(self.dialogs.curDialog ~= nil)then
    --    self.dialogs.curDialog.ui.nativeUI:removeFromParent(false) -- 保留actions
    --end

    --layer.curDialog = ed

    local p = nil
    if parent == nil then
        p = cc.Director:getInstance():getRunningScene()
        ed.ui.nativeUI:setPosition(globalOrigin)
    else
        p = parent.ui.nativeUI
        ed.ui.nativeUI:setPosition(cc.p(0,0))
    end
    
    if ed.ui.nativeUI:getParent() == nil then
        p:addChild(ed.ui.nativeUI,10,10)
    else
        -- 如果已经显示了的，删了重新显示一下
        cclog("WARN: dialog " .. dialog .. " showed twice!")
        ed.ui.nativeUI:removeFromParent(false)
        p:addChild(ed.ui.nativeUI,10,10)
    end

    if(ed.onShow ~= nil)then
        ed:onShow(unpack(arg))
    end

    return ed
end

function DialogManager:closeDialog(dialog)
    dialog.ui.nativeUI:removeFromParent(false) -- 保留actions
end

function DialogManager:closeAllDialog() --关闭当前打开的所有窗口
    for k,v in pairs(self.dialogs) do
        if v.ui.nativeUI:getParent() ~= nil then
            v.ui.nativeUI:removeFromParent(false)
        end
    end
end

function DialogManager:showDialogAutoClose(parter,dialog,...)
    local arg = {...}
    local ed = nil
    local parent = nil 
    if(self.dialogs[dialog] == nil)then
        ed = require("src/UI/Dialog/"..dialog)    
        ed:create()
        ed.ui.nativeUI:retain()
        self.dialogs[dialog]  = ed
    else
        ed = self.dialogs[dialog]
    end

    local p = nil
    if parent == nil then
        p = cc.Director:getInstance():getRunningScene()
        ed.ui.nativeUI:setPosition(cc.p((frameSize.width-640)/2,frameSize.height/2-100))
    else
        p = parent.ui.nativeUI
        ed.ui.nativeUI:setPosition(cc.p(0,0))
    end
    if ed.ui.nativeUI:getParent() == nil then
        p:addChild(ed.ui.nativeUI,10,10)
    else
        -- 如果已经显示了的，删了重新显示一下
        cclog("WARN: dialog " .. dialog .. " showed twice!")
        ed.ui.nativeUI:removeFromParent(false)
        p:addChild(ed.ui.nativeUI,10,10)
    end

    if(ed.onShow ~= nil)then
    dump("-----")
        ed:onShow(unpack(arg))
    end
    local delay = cc.DelayTime:create(2)
    local fade = cc.FadeOut:create(0.5)
    local sequence = cc.Sequence:create(delay, fade, cc.CallFunc:create(function()
        ed.ui.nativeUI:removeFromParent(true) -- 保留actions
        ed.ui.nativeUI:setOpacity(255)       
    end))    
    ed.ui.nativeUI:runAction(sequence)
    return ed
end

function DialogManager:doCleanup()
    for k,v in pairs(self.dialogs) do
        if v.ui.nativeUI:getParent() ~= nil then
            v.ui.nativeUI:removeFromParent(true)
            v.ui.nativeUI:release()
        end
    end
    
    self.dialogs = {}
end

function DialogManager:getVisibleDialogs()
    local varr={}
    for k,v in pairs(self.dialogs) do
        if v.ui.nativeUI:getParent() ~= nil then
            cclog(k)
            table.insert(varr,k)
        end
    end

    return varr
end

return DialogManager
--require("app/Tools.lua")

local Employment ={}

function Employment:create()
    
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/employment.json"))
  
    
    
    ui_add_click_listener(self.ui.btn_close,function()
           DialogManager:closeDialog(self) 
        end)
   

end



function Employment:onShow()
end



return Employment

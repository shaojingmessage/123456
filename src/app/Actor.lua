require("app/Tools.lua")

Actor = class("Actor",nil)
Actor.timePoint = {1985,1995,2005,2009,2014,2016}
Actor.timeStart =1980
Actor.offSet =35
Actor.usex = 0
Actor.uquality = 0
Actor.uability = 0
Actor.goldTime = 1980
Actor.success1 = 0 --资金（1,2,3）
Actor.success2 = 0 --黄金时代（1-12）


function Actor:ctor()
	--self.usex = sex
	self.usex = math.random(0,1)
	self.uquality = math.random(0,1)
	self.goldTime = 1982
	--self.ujob = math.random(1,10)


end
function Actor:setActor(sex,qua)
	local sex = toint(sex)
	local qua = toint(qua)
	local ab = tonum(ab)
	local job = toint(job)
	if sex==nil then
		self.usex = math.random(0,1)
	else
		self.usex = sex
	end
	if qua==nil then
		self.uquality = math.random(0,1)
	else
		self.uquality = qua
	end
	printf("off:"..math.random(1,35))
	self.goldTime = self.timeStart+math.random(1,35)
	

end

function Actor:getActorStage()
	if self.goldTime >= 2016 then
		self.success1 = {"wanrexue","phrexue","热血三国手游大卖，开始疯狂冲钱中"}
		elseif self.goldTime<2016 and self.goldTime>=2014 then -- 
			self.success1 ={ "phrexue" ,"phguaji","天天挂机月流水千万，立志做一款更赚钱的游戏"}
		    elseif self.goldTime<2014 and self.goldTime>=2009 then
		    	self.success1 = {"phguaji","rexue","热血三国网页游戏风靡，手机发展迅猛，可以向手机游戏发展"} 
			    elseif self.goldTime<2009 and self.goldTime>=2005 then
			    	self.success1 = {"rexue","wow","wow陪伴着我的整个青葱，真希望有一款上班也能玩的游戏"}
				    elseif self.goldTime<2005 and self.goldTime>=1995 then
				    	self.success1 = {"wow","jyqxz","终于通关了，快去找人沟通经验，大家一起玩更好了"}
					    	elseif self.goldTime<1995 and self.goldTime>=1985 then
					    		self.success1 = {"jyqxz","super","武侠的梦，你不懂"}
					    		elseif self.goldTime<1985 then
					    			self.success1 = {"super","Contra","任天堂，红白机"}
	end
	return self.success1
end



--性别
function Actor:getActorSex()
	return tonumber(self.usex) 
end

--品质
function Actor:getActorQuality()
	return tonumber(self.uquality) 
end

--能力值
function Actor:getActorAbility()
	return tonumber(self.uability) 
end

--职业
function Actor:getActorJob()
	return tonumber(self.ujob) 
end

function Actor:getActorGoldDay()
	return tonumber(self.goldTime) 
end








return Actor
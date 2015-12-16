Tools = {
	job={
		[1] = "程序",
		[2] = "设计师",
		[3] = "测试",
		[4] = "美工",
		[5] = "原画",
		[6] = "数值策划",
		[7] = "架构师",
		[8] = "运营",
		[9] = "商务",
		[10] = "投资人",
		},
	qulity = {
		[1] ={[0]="白富美",[1]="高富帅"},
		[0] ={[0]="女屌丝",[1]="男屌丝"}
	    },
    question = {
		[1] = {["text"]="我是一个有内涵的人,我要开一家有内涵的游戏公司，我要招人了" ,["money"]="haveMoney"},
		[0] = { ["text"]="我是一个有情怀的人,我拥有改变世界的梦想" ,["money"]="noMoney"}
		},
	haveMoney = {
		  [1]="发现一个很有才华的策划收留",
		  [2] = "程序和策划讨论到很晚，加班加班加班，我们一起出去吃海底捞",
		  [3] = "策划天天讨论问题，程序说你这些都没有逻辑性,程序员怒辞职",
		  

			
		},
	noMoney = {
		[1] ="天天写策划案，延长时间，生病",
		[2] = "做出来的东西没有卖相",
		[3] = "程序人员不足，加班加班，程序员猝死",

	    }
	


}


function tonum(nu)
	return tonumber(nu)
end
function toint(nu)
	return tonumber(nu)
end
function Tools.timeFormatNumber(ts)
    local str = ""
    if(ts < 0)then
        str = "-"
        ts = -ts
    end
    local d  = math.floor(ts / (3600*24))
    if(d > 0)then
        str = str .. d .. "天"
    end
    ts = ts % (3600*24)
    local h = math.floor(ts / 3600)
    if(h >= 10)then
        str = str .. h .. ":"
    else
        str = str.."0"..h..":"
    end
    ts = ts % 3600

    local min = math.floor(ts / 60)
    if(min >= 10)then
        str = str .. min .. ":"
    else
        str = str.."0"..min..":"
    end
    ts = ts % 60

    local sec = math.floor(ts % 60)
    if(sec >= 10)then
        str = str .. sec
    else
        str = str.."0"..sec
    end

    return str

end
Scheduler = {}
local sharedScheduler = cc.Director:getInstance():getScheduler()
local function wrappedListener(l)
  return function ()
    xpcall(l,
    __G__TRACKBACK__)
  end
end

function Scheduler.scheduleGlobal(listener, interval)
    return sharedScheduler:scheduleScriptFunc(wrappedListener(listener), interval, false)
end

-- 取消
function Scheduler.unscheduleGlobal(handle)
    if handle ~= nil then
        sharedScheduler:unscheduleScriptEntry(handle)
    end
end
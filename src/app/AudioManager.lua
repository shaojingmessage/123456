--
-- Author: Your Name
-- Date: 2015-06-25 11:44:46
--

BATTLE_BACKGROUND_FILE = "music/battleBackground.mp3"
BATTLE_EFFECT_DELETE = "music/delete.mp3"
BATTLE_EFFECT_MOVE = "music/move.mp3"

AudioManager = {}

--******************************实例化对象方式1*************************************
function AudioManager:new(o) --创建一个对象 
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    -- setmetatable(o, {__index = AudioManager})
    return o
end

function AudioManager:getInstance() --单例模式
    if self.instance == nil then
        self.instance = self:new()
    end
    return self.instance
end

--******************************实例化对象方式2*************************************
--[[
function AudioManager:new() --private method.
    local store = nil
    return function(self)
        if store then return store end
        local o = {}
        setmetatable(o, self)
        self.__index = self
        store = o 
        return o
    end
end

AudioManager.getInstance = AudioManager:new() --implement single instance object.
]]

--******************************背景音乐*************************************
local musicHandle = nil
local stopAccumulateMusic = false
local accumulateTimes = 0
function AudioManager:playBackgroundMusic(fileName) --播放背景音乐
	audio.playMusic(fileName,true)
    accumulateTimes = 0
end

function AudioManager:stopBackgroundMusic(isReleaseData) --停止，isReleaseData是否释放音乐
	audio.stopMusic(isReleaseData) 
end

function AudioManager:pauseBackgroundMusic()  --暂停背景音乐
	audio.pauseMusic()
end

function AudioManager:resumeBackgroundMusic()  --恢复背景音乐
	audio.resumeMusic()
end

function AudioManager:setBackgroundMusicVolume(volume)  -- 设置音乐的音量
    audio.setMusicVolume(volume)
end

function AudioManager:getBackgroundMusicVolume()  -- 返回音乐的音量值
    return audio.getMusicVolume()
end

function AudioManager:accumulateMusicTimes() --背景音乐 念经次数统计
    local index = 0
    -- local visitorStoreInterval = 1 --每过一段时间自动存储念经次数，不用等游戏结束
    function onInterval(dt)
        -- print("mamamammamamamamam",math.random())
        --模拟服务器时间
        if User and User.moniOnline_at then
            User.moniOnline_at = User.moniOnline_at+1
        end

        if stopAccumulateMusic or LOGIN_MODE == 0 then --未登录也不计数
            return
        end
        index = index + 1
        index = index%7
        if index==0 then
            index = 1
        end
        -- visitorStoreInterval =visitorStoreInterval + 1
        if MUSIC_PLAY_INTERVAL == musicSpeedInterval.lowSpeed then --低速
            if index%MUSIC_PLAY_INTERVAL == 0 then
                -- index = 0
                accumulateTimes = accumulateTimes + 1
                -- print("低速念经",MUSIC_PLAY_INTERVAL)
                AudioManager:showAccumulateMusicTimes(accumulateTimes)
            end
        elseif MUSIC_PLAY_INTERVAL == musicSpeedInterval.middleSpeed then --中速
            if index%MUSIC_PLAY_INTERVAL == 0 then
                -- index = 1
                accumulateTimes = accumulateTimes + 1
                -- print("中速念经",MUSIC_PLAY_INTERVAL)
                AudioManager:showAccumulateMusicTimes(accumulateTimes)
            end
        elseif MUSIC_PLAY_INTERVAL == musicSpeedInterval.highSpeed then --高速
            if index%MUSIC_PLAY_INTERVAL == 0 then
                -- index = 1
                accumulateTimes = accumulateTimes + 1
                -- print("高速念经",MUSIC_PLAY_INTERVAL)
                AudioManager:showAccumulateMusicTimes(accumulateTimes)
            end
        end

            AudioManager:musicTimesSettlement()

            -- if LOGIN_MODE == 1 then
            --     if visitorStoreInterval%30 == 0 then --游客模式30秒   --全改30秒
            --         AudioManager:musicTimesSettlement(visitorStoreInterval)
            --         visitorStoreInterval = 1
            --     end
            -- end
            -- if LOGIN_MODE == 2 then
            --     if visitorStoreInterval%30 == 0 then --账号模式5分钟 --全改30秒
            --         --print("~~~~~~~~~~~~~~5分钟了~~~~~~~~~~~~~~~")
            --         AudioManager:musicTimesSettlement(visitorStoreInterval)
            --         visitorStoreInterval = 1
            --     end
            -- end
    end
    musicHandle = cc.Director:getInstance():getScheduler():scheduleScriptFunc(onInterval, 1.0, false)
    -- self.handle = scheduler.scheduleGlobal(onInterval, 1.0, false)
end

function AudioManager:showAccumulateMusicTimes(time) --主场景 显示念经次数
    local scene = cc.Director:getInstance():getRunningScene()
    if scene.mapUI then
        local oldTime = 0
        if LOGIN_MODE == 1 then --游客模式
            oldTime = GameData.user.spell
        elseif LOGIN_MODE == 2 then --账号模式
            oldTime = GameData.visitor.spell
        end
        scene.mapUI:refreshSpellNum(oldTime+time)
    end
end

local second = 0
function AudioManager:musicTimesSettlement(duration) --背景音乐 念经次数结算

    if not accumulateTimes then
        return
    end
    if LOGIN_MODE == 1 then --游客模式
        --更新数据
        second = second + 1
        if second%300 == 0 then
            if accumulateTimes > 0 then
                --5分钟保存一次念经次数
                GameData.user.spell = GameData.user.spell+accumulateTimes
                GameState.save(GameData)
                print("=====>>>>>>:更新服务器念经次数")
                local function errorCbk(params)
                    print("====>>>>>更新服务器念经次数,错误")
                end
                Cmd:updatespell(GameData.user.user_id,accumulateTimes,nil,errorCbk)
                accumulateTimes = 0
            end     
        end
        if second%600 == 0 then --10分钟上传一次 关卡,道具 数据
            second = 0
            --关卡数据
            local gates = {}
            for k,v in pairs(GameData.user.missionInfor) do
                if v.maxScore > 0 then
                    local infor = {
                    gate = v.id,
                    score = v.maxScore,
                    star = v.maxStar,
                    failcount = v.failedTime,
                    wincount = v.victoryTime,
                }
                gates[#gates+1] = infor
                end
            end
            local function testCbk1(params)
                print("====>>>>>updateAllgate,10分钟更新所有关卡回调")
            end
            local function errorCbk(params)
                print("====>>>>>updateAllgate,错误")
            end
            Cmd:updateAllgate(GameData.user.user_id,gates,testCbk1,errorCbk)
            --道具数据
            local function test2(params)
                print("====>>>>>updateActerInfo,10分钟更新所有道具信息")
            end

            local function acterInfoErrorCbk(params)
                print("====>>>>>updateActerInfo,错误")
            end
            local data = {
                props = GameData.user.items
            }
            Cmd:updateActerInfo(data,test2,acterInfoErrorCbk)

        end
    elseif LOGIN_MODE == 2 then --账号模式
        --更新数据
        second = second + 1
        if second%300 == 0 then
            if accumulateTimes > 0 then
                --5分钟保存一次念经次数
                GameData.visitor.spell = GameData.visitor.spell+accumulateTimes
                GameState.save(GameData)
                print("=====>>>>>>:更新服务器念经次数")
                local function errorCbk(params)
                    print("====>>>>>更新服务器念经次数,错误")
                end
                Cmd:updatespell(GameData.visitor.user_id,accumulateTimes,nil,errorCbk)
                accumulateTimes = 0
            end     
        end
        if second%600 == 0 then --10分钟上传一次 关卡,道具 数据
            second = 0
            --关卡数据
            local gates = {}
            -- User.user_id,curID,curScore,starLevel, User.missionInfor[curID].failedTime, User.missionInfor[curID].victoryTime
            for k,v in pairs(GameData.visitor.missionInfor) do
                if v.maxScore > 0 then
                    local infor = {
                    gate = v.id,
                    score = v.maxScore,
                    star = v.maxStar,
                    failcount = v.failedTime,
                    wincount = v.victoryTime,
                }
                gates[#gates+1] = infor
                end
            end
            local function gateCbk(params)
                print("====>>>>>updateAllgate,10分钟更新所有关卡回调")
            end
            local function errorCbk(params)
                print("====>>>>>updateAllgate,错误")
            end
            Cmd:updateAllgate(GameData.visitor.user_id,gates,gateCbk,errorCbk)
            --道具数据
            local function acterInfoCbk(params)
                print("====>>>>>updateActerInfo,10分钟更新所有道具信息")
            end

            local function acterInfoErrorCbk(params)
                print("====>>>>>updateActerInfo,错误")
            end
            local data = {
                props = GameData.visitor.items
            }
            Cmd:updateActerInfo(data,acterInfoCbk,acterInfoErrorCbk)
        end    
    end
end

function AudioManager:setAccumulateMusicSpeed(speed) --设置念经 速度
    MUSIC_PLAY_INTERVAL = speed
    stopAccumulateMusic = false
end

function AudioManager:getAccumulateMusicSpeed() --获取念经 速度
    if not stopAccumulateMusic  then
        return MUSIC_PLAY_INTERVAL
    end
    return  0
end

function AudioManager:stopAccumulateMusicTimes() --背景音乐 关闭念经次数统计
    if musicHandle then
        -- scheduler.unscheduleGlobal(self.handle)
        stopAccumulateMusic = true
    end
end

--**************************音效*****************************************
local stopEffectMusi = false
function AudioManager:playEffectMusic(fileName) --播放音效
    if stopEffectMusic then
        return
    end
	return audio.playSound(fileName, false) -- 返回音效id
end

function AudioManager:closeEffectMusic() --关闭音效
    stopEffectMusic = true
end

function AudioManager:openEffectMusic() --打开音效
    stopEffectMusic = false
end

function AudioManager:isMusicEffectOpen() --是否打开音效
    if stopEffectMusic == nil then
        return false
    end
    return stopEffectMusic 
end

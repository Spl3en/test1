local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color
local IM            = CppEnums.EProcessorInputMode
local UI_TM 		= CppEnums.TextMode

Panel_LocalWarInfo:SetShow( false, false )

-- Panel_LocalWarInfo:RegisterShowEventFunc( true, 'LocalWarInfoShowAni()' )
-- Panel_LocalWarInfo:RegisterShowEventFunc( false, 'LocalWarInfoHideAni()' )

-- function LocalWarInfoShowAni()
-- 	UIAni.fadeInSCR_Down( Panel_LocalWarInfo )

-- 	local aniInfo1 = Panel_LocalWarInfo:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
-- 	aniInfo1:SetStartScale(0.5)
-- 	aniInfo1:SetEndScale(1.2)
-- 	aniInfo1.AxisX = Panel_LocalWarInfo:GetSizeX() / 2
-- 	aniInfo1.AxisY = Panel_LocalWarInfo:GetSizeY() / 2
-- 	aniInfo1.ScaleType = 2
-- 	aniInfo1.IsChangeChild = true
	
-- 	local aniInfo2 = Panel_LocalWarInfo:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
-- 	aniInfo2:SetStartScale(1.2)
-- 	aniInfo2:SetEndScale(1.0)
-- 	aniInfo2.AxisX = Panel_LocalWarInfo:GetSizeX() / 2
-- 	aniInfo2.AxisY = Panel_LocalWarInfo:GetSizeY() / 2
-- 	aniInfo2.ScaleType = 2
-- 	aniInfo2.IsChangeChild = true
-- end
-- function LocalWarInfoHideAni()
-- 	local aniInfo1 = Panel_LocalWarInfo:addColorAnimation( 0.0, 0.1, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
-- 	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
-- 	aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
-- 	aniInfo1:SetStartIntensity( 3.0 )
-- 	aniInfo1:SetEndIntensity( 1.0 )
-- 	aniInfo1.IsChangeChild = true
-- 	aniInfo1:SetHideAtEnd(true)
-- 	aniInfo1:SetDisableWhileAni(true)
-- end

local localWarInfo = {
	_blackBG			= UI.getChildControl( Panel_LocalWarInfo, "Static_BlackBG"),
	_txtTitle			= UI.getChildControl( Panel_LocalWarInfo, "StaticText_Title" ),
	_btnClose			= UI.getChildControl( Panel_LocalWarInfo, "Button_Win_Close" ),
	_btnHelp			= UI.getChildControl( Panel_LocalWarInfo, "Button_Question" ),
	_listBg				= UI.getChildControl( Panel_LocalWarInfo, "Static_LocalWarListBG" ),
	_scroll				= UI.getChildControl( Panel_LocalWarInfo, "Scroll_LocalWarList"),

	_txtRule			= UI.getChildControl( Panel_LocalWarInfo, "StaticText_RuleContent"),
	_txtReward			= UI.getChildControl( Panel_LocalWarInfo, "StaticText_RewardContent"),
	_txtInfo			= UI.getChildControl( Panel_LocalWarInfo, "StaticText_InfoContent"),

	_btnInmy			= UI.getChildControl( Panel_LocalWarInfo, "Button_InmyChannel"),

	_createListCount	= 14,
	_startIndex			= 0,
	_listPool			= {},

	_posConfig = {
		_listStartPosY 	= 25,
		_iconStartPosY	= 88,
		_listPosYGap 	= 31,
	},
}

function LocalWarInfo_Initionalize()
	--------------------------------------------------------
		
	local self = localWarInfo
	for listIdx = 0, self._createListCount-1 do
	-- for listIdx = 0, 40 do
		local localWar = {}
		-- 각 리스트당 BG
		localWar.BG			= UI.createAndCopyBasePropertyControl( Panel_LocalWarInfo, "StaticText_ListBG", self._listBg, "LocalWarInfo_BG_" .. listIdx )
		localWar.BG			:SetPosX( 5 )
		localWar.BG			:SetPosY( self._posConfig._listStartPosY + ( self._posConfig._listPosYGap * listIdx ) )
		-- 채널
		localWar.channel	= UI.createAndCopyBasePropertyControl( Panel_LocalWarInfo, "StaticText_Channel", localWar.BG, "localWarInfo_Channel_"	.. listIdx )
		localWar.channel	:SetPosX( 0 )
		localWar.channel	:SetPosY( 5 )
		-- 현재 상태
		localWar.state		= UI.createAndCopyBasePropertyControl( Panel_LocalWarInfo, "StaticText_CurrentStat", localWar.BG, "localWarInfo_Stat_" .. listIdx )
		localWar.state		:SetPosX( 140 )
		localWar.state		:SetPosY( 5 )
		-- 참여자 수
		localWar.joinMember	= UI.createAndCopyBasePropertyControl( Panel_LocalWarInfo, "StaticText_JoinMemberCount", localWar.BG, "localWarInfo_JoinMember_" .. listIdx )
		localWar.joinMember	:SetPosX( 245 )
		localWar.joinMember	:SetPosY( 5 )
		-- 남은 시간
		localWar.remainTime	= UI.createAndCopyBasePropertyControl( Panel_LocalWarInfo, "StaticText_RemainTime", localWar.BG, "localWarInfo_RemainTime_" .. listIdx )
		localWar.remainTime	:SetPosX( 305 )
		localWar.remainTime	:SetPosY( 5 )
		-- 입장 버튼
		localWar.join		= UI.createAndCopyBasePropertyControl( Panel_LocalWarInfo, "Button_Join", localWar.BG, "localWarInfo_Join_" .. listIdx )
		localWar.join		:SetPosX( 440 )
		localWar.join		:SetPosY( 5 )

		self._listPool[listIdx] = localWar

		localWar.BG:addInputEvent( "Mouse_UpScroll",				"LocalWarInfo_ScrollEvent( true )"	)
		localWar.BG:addInputEvent( "Mouse_DownScroll",				"LocalWarInfo_ScrollEvent( false )"	)
		localWar.channel:addInputEvent( "Mouse_UpScroll",			"LocalWarInfo_ScrollEvent( true )"	)
		localWar.channel:addInputEvent( "Mouse_DownScroll",			"LocalWarInfo_ScrollEvent( false )"	)
		localWar.state:addInputEvent( "Mouse_UpScroll",				"LocalWarInfo_ScrollEvent( true )" )
		localWar.state:addInputEvent( "Mouse_DownScroll",			"LocalWarInfo_ScrollEvent( false )" )
		localWar.joinMember:addInputEvent( "Mouse_UpScroll",		"LocalWarInfo_ScrollEvent( true )" )
		localWar.joinMember:addInputEvent( "Mouse_DownScroll",		"LocalWarInfo_ScrollEvent( false )" )
		localWar.remainTime:addInputEvent( "Mouse_UpScroll",		"LocalWarInfo_ScrollEvent( true )")
		localWar.remainTime:addInputEvent( "Mouse_DownScroll",		"LocalWarInfo_ScrollEvent( false )")
		UIScroll.InputEventByControl( localWar.BG,					"LocalWarInfo_ScrollEvent" )
		UIScroll.InputEventByControl( localWar.channel,				"LocalWarInfo_ScrollEvent" )
		UIScroll.InputEventByControl( localWar.state,				"LocalWarInfo_ScrollEvent" )
		UIScroll.InputEventByControl( localWar.joinMember,			"LocalWarInfo_ScrollEvent" )
		UIScroll.InputEventByControl( localWar.remainTime,			"LocalWarInfo_ScrollEvent" )
	end

	local screenSizeX = getScreenSizeX()
	local screenSizeY = getScreenSizeY()
	Panel_LocalWarInfo:SetPosX( (screenSizeX - Panel_LocalWarInfo:GetSizeX()) / 2 )
	Panel_LocalWarInfo:SetPosY( (screenSizeY - Panel_LocalWarInfo:GetSizeY()) / 2 )

	self._txtRule	:SetTextMode( UI_TM.eTextMode_AutoWrap )
	self._txtReward	:SetTextMode( UI_TM.eTextMode_AutoWrap )
	self._txtInfo	:SetTextMode( UI_TM.eTextMode_AutoWrap )
	self._txtRule	:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_RULE") )
	self._txtReward	:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_REWARD") )
	self._txtInfo	:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_INFO") )

	self._blackBG:SetSize( getScreenSizeX()+250, getScreenSizeY()+250 )
	self._blackBG:SetHorizonCenter()
	self._blackBG:SetVerticalMiddle()

	self._scroll:SetControlTop()
end

function localWarInfo:Update()
	for listIdx = 0, self._createListCount-1 do	-- 리스트 초기화.
	-- for listIdx = 0, 15 do	-- 리스트 초기화.
		local list = self._listPool[listIdx]
		list.BG					:SetShow( false )
		list.channel			:SetShow( false )
		list.state				:SetShow( false )
		list.joinMember			:SetShow( false )
		list.remainTime			:SetShow( false )
		list.join				:SetShow( false )
	end

	local curChannelData		= getCurrentChannelServerData()
	if ( nil == curChannelData ) then
		return
	end

	local localWarServerCount = ToClient_GetLocalwarStatusCount()
	local count = 0
	for listIdx = self._startIndex, localWarServerCount-1 do
	-- for listIdx = 0, 40 do
		if ( self._createListCount <= count ) then
			break
		end
		local localWarStatusData		= ToClient_GetLocalwarStatusData( listIdx )
		local getServerNo				= localWarStatusData:getServerNo()							-- 붉은 전장 현황 서버넘버를 가져온다.
		local getJoinMemberCount		= localWarStatusData:getTotalJoinCount()					-- 해당 붉은 전장 참여 총 인원
		local getCurrentState			= localWarStatusData:getState()								-- 0: 붉은 전장 참여 알림 / 1: 플레이 중 / 2: 결과 / 3: 종료
		local getRemainTime				= localWarStatusData:getRemainTime()						-- 해당 붉은 전장의 남은 시간
		local warTimeMinute				= math.floor(Int64toInt32(getRemainTime / toInt64(0,60)))	-- 분
		local warTimeSecond				= Int64toInt32(getRemainTime) % 60							-- 초
		local channelName				= getChannelName(curChannelData._worldNo, getServerNo )		-- 서버 넘버로 채널 이름명을 알아온다.

		-- -1값이 들어오는 경우가 있다.
		if getJoinMemberCount < 0 then
			getJoinMemberCount = 0
		end

		local list = self._listPool[count]
		if 0 == getCurrentState then
			isCurrentState = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_JOIN_WAITING") -- "참여 대기 중"
			isWarTime = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_WAITING") -- "대기중"
			list.join:SetFontColor( Defines.Color.C_FF3B8BBE )
			list.join:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_JOIN") ) -- 입장
			list.join:SetIgnore( false )
		elseif 1 == getCurrentState then
			isCurrentState = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_ING") -- "진행중"
			isWarTime = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_LOCALWARINFO_TIME", "warTimeMinute", warTimeMinute, "warTimeSecond", Int64toInt32(warTimeSecond) ) -- warTimeMinute .. "분 " .. Int64toInt32(warTimeSecond) .. "초"
			if 10 <= warTimeMinute then
				list.join:SetFontColor( Defines.Color.C_FF3B8BBE )
				list.join:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_JOIN") ) -- 입장
				list.join:SetIgnore( false )
			else
				list.join:SetFontColor( Defines.Color.C_FFF26A6A )
				list.join:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_CANTJOIN") ) -- 입장불가
				list.join:SetIgnore( true )
			end
		elseif 2 == getCurrentState then
			isCurrentState = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_SOONFINISH") -- "곧 종료 예정"
			isWarTime = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_LOCALWARINFO_TIME", "warTimeMinute", warTimeMinute, "warTimeSecond", Int64toInt32(warTimeSecond) ) --warTimeMinute .. "분 " .. Int64toInt32(warTimeSecond) .. "초"
			list.join:SetFontColor( Defines.Color.C_FFF26A6A )
			list.join:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_CANTJOIN") ) -- "입장불가")
			list.join:SetIgnore( true )
		elseif 3 == getCurrentState then
			isCurrentState = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_FINISH") -- "종료"
			isWarTime = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_FINISH") -- "종료"
			list.join:SetFontColor( Defines.Color.C_FFF26A6A )
			list.join:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_CANTJOIN") ) -- "입장불가")
			list.join:SetIgnore( true )
		end

		list.BG				:SetShow( true )
		list.channel		:SetShow( true )
		list.state			:SetShow( true )
		list.joinMember		:SetShow( true )
		list.remainTime		:SetShow( true )
		list.join			:SetShow( true )
		-- 길드 순위
		list.channel		:SetText( channelName )		-- 채널 이름
		list.state			:SetText( isCurrentState )
		list.joinMember		:SetText( getJoinMemberCount )
		list.remainTime		:SetText( isWarTime )
		list.join			:addInputEvent("Mouse_LUp", "LocalWawrInfo_ClickedJoinLocalWar( " .. listIdx .. " )")

		count = count + 1
	end

	local inMyChannelInfo		= ToClient_GetLocalwarStatusDataToServer( curChannelData._serverNo )
	if nil == inMyChannelInfo then
		self._btnInmy:SetFontColor( UI_color.C_FFF26A6A )
		self._btnInmy:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_NOTOPENWAR") ) -- "붉은전장이 열리지 않는 채널입니다."
		self._btnInmy:SetEnable( false )
		self._btnInmy:addInputEvent("Mouse_LUp", "")
	else

		local inMyJoinCount			= inMyChannelInfo:getTotalJoinCount()					-- 해당 붉은 전장 참여 총 인원
		local inMyJoinState			= inMyChannelInfo:getState()								-- 0: 붉은 전장 참여 알림 / 1: 플레이 중 / 2: 결과 / 3: 종료
		local inMyRemainTime		= inMyChannelInfo:getRemainTime()						-- 해당 붉은 전장의 남은 시간
		local inMyRemainTimeMinute	= math.floor(Int64toInt32(inMyRemainTime / toInt64(0,60)))	-- 분
		local inMyRemainTimeSecond	= Int64toInt32(inMyRemainTime) % 60							-- 초
		local inMyChannelName		= getChannelName(curChannelData._worldNo, curChannelData._serverNo )		-- 서버 넘버로 채널 이름명을 알아온다.
		if 0 == inMyJoinState then
			isMyChannelState = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_WAITING") -- "대기중"
		elseif 1 == inMyJoinState then
			isMyChannelState = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_LOCALWARINFO_TIME", "warTimeMinute", inMyRemainTimeMinute, "warTimeSecond", Int64toInt32(inMyRemainTimeSecond) )
		elseif 2 == inMyJoinState then
			isMyChannelState = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_LOCALWARINFO_TIME", "warTimeMinute", inMyRemainTimeMinute, "warTimeSecond", Int64toInt32(inMyRemainTimeSecond) )
		elseif 3 == inMyJoinState then
			isMyChannelState = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_FINISH")
		end

		self._btnInmy:SetFontColor( UI_color.C_FF00C0D7 )
		self._btnInmy:SetText( PAGetStringParam3( Defines.StringSheet_GAME, "LUA_LOCALWARINFO_OPENWAR_INMYCHANNEL", "inMyChannelName", inMyChannelName, "inMyJoinCount", inMyJoinCount, "isMyChannelState", isMyChannelState ) ) -- "[" .. inMyChannelName .. "]채널( 참여자 수 : " .. inMyJoinCount .. " / " .. isMyChannelState .. " )" )
		self._btnInmy:SetEnable( true )
		self._btnInmy:addInputEvent("Mouse_LUp", "HandleClicked_InMyChannelJoin()")
	end

	UIScroll.SetButtonSize			( self._scroll, self._createListCount, localWarServerCount )
end

function FGlobal_LocalWarInfo_Open()
	local self		= localWarInfo
	local getLevel	= getSelfPlayer():get():getLevel()
	if getLevel < 50 then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_LEVELLIMIT") ) -- 50레벨 부터 붉은전장에 입장 가능합니다.
		return
	end
	ToClient_RequestLocalwarStatus()
	if Panel_LocalWarInfo:GetShow() then
		Panel_LocalWarInfo:SetShow( false, false )
	else
		Panel_LocalWarInfo:SetShow( true, true )
	end
	self._startIndex = 0
	self._scroll:SetControlTop()
	self:Update()
end

function FGlobal_LocalWarInfo_Close()
	Panel_LocalWarInfo:SetShow( false, false )
	TooltipSimple_Hide()
	-- TooltipGuild_Hide()
end

function FGlobal_LocalWarInfo_GetOut()
	ToClient_UnJoinLocalWar()	-- 붉은 전장 이탈 함수.
end

function LocalWarInfo_Repos()
	local self = localWarInfo
	local screenSizeX = getScreenSizeX()
	local screenSizeY = getScreenSizeY()
	Panel_LocalWarInfo:SetPosX( (screenSizeX - Panel_LocalWarInfo:GetSizeX()) / 2 )
	Panel_LocalWarInfo:SetPosY( (screenSizeY - Panel_LocalWarInfo:GetSizeY()) / 2 )

	Panel_LocalWarInfo:ComputePos()
	self._blackBG:SetSize( getScreenSizeX()+250, getScreenSizeY()+250 )
	self._blackBG:SetHorizonCenter()
	self._blackBG:SetVerticalMiddle()
end

function LocalWarInfo_ScrollEvent( isScrollUp )	-- 스크롤 추가시 사용
	local self					= localWarInfo
	local localWarServerCount	= ToClient_GetLocalwarStatusCount()
	self._startIndex	= UIScroll.ScrollEvent( self._scroll, isScrollUp, self._createListCount, localWarServerCount, self._startIndex, 1 )
	self:Update()
end

function LocalWawrInfo_ClickedJoinLocalWar( index )
	local curChannelData		= getCurrentChannelServerData()
	local getLevel				= getSelfPlayer():get():getLevel()
	if ( nil == curChannelData ) then
		return
	end
	if getLevel < 50 then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_LEVELLIMIT") ) -- 50레벨 부터 붉은전장에 입장 가능합니다.
		return
	end
	local localWarStatusData		= ToClient_GetLocalwarStatusData( index )
	local getServerNo				= localWarStatusData:getServerNo()
	local channelName				= getChannelName(curChannelData._worldNo, getServerNo )
	local isGameMaster				= ToClient_SelfPlayerIsGM()
	local channelMemo				= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_LOCALWARINFO_CHANNELMOVE", "channelName", channelName )

	local tempChannel	= getGameChannelServerDataByWorldNo(curChannelData._worldNo, index)
	local joinLocalWar = function()
		local playerWrapper = getSelfPlayer()
		local player		= playerWrapper:get()
		local hp			= player:getHp()
		local maxHp			= player:getMaxHp()

		if player:doRideMyVehicle() then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_NOT_RIDEHORSE") ) -- "탑승물에 탑승중에는 이용할 수 없습니다." )
		end

		if IsSelfPlayerWaitAction() then
			if (hp == maxHp) then
				if (getServerNo == curChannelData._serverNo) then
					ToClient_JoinLocalWar()
				else
					ToClient_RequestLocalwarJoinToAnotherChannel( getServerNo )
				end
			else
				Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_MAXHP_CHECK") ) -- 생명력을 꽉 채운 상태에서만 입장 가능합니다.
			end
		else
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_LOCALWARINFO") ) -- 대기 상태에서만 전장 현황을 이용할 수 있습니다.
		end
	end
	if (getServerNo == curChannelData._serverNo) then
		channelMemo = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_CURRENTCHANNELJOIN") -- "현재 채널에서 붉은전장에 참여합니다.\n붉은전장에 참여 하시겠습니까?"
	else
		channelMemo = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_LOCALWARINFO_CHANNELMOVE", "channelName", channelName ) -- channelName .. "로 이동하여 붉은전장에 참여합니다.\n이동하시겠습니까?"
	end

	local changeChannelTime		= getChannelMoveableRemainTime( curChannelData._worldNo )
	local changeRealChannelTime	= convertStringFromDatetime( changeChannelTime )
	if ( toInt64(0,0) < changeChannelTime ) and (getServerNo ~= curChannelData._serverNo) then
		local messageBoxMemo = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANGECHANNEL_PENALTY", "changeRealChannelTime", changeRealChannelTime )
		local messageBoxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELMOVE_TITLE_MSG"), content = messageBoxMemo, functionYes = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData)
	else
		local	messageBoxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELMOVE_TITLE_MSG"), content = channelMemo, functionYes = joinLocalWar, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData)
	end
end

function FromClient_UpdateLocalWarStatus()
	local self = localWarInfo
	self:Update()
end

function HandleClicked_InMyChannelJoin()
	ToClient_JoinLocalWar()
end

function LocalWarInfo_RegistEventHandler()
	local self = localWarInfo

	self._btnClose	:addInputEvent("Mouse_LUp", "FGlobal_LocalWarInfo_Close()")
	self._listBg	:addInputEvent(	"Mouse_UpScroll",	"LocalWarInfo_ScrollEvent( true )"	)
	self._listBg	:addInputEvent(	"Mouse_DownScroll",	"LocalWarInfo_ScrollEvent( false )"	)
	UIScroll.InputEvent( self._scroll,	"LocalWarInfo_ScrollEvent" )

	localWarInfo._btnHelp:SetShow(false)	-- 도움말 추가시 삭제 및 아래 주석처리된 라인 주석 해제
end

function LocalWarInfo_RegistMessageHandler()
	registerEvent("onScreenResize", 						"LocalWarInfo_Repos" )
	registerEvent("FromClient_UpdateLocalWarStatus", 		"FromClient_UpdateLocalWarStatus" )
end


LocalWarInfo_Initionalize()
LocalWarInfo_RegistEventHandler()
LocalWarInfo_RegistMessageHandler()
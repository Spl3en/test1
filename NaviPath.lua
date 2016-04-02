local UIColor = Defines.Color

function FromClient_CreateNaviPathUI( selfPlayer )
	selfPlayer:insertColorTable( 1000, UIColor.C_FFF68383 )
	selfPlayer:insertColorTable( 10000, UIColor.C_FFECADAD )
	selfPlayer:insertColorTable( 20000, UIColor.C_FFE5C6C6 )
	selfPlayer:insertColorTable( 1000000, UIColor.C_FFCECECE )
	

	--항상 마지막에 호출되어야 함.
	selfPlayer:insertEndColorTable()
end

registerEvent("FromClient_CreateNaviPathUI", "FromClient_CreateNaviPathUI")
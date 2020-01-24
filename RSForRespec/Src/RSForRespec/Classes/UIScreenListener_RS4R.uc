class UIScreenListener_RS4R  extends UIScreenListener;

var localized string RS4R_Respec;
var bool Active;
// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen){
	local UIArmory_PromotionHero Promotion_Screen;
	local XcomGameState_HeadquartersXCom XComHQ;
	Promotion_Screen = UIArmory_PromotionHero(screen);
	Promotion_Screen.NavHelp.AddLeftHelp(RS4R_Respec, class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_RSCLICK_R3);
	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
	if (XComHQ.HasFacilityByName('Recoverycenter') && (Promotion_Screen != none))
	{
		Active = true;
		`SCREENSTACK.SubscribeToOnInput(OnUnrealCommand);
	}
}

event OnRemoved(UIScreen screen)
{
	if(Active)
	{
		`SCREENSTACK.UnsubscribeFromOnInput(OnUnrealCommand);
		Active = false;
	}
}

event OnReceiveFocus(UIScreen screen)
{
	if(Active)
	{
		UIArmory_PromotionHero(`SCREENSTACK.GetCurrentScreen()).NavHelp.AddLeftHelp(RS4R_Respec, class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_RSCLICK_R3);
		`SCREENSTACK.SubscribeToOnInput(OnUnrealCommand);
	}
}

event OnLoseFocus(UIScreen screen)
{
	if(Active){
		`SCREENSTACK.UnsubscribeFromOnInput(OnUnrealCommand);
	}
}

function bool OnUnrealCommand(int cmd, int arg)
{
	if(Active && cmd == class'UIUtilities_Input'.const.FXS_BUTTON_R3 && arg == class'UIUtilities_Input'.const.FXS_ACTION_RELEASE)
	{
		`Log("I made it here");
		class'WorldInfo'.static.GetWorldInfo().ConsoleCommand("ClickRespecButtonByConsole");
		return true;
	}

	return false;
}

defaultproperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = none;
}

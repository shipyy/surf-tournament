public Plugin myinfo =
{
	name = "Surf Tournament",
	author = "https://github.com/shipyy",
	description = "Tournament Plugin for Surftimer",
	version = "1.0.0",
	url = "https://github.com/shipyy/surf-tournament"
};

/* ----- VARIABLES ----- */
bool g_bPlayers_Ready_Check[2] = false;
int g_iPlayers_Index[2] = -1;
char g_sPlayers_SteamID[2][32];
bool g_bPlayersReady = false;

char g_szChatPrefix[64] = "TOURNAMENT";

ConVar g_RoundDuration;
ConVar g_CountDownDuration;

/* ----- INCLUDES ----- */
#include <surftimer>
#include <colorlib>
#include <autoexecconfig>
#include "st-commands.sp"
#include "st-hud.sp"
#include "st-misc.sp"

public void OnPluginStart()
{
    EngineVersion eGame = GetEngineVersion();
    if(eGame != Engine_CSGO && eGame != Engine_CSS)
		SetFailState("[Surf Timer][TDF] This plugin is for CSGO/CSS only.");
    
    // reload language files
    LoadTranslations("st-tournament.phrases");

    createCMDS();

    //TIMER TO REGISTER IF BOTH PLAYERS ARE READY
    CreateTimer(1.0, CheckPlayersReady, INVALID_HANDLE, TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
}

public void OnMapStart(){

	AutoExecConfig_SetCreateDirectory(true);
	AutoExecConfig_SetCreateFile(true);
	AutoExecConfig_SetFile("tournament");

	g_RoundDuration = AutoExecConfig_CreateConVar("round_duration", "10", "specifies value of rounds duration", 0, true, 0.0, true, 100.0);
	g_CountDownDuration = AutoExecConfig_CreateConVar("countdown_duration", "10", "specifies value of countdown duration", 0, true, 0.0, true, 100.0);

	AutoExecConfig_ExecuteFile();
	AutoExecConfig_CleanFile();

}

public Action CheckPlayersReady(Handle timer)
{
	if (g_bPlayersReady){
		
		ServerCommand("mp_roundtime %d;mp_restartgame %d;mp_freezetime 0;", g_RoundDuration.IntValue, g_CountDownDuration.IntValue);
		CreateTimer(1.0, CountDown, INVALID_HANDLE, TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
		KillTimer(timer, true);

		return Plugin_Continue;
	}

	return Plugin_Continue;
}

public Action CountDown(Handle timer)
{

	if(g_CountDownDuration.IntValue <= 0){
		KillTimer(timer, true);
		CreateTimer(1.0, DisplayHUD, INVALID_HANDLE, TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
	}

	CPrintToChatAll("%t", "CountDown", g_CountDownDuration.IntValue);

	g_CountDownDuration--;

	return Plugin_Continue;
}
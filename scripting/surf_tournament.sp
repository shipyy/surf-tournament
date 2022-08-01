public Plugin myinfo =
{
	name = "Surf Tournament",
	author = "https://github.com/shipyy",
	description = "Tournament Plugin for Surftimer",
	version = "1.0.0",
	url = "https://github.com/shipyy/surf-tournament"
};

/* ----- VARIABLES ----- */
int g_iPlayers_Index[2];
char g_sPlayers_SteamID[2][32];
char g_sPlayer_Name[2][MAX_NAME_LENGTH];
float g_fPlayers_BestRun[2];
bool g_bPlayers_Ready_Check[2];
bool g_bPlayersReady;

bool g_bPlayer_FinalRun[2];
bool g_bPlayer_Finished[2];
bool g_bMatchFinished;

char g_szChatPrefix[64] = "TOURNAMENT";

ConVar g_cvarRoundDuration;
ConVar g_cvarCountDownDuration;
int g_CountDownDuration;
float g_RoundDuration;

Handle PlayersReady_Timer = INVALID_HANDLE;
Handle CountDown_Timer = INVALID_HANDLE;
Handle DisplayHUD_Timer = INVALID_HANDLE;
Handle Timeleft_Timer = INVALID_HANDLE;
Handle MapFinished_Timer = INVALID_HANDLE;
Handle Stopwatch_Timer = INVALID_HANDLE;

/* ----- INCLUDES ----- */
#include <surftimer>
#include <colorlib>
#include <autoexecconfig>
#include "st-commands.sp"
#include "st-hud.sp"
#include "st-misc.sp"

public void OnPluginStart(){

	EngineVersion eGame = GetEngineVersion();
	if(eGame != Engine_CSGO)
		SetFailState("[Tournament] This plugin is for CSGO only.");

	AutoExecConfig_SetCreateDirectory(true);
	AutoExecConfig_SetCreateFile(true);
	AutoExecConfig_SetFile("tournament");

	g_cvarRoundDuration = AutoExecConfig_CreateConVar("round_duration", "10", "specifies value of rounds duration", _, true, 0.0, true, 100.0);
	g_cvarCountDownDuration = AutoExecConfig_CreateConVar("countdown_duration", "10", "specifies value of countdown duration", _, true, 0.0, true, 100.0);

	g_CountDownDuration = g_cvarCountDownDuration.IntValue;
	g_RoundDuration = g_cvarRoundDuration.IntValue * 60 * 1.0; // convert to minutes

	AutoExecConfig_ExecuteFile();
	AutoExecConfig_CleanFile();

	LoadTranslations("st-tournament.phrases");
}

public void OnMapStart(){
	SetDefaults();

	createCMDS();

	//TIMER TO REGISTER IF BOTH PLAYERS ARE READY
	PlayersReady_Timer = CreateTimer(1.0, CheckPlayersReady, _, TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
}

public void OnMapEnd()
{
	Timers();
}

public void Timers()
{
	if(PlayersReady_Timer != INVALID_HANDLE){
		KillTimer(PlayersReady_Timer);
		PlayersReady_Timer = INVALID_HANDLE;
	}

	if(CountDown_Timer != INVALID_HANDLE){
		KillTimer(CountDown_Timer);
		CountDown_Timer = INVALID_HANDLE;
	}

	if(DisplayHUD_Timer != INVALID_HANDLE){
		KillTimer(DisplayHUD_Timer);
		DisplayHUD_Timer = INVALID_HANDLE;
	}

	if(Timeleft_Timer != INVALID_HANDLE){
		KillTimer(Timeleft_Timer);
		Timeleft_Timer = INVALID_HANDLE;
	}

	if(MapFinished_Timer != INVALID_HANDLE){
		KillTimer(MapFinished_Timer);
		MapFinished_Timer = INVALID_HANDLE;
	}

	if(Stopwatch_Timer != INVALID_HANDLE){
		KillTimer(Stopwatch_Timer);
		Stopwatch_Timer = INVALID_HANDLE;
	}
}

public void SetDefaults(){

	g_iPlayers_Index[0] = -1;
	g_iPlayers_Index[1] = -1;

	g_fPlayers_BestRun[0] = 0.0;
	g_fPlayers_BestRun[1] = 0.0;

	Format(g_sPlayers_SteamID[0], 32, "%s", "");
	Format(g_sPlayers_SteamID[1], 32, "%s", "");

	Format(g_sPlayer_Name[0], MAX_NAME_LENGTH, "%s", "");
	Format(g_sPlayer_Name[1], MAX_NAME_LENGTH, "%s", "");

	g_bPlayers_Ready_Check[0] = false;
	g_bPlayers_Ready_Check[1] = false;

	g_bPlayersReady = false;

	g_bPlayer_FinalRun[0] = false;
	g_bPlayer_FinalRun[1] = false;
	
	g_bPlayer_Finished[0] = false;
	g_bPlayer_Finished[1] = false;

	g_bMatchFinished = false;
}

public Action CheckPlayersReady(Handle timer, any data)
{
	if (g_bPlayersReady && CountDown_Timer == INVALID_HANDLE){
		ServerCommand("sm_cvar mp_freezetime %d", g_cvarCountDownDuration.IntValue);
		ServerCommand("mp_roundtime %d;mp_timelimit 100;mp_restartgame 1;", g_cvarRoundDuration.IntValue);
		CountDown_Timer = CreateTimer(1.0, CountDown, _, TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
	}

	return Plugin_Continue;
}

public Action CountDown(Handle timer, any data)
{
	if(PlayersReady_Timer != INVALID_HANDLE){
		KillTimer(PlayersReady_Timer);
		PlayersReady_Timer = INVALID_HANDLE;
	}

	if(g_CountDownDuration == 0){
		if(Stopwatch_Timer == INVALID_HANDLE && DisplayHUD_Timer == INVALID_HANDLE){
			for(int i = 1; i <= MaxClients; i++)
				if(IsValidClient(i) && IsPlayerAlive(i) && !IsFakeClient(i)){
					//CPrintToChat(i, "%t", "GLHF", g_szChatPrefix);
					SetHudTextParams(-1.0, -1.0, 1.0, 0, 255, 0, 255, 0, 0.0, 0.0, 0.0);
					//ShowHudText(i, -1, "%s", "-----  MATCH STARTED GL -----");
				}

			DisplayHUD_Timer = CreateTimer(0.1, DisplayHUD, _, TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
			Stopwatch_Timer = CreateTimer(0.1, Match_StopWatch, _, TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
		}
	}
	else if(g_CountDownDuration <= g_cvarCountDownDuration.IntValue){
		for(int i = 1; i <= MaxClients; i++)
        	if(IsValidClient(i) && !IsFakeClient(i)){
				//CPrintToChat(i, "%t", "CountDown", g_CountDownDuration);
				SetHudTextParams(-1.0, -1.0, 1.0, 0, 255, 0, 255, 0, 0.0, 0.0, 0.0);
				ShowHudText(i, -1, "----- %d -----", g_CountDownDuration);
			}

		g_CountDownDuration--;
	}
	else if(g_CountDownDuration == (g_cvarCountDownDuration.IntValue + 1))
		g_CountDownDuration--;
		
	return Plugin_Continue;
}

public Action Match_StopWatch(Handle timer, any data)
{
	g_RoundDuration = g_RoundDuration - 0.1;
	
	if(g_RoundDuration <= 0.0 && MapFinished_Timer == INVALID_HANDLE){
		MapFinished_Timer = CreateTimer(0.1, MapFinished_Check, _, TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
		return Plugin_Handled;
	}

	return Plugin_Continue;
}

public Action MapFinished_Check(Handle timer, any data)
{	
	if(g_bMatchFinished)
		Timers();

	//PLAYER 1 STILL IN RUN
	if(surftimer_GetCurrentTime(g_iPlayers_Index[0]) > 0.0 && !g_bPlayer_FinalRun[0]){

		g_bPlayer_FinalRun[0] = true;

		for(int i = 1; i <= MaxClients; i++)
			if(IsValidClient(i) && !IsFakeClient(i))
				CPrintToChat(i, "%t", "Player_inRun", g_szChatPrefix, g_sPlayer_Name[0])
	}
	else if(surftimer_GetCurrentTime(g_iPlayers_Index[0]) <= 0.0){
		g_bPlayer_Finished[0] = true;
	}
	
	//PLAYER 2 STILL IN RUN
	if(surftimer_GetCurrentTime(g_iPlayers_Index[1]) > 0.0 && !g_bPlayer_FinalRun[1]){

		g_bPlayer_FinalRun[1] = true;

		for(int i = 1; i <= MaxClients; i++)
			if(IsValidClient(i) && !IsFakeClient(i))
				CPrintToChat(i, "%t", "Player_inRun", g_szChatPrefix, g_sPlayer_Name[1])
	}
	else if(surftimer_GetCurrentTime(g_iPlayers_Index[1]) <= 0.0){
		g_bPlayer_Finished[1] = true;
	}

	if(g_bPlayer_Finished[0] && g_bPlayer_Finished[1]){
		g_bMatchFinished = true;

		CPrintToChatAll("%t", "Winner", g_szChatPrefix, g_fPlayers_BestRun[0] > g_fPlayers_BestRun[1] ? g_sPlayer_Name[0] : g_sPlayer_Name[1]);
	}

	return Plugin_Continue;
}

public Action surftimer_OnMapFinished(int client, float fRunTime, char sRunTime[54], int rank, int total){

	if(!g_bMatchFinished){
		if(client == g_iPlayers_Index[0] && !g_bPlayer_Finished[0]){
			g_fPlayers_BestRun[0] = fRunTime;

			char szPlayer1_Best_Runtime[32];
			FormatTimeFloat(client, g_fPlayers_BestRun[0], szPlayer1_Best_Runtime, sizeof(szPlayer1_Best_Runtime));

			CPrintToChatAll("%s finished a run in : %s", g_sPlayer_Name[0], szPlayer1_Best_Runtime);

			if(g_fPlayers_BestRun[0] > g_fPlayers_BestRun[1])
				CPrintToChatAll("%s is now in the lead!", g_sPlayer_Name[0]);

		}
		else if(client == g_iPlayers_Index[1] && !g_bPlayer_Finished[1]){
			g_fPlayers_BestRun[1] = fRunTime;

			char szPlayer2_Best_Runtime[32];
			FormatTimeFloat(client, g_fPlayers_BestRun[1], szPlayer2_Best_Runtime, sizeof(szPlayer2_Best_Runtime));

			CPrintToChatAll("%s finished a run in : %s", g_sPlayer_Name[1], szPlayer2_Best_Runtime);

			if(g_fPlayers_BestRun[1] > g_fPlayers_BestRun[0])
				CPrintToChatAll("%s is now in the lead!", g_sPlayer_Name[1]);
		}
	}

	return Plugin_Continue;
}


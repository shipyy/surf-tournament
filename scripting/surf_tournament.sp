public Plugin myinfo =
{
	name = "Surf Tournament",
	author = "https://github.com/shipyy",
	description = "Tournament Plugin for Surftimer",
	version = "1.0.0",
	url = "https://github.com/shipyy/surf-tournament"
};

/////
//INCLUDES
/////
#include <surftimer>
#include <colorlib>
#include <autoexecconfig>
#include "st-globals.sp"
#include "st-convars.sp"
#include "st-forwards.sp"
#include "st-commands.sp"
#include "st-hud.sp"
#include "st-misc.sp"

public void OnPluginStart()
{
	EngineVersion eGame = GetEngineVersion();
	if(eGame != Engine_CSGO)
		SetFailState("[Tournament] This plugin is for CSGO only.");

	LoadTranslations("st-tournament.phrases");

	createCMDS();

	ConVars_Create();

	CreateTimer(0.1, CheckpointsTimer, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(0.1, ShowOvertimeMessage, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

public void OnConfigsExecuted()
{
	Convars_Get();
}

public void OnMapStart()
{
	SetDefaults();

	//TIMER TO REGISTER IF BOTH PLAYERS ARE READY
	PlayersReady_Timer = CreateTimer(1.0, CheckPlayersReady, _, TIMER_REPEAT);
}

public void OnMapEnd()
{
	DeleteTimers();
	delete Overtime1;
	delete Overtime2;
	delete Stopwatch_Timer;
	delete DisplayHUD_Timer;
}

public Action CheckPlayersReady(Handle timer, any data)
{
	if (g_bPlayersReady && !g_bMatchStarted && CountDown_Timer == null){
		ServerCommand("sm_cvar mp_freezetime %d;sm_cvar mp_roundtime %d;sm_cvar mp_timelimit 100;sm_cvar sv_full_alltalk 1;sm_cvar mp_restartgame 1;", g_cvarCountDownDuration.IntValue, g_cvarRoundDuration.IntValue);
		CountDown_Timer = CreateTimer(1.0, CountDown, _, TIMER_REPEAT);

		PlayersReady_Timer = null;
		return Plugin_Stop;
	}

	return Plugin_Continue;
}

public Action CountDown(Handle timer, any data)
{
	if(g_CountDownDuration <= 0 && !g_bMatchStarted){
		g_bMatchStarted = true;
		g_bMatchFinished = false;

		if(Stopwatch_Timer == null){
			//g_StartTime = GetGameTime();
			Stopwatch_Timer = CreateTimer(0.1, Match_StopWatch, _, TIMER_REPEAT);
			DisplayHUD_Timer = CreateTimer(0.1, DisplayHUD, _, TIMER_REPEAT);

			CountDown_Timer = null;
			return Plugin_Stop;
		}
	}
	else if(g_CountDownDuration <= g_cvarCountDownDuration.IntValue && !g_bMatchStarted){
		for(int i = 1; i <= MaxClients; i++)
        	if(IsValidClient(i) && !IsFakeClient(i)){
				SetHudTextParams(-1.0, -1.0, 1.0, 0, 255, 0, 255, 0, 0.0, 0.0, 0.0);
				ShowHudText(i, -1, "----- %d -----", g_CountDownDuration);
			}

		g_CountDownDuration--;
	}
	else if(g_CountDownDuration == (g_cvarCountDownDuration.IntValue + 1) && !g_bMatchStarted)
		g_CountDownDuration--;

	return Plugin_Continue;
}

public Action Match_StopWatch(Handle timer, any data)
{
	//g_RoundDuration = g_StartTime = GetGameTime();
	g_RoundDuration = g_RoundDuration - 0.1;

	if(g_RoundDuration <= 0.0){

		//CHECK PLAYER CONDITIONS
		//DECIDE WETHER OR NOT GO INTO OVERTIME

		//NO PLAYERS IN RUN
		if (!surftimer_GetTimerStatus(g_iPlayers_Index[0]) && !surftimer_GetTimerStatus(g_iPlayers_Index[1])) {
			//COMPLETION OVERTIME
			if (g_fPlayers_BestRun[0] == 0.0 && g_fPlayers_BestRun[1] == 0.0){
				if (Overtime1 == null && Overtime2 == null) {
					/*
					SetHudTextParams(-1.0, -1.0, 3.0, 255, 0, 0, 255, 0, 0.0, 0.0, 0.0);
					for(int i = 1; i <= MaxClients; i++)
						if (IsValidClient(i) && !IsFakeClient(i))
            				ShowHudText(i, -1, "%s", "Overtime\nFirst Player To Complete Wins!!!");
					*/
					CPrintToChatAll("%t", "Overtime2", g_szChatPrefix);
					surftimer_RestartTimer(g_iPlayers_Index[0]);
					surftimer_RestartTimer(g_iPlayers_Index[1]);
					g_iOvertimeMessageTime = GetGameTime();
					Overtime2 = CreateTimer(0.1, Overtime2_Timer, _, TIMER_REPEAT);
				}
			}
			//AT ELAST 1 PLAYER FINISHED A RUN BEFORE OVERTIME
			else {

				g_bMatchFinished = true;

				if (g_fPlayers_BestRun[0] != 0.0 || g_fPlayers_BestRun[1] != 0.0) {
					if (g_fPlayers_BestRun[0] == 0.0)
						CPrintToChatAll("%t", "Winner", g_szChatPrefix, g_sPlayer_Name[1]);
					if (g_fPlayers_BestRun[1] == 0.0)
						CPrintToChatAll("%t", "Winner", g_szChatPrefix, g_sPlayer_Name[0]);
				}
				else if (g_fPlayers_BestRun[0] != 0.0 && g_fPlayers_BestRun[1] != 0.0) {
					CPrintToChatAll("%t", "Winner", g_szChatPrefix, g_fPlayers_BestRun[0] < g_fPlayers_BestRun[1] ? g_sPlayer_Name[0] : g_sPlayer_Name[1]);
				}

				/*
				DeleteTimers();

				SetDefaults();

				Convars_Get();
				*/
			}
		}
		//LAST RUN OVERTIME
		else {
			if (Overtime1 == null && Overtime2 == null) {
				Overtime1 = CreateTimer(0.1, Overtime1_Timer, _, TIMER_REPEAT);
			}
		}

		Stopwatch_Timer = null;
		return Plugin_Stop;
	}

	return Plugin_Continue;
}

public Action Overtime1_Timer(Handle timer, any data)
{
	g_RoundDuration = g_RoundDuration - 0.1;

	//PLAYER 1 STILL IN RUN
	if(surftimer_GetTimerStatus(g_iPlayers_Index[0]) && !g_bPlayer_FinalRun[0]){
		g_bPlayer_FinalRun[0] = true;
		CPrintToChatAll("%t", "Player_inRun", g_szChatPrefix, g_sPlayer_Name[0])
	}
	else if(!surftimer_GetTimerStatus(g_iPlayers_Index[0]) && g_bPlayer_FinalRun[0] && !g_bPrinted[0]){
		g_bPrinted[0] = true;
		CPrintToChatAll("%t", "Player_Finished", g_szChatPrefix, g_sPlayer_Name[0]);
	}
	else if (!surftimer_GetTimerStatus(g_iPlayers_Index[0]) && !g_bPlayer_FinalRun[0]){
		g_bPlayer_FinalRun[0] = true;
	}

	//PLAYER 2 STILL IN RUN
	if(surftimer_GetTimerStatus(g_iPlayers_Index[1]) && !g_bPlayer_FinalRun[1]){
		g_bPlayer_FinalRun[1] = true;
		CPrintToChatAll("%t", "Player_inRun", g_szChatPrefix, g_sPlayer_Name[1])
	}
	else if(!surftimer_GetTimerStatus(g_iPlayers_Index[1]) && g_bPlayer_FinalRun[1] && !g_bPrinted[1]){
		g_bPrinted[1] = true;
		CPrintToChatAll("%t", "Player_Finished", g_szChatPrefix, g_sPlayer_Name[1]);
	}
	else if (!surftimer_GetTimerStatus(g_iPlayers_Index[1]) && !g_bPlayer_FinalRun[1]){
		g_bPlayer_FinalRun[1] = true;
	}

	if(g_bPrinted[0] && g_bPrinted[1]){

		//BOTH PLAYERS FAILED LAST ATTEMPT WHILE ON OVERTIME
		//SO WE NEED TO SWAP TO THE OTHER OVERTIME TYPE
		if (g_fPlayers_BestRun[0] == 0.0 && g_fPlayers_BestRun[1] == 0.0) {
			Overtime1 = null;

			g_bPlayer_Finished[0] = false;
			g_bPlayer_Finished[1] = false;

			if (Overtime1 == null && Overtime2 == null) {
				/*
				SetHudTextParams(-1.0, -1.0, 3.0, 255, 0, 0, 255, 0, 0.0, 0.0, 0.0);
				for(int i = 1; i <= MaxClients; i++)
					if (IsValidClient(i) && !IsFakeClient(i))
						ShowHudText(i, -1, "%s", "Overtime\nFirst Player To Complete Wins!!!");
				*/
				CPrintToChatAll("%t", "Overtime2", g_szChatPrefix);
				surftimer_RestartTimer(g_iPlayers_Index[0]);
				surftimer_RestartTimer(g_iPlayers_Index[1]);
				g_iOvertimeMessageTime = GetGameTime();
				Overtime2 = CreateTimer(0.1, Overtime2_Timer, _, TIMER_REPEAT);
			}

			return Plugin_Stop;
		}

		g_bMatchFinished = true;

		if (g_fPlayers_BestRun[0] == 0.0 || g_fPlayers_BestRun[1] == 0.0) {
			if (g_fPlayers_BestRun[0] == 0.0)
				CPrintToChatAll("%t", "Winner", g_szChatPrefix, g_sPlayer_Name[1]);
			if (g_fPlayers_BestRun[1] == 0.0)
				CPrintToChatAll("%t", "Winner", g_szChatPrefix, g_sPlayer_Name[0]);
		}
		else if (g_fPlayers_BestRun[0] != 0.0 && g_fPlayers_BestRun[1] != 0.0) {
			CPrintToChatAll("%t", "Winner", g_szChatPrefix, g_fPlayers_BestRun[0] < g_fPlayers_BestRun[1] ? g_sPlayer_Name[0] : g_sPlayer_Name[1]);
		}

		/*
		DeleteTimers();
		delete Stopwatch_Timer;

		SetDefaults();

		Convars_Get();
		*/

		Overtime1 = null;
		return Plugin_Stop;
	}

	return Plugin_Continue;
}

public Action Overtime2_Timer(Handle timer, any data)
{
	g_RoundDuration = g_RoundDuration - 0.1;

	//PLAYER 1 STILL IN RUN
	if(g_fPlayers_BestRun[0] != 0.0 || g_fPlayers_BestRun[1] != 0.0){
		g_bMatchFinished = true;
	}

	if(g_bMatchFinished){

		CPrintToChatAll("%t", "Winner", g_szChatPrefix, g_fPlayers_BestRun[0] != 0.0 ? g_sPlayer_Name[0] : g_sPlayer_Name[1]);

		/*
		DeleteTimers();
		delete Stopwatch_Timer;

		SetDefaults();

		Convars_Get();
		*/

		Overtime2 = null;
		return Plugin_Stop;
	}

	return Plugin_Continue;
}

public Action CheckpointsTimer(Handle timer, any data)
{
	if (g_bMatchStarted && !g_bMatchFinished)
		Checkpoints_Display();

	return Plugin_Continue;
}

public Action ShowOvertimeMessage(Handle timer, any data)
{
	if (GetGameTime() - g_iOvertimeMessageTime < 3.0) {
		SetHudTextParams(-1.0, 0.35, 0.15, 255, 255, 0, 255, 0, 0.0, 0.0, 0.0);
		for(int i = 1; i <= MaxClients; i++)
			if (IsValidClient(i) && !IsFakeClient(i))
				ShowHudText(i, -1, "%s", "Overtime\nFirst Player To Complete Wins!!!");
	}

	return Plugin_Continue;
}
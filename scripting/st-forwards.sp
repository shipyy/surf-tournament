public Action surftimer_OnMapStart(int client, int prestrafe, int pre_PBDiff, int pre_SRDiff)
{
    if (g_bMatchStarted) {
        if (client == g_iPlayers_Index[0] || client == g_iPlayers_Index[1]) {
            if (client == g_iPlayers_Index[0])
                g_iCurrentCP[0] = 0;
            else
                g_iCurrentCP[1] = 0;

            for(int i = 0; i < 42; i++)
                if (client == g_iPlayers_Index[0])
                    g_fPlayers_CurrentRun_CheckpointTimes[0][i] = 0.0;
                else
                    g_fPlayers_CurrentRun_CheckpointTimes[1][i] = 0.0;
        }
    }

    return Plugin_Continue;
}

public Action surftimer_OnMapFinished(int client, float fRunTime, char sRunTime[54], float PBDiff, float WRDiff, int rank, int total, int style)
{
    if(g_bMatchStarted && !g_bMatchFinished && style == 0){
        if(client == g_iPlayers_Index[0] && (!g_bPlayer_Finished[0] || g_bPlayer_FinalRun[0])){

            if (g_bPlayer_FinalRun[0])
                g_bPlayer_Finished[0] = true;

            for(int i = 0; i < 42; i++)
                g_fPlayers_BestRun_CheckpointTimes[0][i] = g_fPlayers_CurrentRun_CheckpointTimes[0][i];

            //OWN PLAYER DIFFERENCE
            char szRuntime_Difference[32];
            if (g_fPlayers_BestRun[0] != 0.0){
                float runtime_difference = fRunTime - g_fPlayers_BestRun[0];
                if (runtime_difference < 0.0)
                    FormatTimeFloat(client, runtime_difference * -1.0, szRuntime_Difference, sizeof(szRuntime_Difference));
                else
                    FormatTimeFloat(client, runtime_difference, szRuntime_Difference, sizeof(szRuntime_Difference));

                if (runtime_difference < 0.0)
                    Format(szRuntime_Difference, sizeof szRuntime_Difference, "-%s", szRuntime_Difference);
                else
                    Format(szRuntime_Difference, sizeof szRuntime_Difference, "+%s", szRuntime_Difference);
            }
            else
                Format(szRuntime_Difference, sizeof szRuntime_Difference, "N/A", szRuntime_Difference);

            if (fRunTime < g_fPlayers_BestRun[0] || g_fPlayers_BestRun[0] == 0.0)
                g_fPlayers_BestRun[0] = fRunTime;

            char szPlayer1_Best_Runtime[32];
            FormatTimeFloat(client, g_fPlayers_BestRun[0], szPlayer1_Best_Runtime, sizeof(szPlayer1_Best_Runtime));

            //FORMAT CURRENT RUNTIME
            char szRuntimeFormatted[32];
            FormatTimeFloat(client, fRunTime, szRuntimeFormatted, sizeof(szRuntimeFormatted));

            if (g_fPlayers_BestRun[1] != 0.0) {

                float runtime_difference_opponent;
                char szRuntime_Difference_opponent[32];
                runtime_difference_opponent = fRunTime - g_fPlayers_BestRun[1];

                //OPPONENT DIFFERENCE
                if (runtime_difference_opponent < 0.0) {
                    FormatTimeFloat(client, runtime_difference_opponent * -1.0, szRuntime_Difference_opponent, sizeof(szRuntime_Difference_opponent));
                    Format(szRuntime_Difference_opponent, sizeof szRuntime_Difference_opponent, "-%s", szRuntime_Difference_opponent);
                }
                else {
                    FormatTimeFloat(client, runtime_difference_opponent, szRuntime_Difference_opponent, sizeof(szRuntime_Difference_opponent));
                    Format(szRuntime_Difference_opponent, sizeof szRuntime_Difference_opponent, "+%s", szRuntime_Difference_opponent);
                }

                //PRINT TO CHAT
                if(g_fPlayers_BestRun[0] < g_fPlayers_BestRun[1])
                    CPrintToChatAll("%t", "Run_Finished_Faster", g_sPlayer_Name[0], szRuntimeFormatted, "PB", szRuntime_Difference, "P2", szRuntime_Difference_opponent, szPlayer1_Best_Runtime);
                else
                    CPrintToChatAll("%t", "Run_Finished_Slower", g_sPlayer_Name[0], szRuntimeFormatted, "PB", szRuntime_Difference, "P2", szRuntime_Difference_opponent, szPlayer1_Best_Runtime);
            }
            else {
                if (g_fPlayers_BestRun[1] != 0.0)
                    CPrintToChatAll("%t", "Run_Finished_Faster", g_sPlayer_Name[0], szRuntimeFormatted, "PB", szRuntime_Difference, "P2", "N/A", szPlayer1_Best_Runtime);
                else
                    CPrintToChatAll("%t", "Run_Finished_Faster", g_sPlayer_Name[0], szRuntimeFormatted, "PB", szRuntime_Difference, "P2", "N/A", szPlayer1_Best_Runtime);
            }
        }
        //PLAYER 2
        else if(client == g_iPlayers_Index[1] && (!g_bPlayer_Finished[1] || g_bPlayer_FinalRun[1])){
            if (g_bPlayer_FinalRun[1])
                g_bPlayer_Finished[1] = true;

            for(int i = 0; i < 42; i++)
                g_fPlayers_BestRun_CheckpointTimes[1][i] = g_fPlayers_CurrentRun_CheckpointTimes[1][i];

            //OWN PLAYER DIFFERENCE
            char szRuntime_Difference[32];
            if (g_fPlayers_BestRun[1] != 0.0){
                float runtime_difference = fRunTime - g_fPlayers_BestRun[1];
                if (runtime_difference < 0.0) {
                    FormatTimeFloat(client, runtime_difference * -1.0, szRuntime_Difference, sizeof(szRuntime_Difference));
                    Format(szRuntime_Difference, sizeof szRuntime_Difference, "{green}-%s{default}", szRuntime_Difference);
                }
                else {
                    FormatTimeFloat(client, runtime_difference, szRuntime_Difference, sizeof(szRuntime_Difference));
                    Format(szRuntime_Difference, sizeof szRuntime_Difference, "{red}+%s{default}", szRuntime_Difference);
                }
            }
            else
                Format(szRuntime_Difference, sizeof szRuntime_Difference, "N/A", szRuntime_Difference);

            if (fRunTime < g_fPlayers_BestRun[1] || g_fPlayers_BestRun[1] == 0.0)
                g_fPlayers_BestRun[1] = fRunTime;

            char szPlayer2_Best_Runtime[32];
            FormatTimeFloat(client, g_fPlayers_BestRun[1], szPlayer2_Best_Runtime, sizeof(szPlayer2_Best_Runtime));

            //FORMAT CURRENT RUNTIME
            char szRuntimeFormatted[32];
            FormatTimeFloat(client, fRunTime, szRuntimeFormatted, sizeof(szRuntimeFormatted));

            if (g_fPlayers_BestRun[0] != 0.0 ) {
                float runtime_difference_opponent;
                char szRuntime_Difference_opponent[32];
                runtime_difference_opponent = fRunTime - g_fPlayers_BestRun[0];

                //OPPONENT DIFFERENCE
                if (runtime_difference_opponent < 0.0)
                    FormatTimeFloat(client, runtime_difference_opponent * -1.0, szRuntime_Difference_opponent, sizeof(szRuntime_Difference_opponent));
                else
                    FormatTimeFloat(client, runtime_difference_opponent, szRuntime_Difference_opponent, sizeof(szRuntime_Difference_opponent));

                if (runtime_difference_opponent < 0.0)
                    Format(szRuntime_Difference_opponent, sizeof szRuntime_Difference_opponent, "-%s", szRuntime_Difference_opponent);
                else
                    Format(szRuntime_Difference_opponent, sizeof szRuntime_Difference_opponent, "+%s", szRuntime_Difference_opponent);

                if(g_fPlayers_BestRun[1] < g_fPlayers_BestRun[0])
                    CPrintToChatAll("%t", "Run_Finished_Faster", g_sPlayer_Name[1], szRuntimeFormatted, "PB", szRuntime_Difference, "P1", szRuntime_Difference_opponent, szPlayer2_Best_Runtime);
                else
                    CPrintToChatAll("%t", "Run_Finished_Slower", g_sPlayer_Name[1], szRuntimeFormatted, "PB", szRuntime_Difference, "P1", szRuntime_Difference_opponent, szPlayer2_Best_Runtime);
            }
            else {
                if (g_fPlayers_BestRun[0] != 0.0)
                    CPrintToChatAll("%t", "Run_Finished_Faster", g_sPlayer_Name[1], szRuntimeFormatted, "PB", szRuntime_Difference, "P1", "N/A", szPlayer2_Best_Runtime);
                else
                    CPrintToChatAll("%t", "Run_Finished_Faster", g_sPlayer_Name[1], szRuntimeFormatted, "PB", szRuntime_Difference, "P1", "N/A", szPlayer2_Best_Runtime);
            }
        }
    }

    return Plugin_Continue;
}

public Action surftimer_OnCheckpoint(int client, float fRunTime, char sRunTime[54], float fPbCp, char sPbDiff[16], float fSrCp, char sSrDiff[16], ArrayList CustomCheckpoints)
{
    if (IsValidClient(client) && g_bMatchStarted) {
        if (client == g_iPlayers_Index[0] || client == g_iPlayers_Index[1]) {
            //PLAYER 1
            if (client == g_iPlayers_Index[0]) {
                g_fLastDifferenceTime[0] = GetGameTime();

                g_fPlayers_CurrentRun_CheckpointTimes[0][g_iCurrentCP[0]] = fRunTime;

                if (g_fPlayers_BestRun_CheckpointTimes[1][g_iCurrentCP[0]] != 0.0) {
                    g_CPDifference[0] = fRunTime - g_fPlayers_BestRun_CheckpointTimes[1][g_iCurrentCP[0]];
                    FormatTimeFloat(client, g_CPDifference[0], g_szCPDifference[0], sizeof g_szCPDifference[]);

                    //FASTER
                    if (g_CPDifference[0] < 0)
                        Format(g_szCPDifference[0], sizeof g_szCPDifference[], "-%s", g_szCPDifference[0]);
                    //SLOWER
                    else if (g_CPDifference[1] > 0)
                        Format(g_szCPDifference[0], sizeof g_szCPDifference[], "+%s", g_szCPDifference[0]);
                    else
                        Format(g_szCPDifference[0], sizeof g_szCPDifference[], "%s", g_szCPDifference[0]);
                }
                else {
                    Format(g_szCPDifference[0], sizeof g_szCPDifference[], "N/A");
                }

                //INCREMENT CP COUNT
                g_iCurrentCP[0]++;

                //FASTER
                if (g_CPDifference[0] < 0)
                    g_CPdisplayColor[0] = {0,255,0};
                //SLOWER
                else if (g_CPDifference[0] > 0)
                    g_CPdisplayColor[0] = {255,0,0};
                else
                    g_CPdisplayColor[0] = {255,255,255};
            }
            //PLAYER 2
            else if (client == g_iPlayers_Index[1]){
                g_fLastDifferenceTime[1] = GetGameTime();

                g_fPlayers_CurrentRun_CheckpointTimes[1][g_iCurrentCP[1]] = fRunTime;

                if (g_fPlayers_BestRun_CheckpointTimes[0][g_iCurrentCP[1]] != 0.0) {
                    g_CPDifference[1] = fRunTime - g_fPlayers_BestRun_CheckpointTimes[0][g_iCurrentCP[1]];
                    FormatTimeFloat(client, g_CPDifference[1], g_szCPDifference[1], sizeof g_szCPDifference[]);

                    //FASTER
                    if (g_CPDifference[1] < 0)
                        Format(g_szCPDifference[1], sizeof g_szCPDifference[], "-%s", g_szCPDifference[1]);
                    //SLOWER
                    else if (g_CPDifference[1] > 0)
                        Format(g_szCPDifference[1], sizeof g_szCPDifference[], "+%s", g_szCPDifference[1]);
                    else
                        Format(g_szCPDifference[1], sizeof g_szCPDifference[], "%s", g_szCPDifference[1]);
                }
                else {
                    Format(g_szCPDifference[1], sizeof g_szCPDifference[], "N/A");
                }

                //INCREMENT CP COUNT
                g_iCurrentCP[1]++;

                //FASTER
                if (g_CPDifference[1] < 0)
                    g_CPdisplayColor[1] = {0,255,0};
                //SLOWER
                else if (g_CPDifference[1] > 0)
                    g_CPdisplayColor[1] = {255,0,0};
                else
                    g_CPdisplayColor[1] = {255,255,255};
            }
        }
    }

    return Plugin_Continue;
}

public void Checkpoints_Display()
{
    //DISPLAY HUD FOR SPECTATORS
    for (int i = 1; i <= MaxClients; i++)
    {
        if (IsValidClient(i) && IsClientObserver(i) && !IsFakeClient(i)) {

            int ObservedUser = GetEntPropEnt(i, Prop_Send, "m_hObserverTarget");

            //IF CLIENT IS SPECCING A CONTESTANT
            if (ObservedUser == g_iPlayers_Index[0] && GetGameTime() - g_fLastDifferenceTime[0] < 3.0) {
                SetHudTextParams(-1.0, -1.0, 0.15, g_CPdisplayColor[0][0], g_CPdisplayColor[0][1], g_CPdisplayColor[0][2], 255, 0, 0.0, 0.0, 0.0);
                ShowHudText(i, -1, g_szCPDifference[0]);
            }
            else if (ObservedUser == g_iPlayers_Index[1] && GetGameTime() - g_fLastDifferenceTime[1] < 3.0) {
                SetHudTextParams(-1.0, -1.0, 0.15, g_CPdisplayColor[1][0], g_CPdisplayColor[1][1], g_CPdisplayColor[1][2], 255, 0, 0.0, 0.0, 0.0);
                ShowHudText(i, -1, g_szCPDifference[1]);
            }
        }
    }
}
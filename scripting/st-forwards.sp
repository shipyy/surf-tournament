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
        PrintToConsole(0, "value of g_bPlayer_Finished %b | %b", g_bPlayer_Finished[0], g_bPlayer_Finished[1]);
        if(client == g_iPlayers_Index[0] && (!g_bPlayer_Finished[0] || g_bPlayer_FinalRun[0])){

            if (g_bPlayer_FinalRun[0])
                g_bPlayer_Finished[0] = true;

            PrintToChatAll("PLAYER 1 FINISHED A RUN");
            for(int i = 0; i < 42; i++)
                g_fPlayers_BestRun_CheckpointTimes[0][i] = g_fPlayers_CurrentRun_CheckpointTimes[0][i];

            if (fRunTime < g_fPlayers_BestRun[0] || g_fPlayers_BestRun[0] == 0.0)
                g_fPlayers_BestRun[0] = fRunTime;

            char szPlayer1_Best_Runtime[32];
            FormatTimeFloat(client, g_fPlayers_BestRun[0], szPlayer1_Best_Runtime, sizeof(szPlayer1_Best_Runtime));

            //FORMAT CURRENT RUNTIME
            char szRuntimeFormatted[32];
            FormatTimeFloat(client, fRunTime, szRuntimeFormatted, sizeof(szRuntimeFormatted));

            if (g_fPlayers_BestRun[1] != 0.0) {

                float runtime_difference;
                char szRuntime_Difference[32];
                runtime_difference = fRunTime - g_fPlayers_BestRun[1];
                if (runtime_difference < 0.0)
                    FormatTimeFloat(client, runtime_difference * -1.0, szRuntime_Difference, sizeof(szRuntime_Difference));
                else
                    FormatTimeFloat(client, runtime_difference, szRuntime_Difference, sizeof(szRuntime_Difference));

                if (runtime_difference < 0.0)
                    Format(szRuntime_Difference, sizeof szRuntime_Difference, "-%s", szRuntime_Difference);
                else
                    Format(szRuntime_Difference, sizeof szRuntime_Difference, "+%s", szRuntime_Difference);

                if(g_fPlayers_BestRun[0] < g_fPlayers_BestRun[1])
                    CPrintToChatAll("%t", "Run_Finished_Faster", g_sPlayer_Name[0], szRuntimeFormatted, "P2", szRuntime_Difference, g_sPlayer_Name[0], szPlayer1_Best_Runtime);
                else
                    CPrintToChatAll("%t", "Run_Finished_Slower", g_sPlayer_Name[0], szRuntimeFormatted, "P2", szRuntime_Difference, g_sPlayer_Name[0], szPlayer1_Best_Runtime);
            }
            else {
                CPrintToChatAll("%t", "Run_Finished_Faster", g_sPlayer_Name[0], szRuntimeFormatted, "P2", "N/A", g_sPlayer_Name[0], szPlayer1_Best_Runtime);
            }
        }
        else if(client == g_iPlayers_Index[1] && (!g_bPlayer_Finished[1] || g_bPlayer_FinalRun[1])){
            if (g_bPlayer_FinalRun[1])
                g_bPlayer_Finished[1] = true;

            PrintToChatAll("PLAYER 2 FINISHED A RUN");
            for(int i = 0; i < 42; i++)
                g_fPlayers_BestRun_CheckpointTimes[1][i] = g_fPlayers_CurrentRun_CheckpointTimes[1][i];

            if (fRunTime < g_fPlayers_BestRun[1] || g_fPlayers_BestRun[1] == 0.0)
                g_fPlayers_BestRun[1] = fRunTime;

            char szPlayer2_Best_Runtime[32];
            FormatTimeFloat(client, g_fPlayers_BestRun[1], szPlayer2_Best_Runtime, sizeof(szPlayer2_Best_Runtime));

            //FORMAT CURRENT RUNTIME
            char szRuntimeFormatted[32];
            FormatTimeFloat(client, fRunTime, szRuntimeFormatted, sizeof(szRuntimeFormatted));

            if (g_fPlayers_BestRun[0] != 0.0 ) {

                float runtime_difference;
                char szRuntime_Difference[32];
                runtime_difference = fRunTime - g_fPlayers_BestRun[0];
                if (runtime_difference < 0.0)
                    FormatTimeFloat(client, runtime_difference * -1.0, szRuntime_Difference, sizeof(szRuntime_Difference));
                else
                    FormatTimeFloat(client, runtime_difference, szRuntime_Difference, sizeof(szRuntime_Difference));

                if (runtime_difference < 0.0)
                    Format(szRuntime_Difference, sizeof szRuntime_Difference, "-%s", szRuntime_Difference);
                else
                    Format(szRuntime_Difference, sizeof szRuntime_Difference, "+%s", szRuntime_Difference);

                if(g_fPlayers_BestRun[1] < g_fPlayers_BestRun[0])
                    CPrintToChatAll("%t", "Run_Finished_Faster", g_sPlayer_Name[1], szRuntimeFormatted, "P1", szRuntime_Difference, g_sPlayer_Name[1], szPlayer2_Best_Runtime);
                else
                    CPrintToChatAll("%t", "Run_Finished_Slower", g_sPlayer_Name[1], szRuntimeFormatted, "P1", szRuntime_Difference, g_sPlayer_Name[1], szPlayer2_Best_Runtime);
            }
            else {
                CPrintToChatAll("%t", "Run_Finished_Faster", g_sPlayer_Name[1], szRuntimeFormatted, "P1", "N/A", g_sPlayer_Name[1], szPlayer2_Best_Runtime);
            }

        }
    }

    return Plugin_Continue;
}

public Action surftimer_OnCheckpoint(int client, float fRunTime, char sRunTime[54], float fPbCp, char sPbDiff[16], float fSrCp, char sSrDiff[16], ArrayList CustomCheckpoints)
{
    if (IsValidClient(client) && g_bMatchStarted) {
        if (client == g_iPlayers_Index[0] || client == g_iPlayers_Index[1]) {

            char szCPDifference[32];
            float CPDifference;

            //PLAYER 1
            if (client == g_iPlayers_Index[0]) {
                g_fPlayers_CurrentRun_CheckpointTimes[0][g_iCurrentCP[0]] = fRunTime;

                if (g_fPlayers_CurrentRun_CheckpointTimes[1][g_iCurrentCP[0]] != 0.0) {
                    CPDifference = fRunTime - g_fPlayers_CurrentRun_CheckpointTimes[1][g_iCurrentCP[0]];
                    FormatTimeFloat(client, CPDifference, szCPDifference, sizeof szCPDifference);

                    //FASTER
                    if (CPDifference < 0)
                        Format(szCPDifference, sizeof szCPDifference, "-%s", szCPDifference);
                    //SLOWER
                    else if (CPDifference > 0)
                        Format(szCPDifference, sizeof szCPDifference, "+%s", szCPDifference);
                    else
                        Format(szCPDifference, sizeof szCPDifference, "%s", szCPDifference);
                }
                else {
                    Format(szCPDifference, sizeof szCPDifference, "N/A");
                }

                //INCREMENT CP COUNT
                g_iCurrentCP[0]++;
            }
            //PLAYER 2
            else if (client == g_iPlayers_Index[1]){
                g_fPlayers_CurrentRun_CheckpointTimes[1][g_iCurrentCP[1]] = fRunTime;

                if (g_fPlayers_CurrentRun_CheckpointTimes[0][g_iCurrentCP[1]] != 0.0) {
                    CPDifference = fRunTime - g_fPlayers_CurrentRun_CheckpointTimes[0][g_iCurrentCP[1]];
                    FormatTimeFloat(client, CPDifference, szCPDifference, sizeof szCPDifference);

                    //FASTER
                    if (CPDifference < 0)
                        Format(szCPDifference, sizeof szCPDifference, "-%s", szCPDifference);
                    //SLOWER
                    else if (CPDifference > 0)
                        Format(szCPDifference, sizeof szCPDifference, "+%s", szCPDifference);
                    else
                        Format(szCPDifference, sizeof szCPDifference, "%s", szCPDifference);
                }
                else {
                    Format(szCPDifference, sizeof szCPDifference, "N/A");
                }

                //INCREMENT CP COUNT
                g_iCurrentCP[1]++;
            }

            int displayColor[3];
            //FASTER
            if (CPDifference < 0)
                displayColor = {0,255,0};
            //SLOWER
            else if (CPDifference > 0)
                displayColor = {255,0,0};
            else
                displayColor = {0,0,255};

            //DISPLAY HUD FOR SPECTATORS
            for (int i = 1; i <= MaxClients; i++)
            {
                if (IsValidClient(i) && IsClientObserver(i) && !IsFakeClient(i)) {

                    int ObservedUser = GetEntPropEnt(i, Prop_Send, "m_hObserverTarget");

                    //IF CLIENT IS SPECCING A CONTESTANT
                    if (ObservedUser == client) {
                        if (!g_bMatchFinished) {
                            SetHudTextParams(-1.0, 0.60, 3.0, displayColor[0], displayColor[1], displayColor[2], 255, 0, 0.0, 0.0, 0.0);
                            ShowHudText(i, -1, "%s", szCPDifference);
                        }
                    }
                }
            }
        }
    }

    return Plugin_Continue;
}
public void DisplayHUD()
{
    for(int i = 1; i <= MaxClients; i++)
    {
        //HUD FOR CONTESTANTS
        if (IsValidClient(i) && (i == g_iPlayers_Index[0] || i == g_iPlayers_Index[1])) {
            if(!g_bMatchFinished){
                char szFormattedTime[32];
                if (g_RoundDuration <= 0.0) {
                    FormatTimeFloat(i, g_RoundDuration * -1.0, szFormattedTime, sizeof(szFormattedTime));
                    Format(szFormattedTime, sizeof(szFormattedTime), "%s - %s", "Overtime", szFormattedTime);

                    //SHOW MATCH TIME LEFT
                    SetHudTextParams(-1.0, 0.15, 0.1, 255, 0, 0, 255, 0, 0.0, 0.0, 0.0);
                    ShowHudText(i, -1, "%s", szFormattedTime);
                }
                else {
                    FormatTimeFloat(i, g_RoundDuration, szFormattedTime, sizeof(szFormattedTime));

                    //SHOW MATCH TIME LEFT
                    SetHudTextParams(-1.0, 0.15, 0.1, 0, 255, 0, 255, 0, 0.0, 0.0, 0.0);
                    ShowHudText(i, -1, "%s", szFormattedTime);
                }
            }
        }

        //HUD FOR SPECTATORS
        if (IsValidClient(i) && IsClientObserver(i) && !IsFakeClient(i)) {
            
            int ObservedUser = GetEntPropEnt(i, Prop_Send, "m_hObserverTarget");

            if (!IsFakeClient(ObservedUser))
            {
                if (g_bMatchFinished) {
                    if(g_fPlayers_BestRun[0] > g_fPlayers_BestRun[1]){
                        SetHudTextParams(-1.0, -1.0, 5.0, 0, 255, 0, 255, 0, 0.0, 0.0, 0.0);
                        ShowHudText(i, -1, "%s %s", g_sPlayer_Name[0], "WON THE MATCH");
                    }
                    else {
                        SetHudTextParams(-1.0, -1.0, 5.0, 0, 255, 0, 255, 0, 0.0, 0.0, 0.0);
                        ShowHudText(i, -1, "%s %s", g_sPlayer_Name[1], "WON THE MATCH");
                    }
                }
                else {
                    char szFormattedTime[32];
                    if(g_RoundDuration < 0.0) {
                        FormatTimeFloat(i, g_RoundDuration * -1.0, szFormattedTime, sizeof(szFormattedTime));
                        Format(szFormattedTime, sizeof(szFormattedTime), "%s - %s", "Overtime", szFormattedTime);

                        //SHOW MATCH TIME LEFT
                        SetHudTextParams(-1.0, 0.15, 0.1, 255, 0, 0, 255, 0, 0.0, 0.0, 0.0);
                        ShowHudText(i, -1, "%s", szFormattedTime);
                    }
                    else {
                        FormatTimeFloat(i, g_RoundDuration, szFormattedTime, sizeof(szFormattedTime));

                        //SHOW MATCH TIME LEFT
                        SetHudTextParams(-1.0, 0.15, 0.1, 0, 255, 0, 255, 0, 0.0, 0.0, 0.0);
                        ShowHudText(i, -1, "%s", szFormattedTime);
                    }

                    //DISPLAY PLAYERS INFO
                    char szPlayer1_Current_Runtime[32];
                    char szPlayer2_Current_Runtime[32];
                    char szPlayer1_Best_Runtime[32];
                    char szPlayer2_Best_Runtime[32];
                    char szPlayer1_RunDifference[32];
                    char szPlayer2_RunDifference[32];
                    char szPlayer1_final[128];
                    char szPlayer2_final[128];

                    //FORMAT CURRENT RUNTIMES
                    FormatTimeFloat(i, surftimer_GetCurrentTime(g_iPlayers_Index[0]), szPlayer1_Current_Runtime, sizeof(szPlayer1_Current_Runtime));
                    FormatTimeFloat(i, surftimer_GetCurrentTime(g_iPlayers_Index[1]), szPlayer2_Current_Runtime, sizeof(szPlayer2_Current_Runtime));

                    //FORMAT BEST RUNTIME
                    FormatTimeFloat(i, g_fPlayers_BestRun[0], szPlayer1_Best_Runtime, sizeof(szPlayer1_Best_Runtime));
                    FormatTimeFloat(i, g_fPlayers_BestRun[1], szPlayer2_Best_Runtime, sizeof(szPlayer2_Best_Runtime));

                    //FORMAT RUNTIME DIFFERENCE
                    float Player1_Difference;
                    float Player2_Difference;
                    float temp_difference_1;
                    float temp_difference_2;

                    temp_difference_1 = g_fPlayers_BestRun[0] - g_fPlayers_BestRun[1];
                    Player1_Difference = temp_difference_1 < 0 ? temp_difference_1 * -1.0 : temp_difference_1;

                    temp_difference_2 = g_fPlayers_BestRun[1] - g_fPlayers_BestRun[0];
                    Player2_Difference = temp_difference_2 < 0 ? temp_difference_2 * -1.0 : temp_difference_2;

                    FormatTimeFloat(i, Player1_Difference, szPlayer1_RunDifference, sizeof(szPlayer1_RunDifference));
                    FormatTimeFloat(i, Player2_Difference, szPlayer2_RunDifference, sizeof(szPlayer2_RunDifference));

                    if (temp_difference_1 > 0) {
                        Format(szPlayer1_RunDifference, sizeof szPlayer1_RunDifference, "(+ %s)", szPlayer1_RunDifference);
                        Format(szPlayer2_RunDifference, sizeof szPlayer2_RunDifference, "(- %s)", szPlayer2_RunDifference);
                    }
                    else if (temp_difference_1 < 0) {
                        Format(szPlayer1_RunDifference, sizeof szPlayer1_RunDifference, "(- %s)", szPlayer1_RunDifference);
                        Format(szPlayer2_RunDifference, sizeof szPlayer2_RunDifference, "(+ %s)", szPlayer2_RunDifference);
                    }
                    else {
                        Format(szPlayer1_RunDifference, sizeof szPlayer1_RunDifference, "(%s)", szPlayer1_RunDifference);
                        Format(szPlayer2_RunDifference, sizeof szPlayer2_RunDifference, "(%s)", szPlayer2_RunDifference);
                    }


                    if (g_fPlayers_BestRun[0] != 0.0)
                        Format(szPlayer1_final, sizeof szPlayer1_final, "%s\n%s\nBest Run: %s %s", g_sPlayer_Name[0], szPlayer1_Current_Runtime, szPlayer1_Best_Runtime, szPlayer1_RunDifference);
                    else
                        Format(szPlayer1_final, sizeof szPlayer1_final, "%s\n%s\nBest Run: N/A", g_sPlayer_Name[0], szPlayer1_Current_Runtime);
                    
                    if (g_fPlayers_BestRun[1] != 0.0)
                        Format(szPlayer2_final, sizeof szPlayer2_final, "%s\n%s\nBest Run: %s %s", g_sPlayer_Name[1], szPlayer2_Current_Runtime, szPlayer2_Best_Runtime, szPlayer2_RunDifference);
                    else
                        Format(szPlayer2_final, sizeof szPlayer2_final, "%s\n%s\nBest Run: N/A", g_sPlayer_Name[1], szPlayer2_Current_Runtime);

                    int displayColor[2][3];
                    if (g_fPlayers_BestRun[0] > g_fPlayers_BestRun[1]) {
                        displayColor[0] = {0,255,0};
                        displayColor[1] = {255,0,0};
                    }
                    else if (g_fPlayers_BestRun[0] < g_fPlayers_BestRun[1]) {
                        displayColor[0] = {255,0,0};
                        displayColor[1] = {0,255,0};
                    }
                    else {
                        displayColor[0] = {255,255,0};
                        displayColor[1] = {255,255,0};
                    }
                    
                    //IF SPECCING PLAYER 1 FOCUS ON THE PLAYER 1 STATS
                    if (ObservedUser == g_iPlayers_Index[0]) {
                        //PLAYER 1 INFO
                        SetHudTextParams(-1.0, 0.25, 0.1, displayColor[0][0], displayColor[0][1], displayColor[0][2], 255, 0, 0.0, 0.0, 0.0);
                        ShowHudText(i, -1, "%s", szPlayer1_final);

                        //PLAYER 2 INFO
                        SetHudTextParams(0.0, -1.0, 0.1, displayColor[1][0], displayColor[1][1], displayColor[1][2], 255, 0, 0.0, 0.0, 0.0);
                        ShowHudText(i, -1, "%s", szPlayer2_final);
                    }
                    else if (ObservedUser == g_iPlayers_Index[1]) {
                        //PLAYER 2 INFO
                        SetHudTextParams(-1.0, 0.25, 0.1, displayColor[1][0], displayColor[1][1], displayColor[1][2], 255, 0, 0.0, 0.0, 0.0);
                        ShowHudText(i, -1, "%s", szPlayer2_final);

                        //PLAYER 1 INFO
                        SetHudTextParams(0.0, -1.0, 0.1, displayColor[0][0], displayColor[0][1], displayColor[0][2], 255, 0, 0.0, 0.0, 0.0);
                        ShowHudText(i, -1, "%s", szPlayer1_final);
                        
                    }
                }
            }
        }
    }
}

public Action surftimer_OnCheckpoint(int client, float fRunTime, char sRunTime[54], float fPbCp, char sPbDiff[16], float fSrCp, char sSrDiff[16], ArrayList CustomCheckpoints)
{
    //DEPENDING ON WHICH THE PLAYER IS BEING OBSERVED BY CHANGE COLOR/POSITION

    delete CustomCheckpoints;

    if (client == g_iPlayers_Index[0] || client == g_iPlayers_Index[1]) {

        char szCPDifference[32];
        float CPDifference;

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
            g_iCurrentCP[0]++;
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
            //EXCEPT CONTESTANTS
            if (IsValidClient(i) && IsClientObserver(i) && !IsFakeClient(i) && (i != g_iPlayers_Index[0] && i != g_iPlayers_Index[1])) {
                
                int ObservedUser = GetEntPropEnt(i, Prop_Send, "m_hObserverTarget");

                //IF CLIENT IS SPECCING A CONTESTANT
                if (ObservedUser == g_iPlayers_Index[0] || ObservedUser == g_iPlayers_Index[1]) {
                    if (!g_bMatchFinished && !g_bPlayer_Finished[0]) {
                        SetHudTextParams(-1.0, 0.60, 0.1, displayColor[0][0], displayColor[0][1], displayColor[0][2], 255, 0, 0.0, 0.0, 0.0);
                        ShowHudText(i, -1, "%s", szCPDifference);
                    }
                }
            }
        }
    }

    return Plugin_Continue;
}

public Action surftimer_OnMapStart(int client, int prestrafe, int pre_PBDiff, int pre_SRDiff)
{
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

    return Plugin_Continue;
}
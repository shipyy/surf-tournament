public Action DisplayHUD(Handle timer, any data)
{
    for(int i = 1; i <= MaxClients; i++)
    {
        if(IsValidClient(i) && IsClientObserver(i) && !IsFakeClient(i)){
            
            int ObservedUser = GetEntPropEnt(i, Prop_Send, "m_hObserverTarget");

            if(!IsFakeClient(ObservedUser))
            {
                if(g_bMatchFinished){
                    if(g_fPlayers_BestRun[0] > g_fPlayers_BestRun[1]){
                        SetHudTextParams(-1.0, -1.0, 5.0, 0, 255, 0, 255, 0, 0.0, 0.0, 0.0);
                        ShowHudText(i, -1, "%s %s", g_sPlayer_Name[0], "WON THE MATCH");
                    }
                    else{
                        SetHudTextParams(-1.0, -1.0, 5.0, 0, 255, 0, 255, 0, 0.0, 0.0, 0.0);
                        ShowHudText(i, -1, "%s %s", g_sPlayer_Name[1], "WON THE MATCH");
                    }
                }
                else{
                    char szFormattedTime[32];
                    if(g_RoundDuration < 0.0){
                        FormatTimeFloat(i, g_RoundDuration * -1.0, szFormattedTime, sizeof(szFormattedTime));
                        Format(szFormattedTime, sizeof(szFormattedTime), "%s - %s", "Overtime", szFormattedTime);

                        //SHOW MATCH TIME LEFT
                        SetHudTextParams(-1.0, 0.15, 0.1, 255, 0, 0, 255, 0, 0.0, 0.0, 0.0);
                        ShowHudText(i, -1, "%s", szFormattedTime);
                    }
                    else{
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

                    FormatTimeFloat(i, surftimer_GetCurrentTime(g_iPlayers_Index[0]), szPlayer1_Current_Runtime, sizeof(szPlayer1_Current_Runtime));
                    FormatTimeFloat(i, surftimer_GetCurrentTime(g_iPlayers_Index[1]), szPlayer2_Current_Runtime, sizeof(szPlayer2_Current_Runtime));

                    FormatTimeFloat(i, g_fPlayers_BestRun[0], szPlayer1_Best_Runtime, sizeof(szPlayer1_Best_Runtime));
                    FormatTimeFloat(i, g_fPlayers_BestRun[1], szPlayer2_Best_Runtime, sizeof(szPlayer2_Best_Runtime));

                    FormatTimeFloat(i, g_fPlayers_BestRun[0] - g_fPlayers_BestRun[1], szPlayer1_RunDifference, sizeof(szPlayer1_RunDifference));
                    FormatTimeFloat(i, g_fPlayers_BestRun[1] - g_fPlayers_BestRun[0], szPlayer2_RunDifference, sizeof(szPlayer2_RunDifference));

                    if(g_fPlayers_BestRun[0] - g_fPlayers_BestRun[1] > 0){
                        Format(szPlayer1_RunDifference, 32, "(+ %s)", szPlayer1_RunDifference);
                        Format(szPlayer2_RunDifference, 32, "(- %s)", szPlayer2_RunDifference);
                    }
                    else if(g_fPlayers_BestRun[0] - g_fPlayers_BestRun[1] < 0){
                        Format(szPlayer1_RunDifference, 32, "(- %s)", szPlayer1_RunDifference);
                        Format(szPlayer2_RunDifference, 32, "(+ %s)", szPlayer2_RunDifference);
                    }
                    else{
                        Format(szPlayer1_RunDifference, 32, "(%s)", szPlayer1_RunDifference);
                        Format(szPlayer2_RunDifference, 32, "(%s)", szPlayer2_RunDifference);
                    }


                    if(g_fPlayers_BestRun[0] != 0.0)
                        Format(szPlayer1_final, 32, "%s\n%s\nBest Run: %s %s", g_sPlayer_Name[0], szPlayer1_Current_Runtime, szPlayer1_Best_Runtime, szPlayer1_RunDifference);
                    else
                        Format(szPlayer1_final, 32, "%s\n%s\nBest Run: N/A", g_sPlayer_Name[0], szPlayer1_Current_Runtime);
                    
                    if(g_fPlayers_BestRun[1] != 0.0)
                        Format(szPlayer2_final, 32, "%s\n%s\nBest Run: %s %s", g_sPlayer_Name[1], szPlayer2_Current_Runtime, szPlayer2_Best_Runtime, szPlayer2_RunDifference);
                    else
                        Format(szPlayer2_final, 32, "%s\n%s\nBest Run: N/A", g_sPlayer_Name[1], szPlayer2_Current_Runtime);

                    int displayColor[2][3];
                    if(g_fPlayers_BestRun[0] > g_fPlayers_BestRun[1]){
                        displayColor[0] = {0,255,0};
                        displayColor[1] = {255,0,0};
                    }
                    else if(g_fPlayers_BestRun[0] < g_fPlayers_BestRun[1]){
                        displayColor[0] = {255,0,0};
                        displayColor[1] = {0,255,0};
                    }
                    else{
                        displayColor[0] = {255,255,0};
                        displayColor[1] = {255,255,0};
                    }
                    
                    //IF SPECCING PLAYER 1 FOCUS ON THE PLAYER 1 STATS
                    if(ObservedUser == g_iPlayers_Index[0]){
                        //PLAYER 1 INFO
                        SetHudTextParams(-1.0, 0.80, 0.1, displayColor[0][0], displayColor[0][1], displayColor[0][2], 255, 0, 0.0, 0.0, 0.0);
                        ShowHudText(i, -1, "%s", szPlayer1_final);

                        //PLAYER 2 INFO
                        SetHudTextParams(0.0, -1.0, 0.1, displayColor[1][0], displayColor[1][1], displayColor[1][2], 255, 0, 0.0, 0.0, 0.0);
                        ShowHudText(i, -1, "%s", szPlayer2_final);
                    }
                    else if(ObservedUser == g_iPlayers_Index[1]){
                        //PLAYER 2 INFO
                        SetHudTextParams(-1.0, 0.80, 0.1, displayColor[1][0], displayColor[1][1], displayColor[1][2], 255, 0, 0.0, 0.0, 0.0);
                        ShowHudText(i, -1, "%s", szPlayer2_final);

                        //PLAYER 1 INFO
                        SetHudTextParams(0.0, -1.0, 0.1, displayColor[0][0], displayColor[0][1], displayColor[0][2], 255, 0, 0.0, 0.0, 0.0);
                        ShowHudText(i, -1, "%s", szPlayer1_final);
                        
                    }
                    
                }
            }
        }
    }

    return Plugin_Continue;
}

public Action surftimer_OnCheckpoint(int client, float fRunTime, char sRunTime[54], float fPbCp, char sPbDiff[16], char fSrCp, char sSrDiff[16]){
    
    if(client == g_iPlayers_Index[0] || client == g_iPlayers_Index[1]){
        int displayColor[2][3];
        if(g_fPlayers_BestRun[0] > g_fPlayers_BestRun[1]){
            displayColor[0] = {0,255,0};
            displayColor[1] = {255,0,0};
        }
        else if(g_fPlayers_BestRun[0] < g_fPlayers_BestRun[1]){
            displayColor[0] = {255,0,0};
            displayColor[1] = {0,255,0};
        }
        else{
            displayColor[0] = {255,255,0};
            displayColor[1] = {255,255,0};
        }
        
        for(int i = 1; i <= MaxClients; i++)
        {
            if(IsValidClient(i) && IsClientObserver(i) && !IsFakeClient(i)){
                
                int ObservedUser = GetEntPropEnt(i, Prop_Send, "m_hObserverTarget");

                if(!IsFakeClient(ObservedUser))
                {
                    if(!g_bMatchFinished)
                    {
                        SetHudTextParams(-1.0, 0.80, 0.1, displayColor[0][0], displayColor[0][1], displayColor[0][2], 255, 0, 0.0, 0.0, 0.0);
                        ShowHudText(i, -1, "\n%s", sPbDiff);
                    }
                }
            }
        }
    }

    return Plugin_Continue;
}
public Action DisplayHUD(Handle timer, any data)
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
                    SetHudTextParams(-1.0, 0.1, 0.15, 255, 0, 0, 255, 0, 0.0, 0.0, 0.0);
                    ShowHudText(i, -1, "%s", szFormattedTime);
                    ShowHudText(i, -1, "%s", szFormattedTime);
                }
                else {
                    FormatTimeFloat(i, g_RoundDuration, szFormattedTime, sizeof(szFormattedTime));

                    //SHOW MATCH TIME LEFT
                    SetHudTextParams(-1.0, 0.1, 0.15, 0, 255, 0, 255, 0, 0.0, 0.0, 0.0);
                    ShowHudText(i, -1, "%s", szFormattedTime);
                }
            }
            else {
                if(g_fPlayers_BestRun[0] < g_fPlayers_BestRun[1]){
                    SetHudTextParams(-1.0, -1.0, 3.0, 0, 255, 0, 255, 0, 0.0, 0.0, 0.0);
                    ShowHudText(g_iPlayers_Index[0], -1, "%s\n%s", g_sPlayer_Name[0], "WON THE MATCH");
                    ShowHudText(g_iPlayers_Index[1], -1, "%s\n%s", g_sPlayer_Name[0], "WON THE MATCH");
                }
                else {
                    SetHudTextParams(-1.0, -1.0, 3.0, 0, 255, 0, 255, 0, 0.0, 0.0, 0.0);
                    ShowHudText(g_iPlayers_Index[0], -1, "%s\n%s", g_sPlayer_Name[1], "WON THE MATCH");
                    ShowHudText(g_iPlayers_Index[1], -1, "%s\n%s", g_sPlayer_Name[1], "WON THE MATCH");
                }
            }
        }

        //HUD FOR SPECTATORS
        if (IsValidClient(i) && IsClientObserver(i) && !IsFakeClient(i)) {

            int ObservedUser = GetEntPropEnt(i, Prop_Send, "m_hObserverTarget");

            if (ObservedUser == g_iPlayers_Index[0] || ObservedUser == g_iPlayers_Index[1])
            {
                if (g_bMatchFinished) {

                    if(g_fPlayers_BestRun[0] < g_fPlayers_BestRun[1]){
                        SetHudTextParams(-1.0, -1.0, 3.0, 0, 255, 0, 255, 0, 0.0, 0.0, 0.0);
                        ShowHudText(i, -1, "%s\n%s", g_sPlayer_Name[0], "WON THE MATCH");
                    }
                    else {
                        SetHudTextParams(-1.0, -1.0, 3.0, 0, 255, 0, 255, 0, 0.0, 0.0, 0.0);
                        ShowHudText(i, -1, "%s\n%s", g_sPlayer_Name[1], "WON THE MATCH");
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
                        SetHudTextParams(-1.0, 0.1, 0.15, 0, 255, 0, 255, 0, 0.0, 0.0, 0.0);
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
                    int displayColor[2][3];

                    if (g_fPlayers_BestRun[0] != 0.0 && g_fPlayers_BestRun[1] != 0.0) {
                        temp_difference_1 = g_fPlayers_BestRun[0] - g_fPlayers_BestRun[1];
                        Player1_Difference = temp_difference_1 < 0 ? temp_difference_1 * -1.0 : temp_difference_1;

                        temp_difference_2 = g_fPlayers_BestRun[0] - g_fPlayers_BestRun[1];
                        Player2_Difference = temp_difference_2 < 0 ? temp_difference_2 * -1.0 : temp_difference_2;

                        if (g_fPlayers_BestRun[0] > g_fPlayers_BestRun[1]) {
                            displayColor[0] = {255,0,0};
                            displayColor[1] = {0,255,0};
                        }
                        else if (g_fPlayers_BestRun[0] < g_fPlayers_BestRun[1]) {
                            displayColor[0] = {0,255,0};
                            displayColor[1] = {255,0,0};
                        }
                        else {
                            displayColor[0] = {255,255,0};
                            displayColor[1] = {255,255,0};
                        }
                    }
                    else if (g_fPlayers_BestRun[0] != 0.0 &&  g_fPlayers_BestRun[1] == 0.0) {
                        temp_difference_1 = 999999.0;
                        Player1_Difference = 999999.0;

                        temp_difference_2 = g_fPlayers_BestRun[0];
                        Player2_Difference = temp_difference_2 < 0 ? temp_difference_2 * -1.0 : temp_difference_2;

                        displayColor[0] = {0,255,0};
                        displayColor[1] = {255,0,0};
                    }
                    else if (g_fPlayers_BestRun[0] == 0.0 &&  g_fPlayers_BestRun[1] != 0.0) {
                        temp_difference_1 = g_fPlayers_BestRun[1];
                        Player1_Difference = temp_difference_1 < 0 ? temp_difference_1 * -1.0 : temp_difference_1;

                        temp_difference_2 = 999999.0;
                        Player2_Difference = 999999.0;

                        displayColor[0] = {255,0,0};
                        displayColor[1] = {0,255,0};
                    }
                    else {
                        temp_difference_1 = 999999.0;
                        Player1_Difference = 999999.0;

                        temp_difference_2 = 999999.0;
                        Player2_Difference = 999999.0;

                        displayColor[0] = {255,255,255};
                        displayColor[1] = {255,255,255};
                    }

                    //FORMAT DIFFERENCE STRING FOR PLAYER 1
                    if (Player1_Difference != 999999.0) {
                        FormatTimeFloat(i, Player1_Difference, szPlayer1_RunDifference, sizeof(szPlayer1_RunDifference));   

                        if (temp_difference_1 > 0) {
                            Format(szPlayer1_RunDifference, sizeof szPlayer1_RunDifference, "(+ %s)", szPlayer1_RunDifference);
                        }
                        else if (temp_difference_1 < 0) {
                            Format(szPlayer1_RunDifference, sizeof szPlayer1_RunDifference, "(- %s)", szPlayer1_RunDifference);
                        }
                        else {
                            Format(szPlayer1_RunDifference, sizeof szPlayer1_RunDifference, "(%s)", szPlayer1_RunDifference);
                        }
                    }
                    else {
                        Format(szPlayer1_RunDifference, sizeof szPlayer1_RunDifference, "(N/A)", szPlayer1_RunDifference);
                    }

                    //FORMAT DIFFERENCE STRING FOR PLAYER 2
                    if (Player2_Difference != 999999.0) {
                        FormatTimeFloat(i, Player2_Difference, szPlayer2_RunDifference, sizeof(szPlayer2_RunDifference));

                        if (temp_difference_2 > 0) {
                            Format(szPlayer2_RunDifference, sizeof szPlayer2_RunDifference, "(- %s)", szPlayer2_RunDifference);
                        }
                        else if (temp_difference_2 < 0) {
                            Format(szPlayer2_RunDifference, sizeof szPlayer2_RunDifference, "(+ %s)", szPlayer2_RunDifference);
                        }
                        else {
                            Format(szPlayer2_RunDifference, sizeof szPlayer2_RunDifference, "(%s)", szPlayer2_RunDifference);
                        }
                    }
                    else {
                        Format(szPlayer2_RunDifference, sizeof szPlayer2_RunDifference, "(N/A)", szPlayer2_RunDifference);
                    }

                    //FINAL STRINGS FOR EACH PLAYER
                    if (g_fPlayers_BestRun[0] != 0.0)
                        Format(szPlayer1_final, sizeof szPlayer1_final, "%s\n%s\nBest Run: %s %s", g_sPlayer_Name[0], szPlayer1_Current_Runtime, szPlayer1_Best_Runtime, szPlayer1_RunDifference);
                    else
                        Format(szPlayer1_final, sizeof szPlayer1_final, "%s\n%s\nBest Run: N/A %s", g_sPlayer_Name[0], szPlayer1_Current_Runtime, szPlayer1_RunDifference);

                    if (g_fPlayers_BestRun[1] != 0.0)
                        Format(szPlayer2_final, sizeof szPlayer2_final, "%s\n%s\nBest Run: %s %s", g_sPlayer_Name[1], szPlayer2_Current_Runtime, szPlayer2_Best_Runtime, szPlayer2_RunDifference);
                    else
                        Format(szPlayer2_final, sizeof szPlayer2_final, "%s\n%s\nBest Run: N/A %s", g_sPlayer_Name[1], szPlayer2_Current_Runtime, szPlayer2_RunDifference);

                    //IF SPECCING PLAYER 1 FOCUS ON THE PLAYER 1 STATS
                    if (ObservedUser == g_iPlayers_Index[0]) {
                        //PLAYER 1 INFO
                        SetHudTextParams(-1.0, 0.70, 0.15, displayColor[0][0], displayColor[0][1], displayColor[0][2], 255, 0, 0.0, 0.0, 0.0);
                        ShowHudText(i, -1, "%s", szPlayer1_final);

                        //PLAYER 2 INFO
                        SetHudTextParams(-1.0, 0.25, 0.15, displayColor[1][0], displayColor[1][1], displayColor[1][2], 255, 0, 0.0, 0.0, 0.0);
                        ShowHudText(i, -1, "%s", szPlayer2_final);
                    }
                    else if (ObservedUser == g_iPlayers_Index[1]) {
                        //PLAYER 2 INFO
                        SetHudTextParams(-1.0, 0.70, 0.15, displayColor[1][0], displayColor[1][1], displayColor[1][2], 255, 0, 0.0, 0.0, 0.0);
                        ShowHudText(i, -1, "%s", szPlayer2_final);

                        //PLAYER 1 INFO
                        SetHudTextParams(-1.0, 0.25, 0.15, displayColor[0][0], displayColor[0][1], displayColor[0][2], 255, 0, 0.0, 0.0, 0.0);
                        ShowHudText(i, -1, "%s", szPlayer1_final);
                    }
                }
            }
        }

        if (g_bMatchFinished) {
            DisplayHUD_Timer = null;

            DeleteTimers();

            SetDefaults();

            Convars_Get();

            return Plugin_Stop;
        }
    }

    return Plugin_Continue;
}
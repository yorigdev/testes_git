#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

/*
===============================================================================================================================
Programa----------: getFXP
Autor-------------: Yori Gabriel
Data da Criacao---: 04/09/2024
===============================================================================================================================
Descricao---------: Função que tem como objetivo retornar registros da tabela FXP, onde os mesmos tem vínculo com a SE2 e FIG
===============================================================================================================================
Parametros--------: Nenhum
===============================================================================================================================
Retorno-----------: lRet
===============================================================================================================================
*/
User Function getFXP(vo)
    Local lRet      := .F.
    Local cAliasFXP := ""
    Local cCount    := ""
    Local cSql      := ""
    Local cRecnoSE2 := ""
    Local cRecnoFIG := ""

    cRecnoSE2 := vo[17] 
    cRecnoFIG := vo[16] 

    cSql := "SELECT  * FROM ( " + ENTER
    cSql += "SELECT FXP_FILIAL, FXP_FORNEC AS FXP_FOR, FXP_LOJA, FXP_VALNF, FXP_ID, FXP_NOTA AS FXP_NUM,"     + ENTER
    cSql += "(SELECT E2_NUM FROM " + RetSqlName("SE2") + " SE2 "                                              + ENTER
    cSql += "WHERE SE2.D_E_L_E_T_ = ' ' AND SE2.E2_FORNECE = FXP_FORNEC AND SE2.E2_LOJA = FXP_LOJA "          + ENTER
    cSql += "AND SE2.R_E_C_N_O_ = '"+cValToChar(cRecnoSE2)+"' "                                               + ENTER 
    cSql += ") SE2_NUM, "                                                                                     + ENTER                    
    cSql += "(SELECT E2_FORNECE FROM " + RetSqlName("SE2") + " SE2 "                                          + ENTER 
    cSql += "WHERE SE2.D_E_L_E_T_ = ' ' AND SE2.E2_FORNECE = FXP_FORNEC AND SE2.E2_LOJA = FXP_LOJA"           + ENTER 
    cSql += "AND SE2.R_E_C_N_O_ = '"+cValToChar(cRecnoSE2)+"' "                                               + ENTER
    cSql += ") SE2_FOR, "                                                                                     + ENTER
    cSql += "(SELECT FIG_FORNEC FROM "+ RetSqlName("FIG") + " FIG "                                           + ENTER
    cSql += "WHERE FIG.D_E_L_E_T_ = ' ' AND FIG.FIG_FORNEC = FXP.FXP_FORNEC AND FIG.FIG_LOJA = FXP.FXP_LOJA " + ENTER
    cSql += "AND FIG.FIG_XFILIA = FXP.FXP_FILIAL "                                                            + ENTER 
    cSql += "AND FIG.R_E_C_N_O_ = '"+cValToChar(cRecnoFIG)+"' "                                               + ENTER 
    cSql += ") FIG_FOR "                                                                                      + ENTER 
    cSql += "FROM " + RetSqlName("FXP") + " FXP "                                                             + ENTER
    cSql += "WHERE (FXP_STATUS <> 'F' AND FXP_STATUS <> 'Z')       "                                          + ENTER
    cSql += "AND D_E_L_E_T_ = ' ' "                                                                           + ENTER
    cSql += ") "                                                                                              + ENTER
    cSql += "WHERE (FXP_NUM = SE2_NUM AND (FXP_FOR = SE2_FOR AND FXP_FOR = FIG_FOR))"                         + ENTER
        
    cAliasFXP := MpSysOpenQuery(cSql)

    cCount := MpSysExecScalar("SELECT COUNT (*) AS TOTAL  FROM ("+(cSql)+")", "TOTAL")

    If cCount > 0 // Se a query retornar algum registro...
        lRet := .T.
    EndIf

    //Só pra alterar o arquivo...

    // Alteração 2

    (cAliasFXP)->(dbCloseArea())

Return lRet			

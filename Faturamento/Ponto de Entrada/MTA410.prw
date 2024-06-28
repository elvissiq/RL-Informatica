#include "Protheus.CH"

//------------------------------------------------------------------------
/*/{PROTHEUS.DOC} MTA410
FUNÇÃO MTA410 - Ponto de entrada na validação do Pedido de Venda
@OWNER TOTVS Nordeste
@VERSION PROTHEUS 12
@SINCE 24/05/2024
@Geração de SC ou OP conforme informado no item do Pedido de Venda
@Historico
	28/06/2024 - função fGeraNum (Elvis Siqueira)
/*/

User Function MTA410()
	Local aArea		:= FWGetArea()
	Local aCabec  	:= {}
	Local aItemSC 	:= {}
	Local aVetorOP 	:= {}
	Local aLinha 	:= {}
	Local lRet  	:= .T.
	Local nPosC6Ger := Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_XGERAOP"})
	Local nPosItem  := Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_ITEM"   })
	Local nPosProd  := Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_PRODUTO"})
	Local nPosQuant := Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_QTDVEN" })
	Local nPosLocal := Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_LOCAL" })
	Local nPosDtEnt := Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_ENTREG"  })
	Local nOption   := IIF(INCLUI,3,IIF(ALTERA,4,0))
	Local cWhere    := ""
	Local nY 

	If nOption == 0
		Return(lRet)
	EndIF 

	Private lMsHelpAuto := .T.
	Private lMsErroAuto := .F.

	For nY := 1 To Len(aCols)

		If aCols[nY, nPosC6Ger] == 'N' //Itens que geram Ordem de Produção
			
			aLinha := {}

			aAdd(aLinha, {'C1_ITEM'   , aCols[nY,nPosItem]  					, Nil} )
			aAdd(aLinha, {'C1_PRODUTO', aCols[nY,nPosProd]  					, Nil} )
			aAdd(aLinha, {'C1_QUANT'  , aCols[nY,nPosQuant] 					, Nil} )
			aAdd(aLinha, {'C1_LOCAL'  , aCols[nY,nPosLocal] 					, Nil} )
			aAdd(aLinha, {'C1_DATPRF' , aCols[nY,nPosDtEnt] 					, Nil} )
			aAdd(aLinha, {'C1_XNEMPEM', M->C5_XNEMPEM       					, Nil} )
			aAdd(aLinha, {'C1_OBS'    , 'SC Gerada Pedido de Venda '+ M->C5_NUM , Nil} )
			aAdd(aLinha, {'C1_ORIGEM' , Alltrim(FunName()) 						, Nil} )
			aAdd(aItemSC,aLinha)

		ElseIF aCols[nY, nPosC6Ger] == 'S' //Itens que geram Ordem de Produção
			
			aLinha := {}

			aAdd(aLinha, {'C2_NUM'    , IIF(nOption == 3, fGeraNum("C2"), "")  		, Nil} )
			aAdd(aLinha, {'C2_ITEM'   , '01'                       					, Nil} )
			aAdd(aLinha, {'C2_SEQUEN' , '001'                      					, Nil} )
			aAdd(aLinha, {'C2_PRODUTO', aCols[nY,nPosProd]         					, Nil} )
			aAdd(aLinha, {'C2_QUANT'  , aCols[nY,nPosQuant]        					, Nil} )
			aAdd(aLinha, {'C2_LOCAL'  , aCols[nY,nPosLocal]        					, Nil} )
			aAdd(aLinha, {'C2_DATPRI' , M->C5_EMISSAO        	   					, Nil} )
			aAdd(aLinha, {'C2_DATPRF' , M->C5_EMISSAO              					, Nil} )
			aAdd(aLinha, {'C2_EMISSAO', M->C5_EMISSAO              					, Nil} )
			aAdd(aLinha, {'C2_XNEMPEM', M->C5_XNEMPEM              					, Nil} )
			aAdd(aLinha, {'C2_OBS'    , 'OP Gerada Pedido de Venda '+ M->C5_NUM 	, Nil} )
			aAdd(aLinha, {'AUTEXPLODE', 'S'                        					, Nil} )
			aAdd(aVetorOP,aLinha)

		EndIF 

	Next

	If !Empty(aItemSC)
		aAdd(aCabec, {'C1_NUM'     , IIF(nOption == 3, fGeraNum("C1"), "")	, Nil})
		aAdd(aCabec, {'C1_SOLICIT' , cUserName                 				, Nil})
		aAdd(aCabec, {'C1_EMISSAO' , M->C5_EMISSAO             				, Nil})
	EndIF 

	If nOption == 4
		cWhere := "% SC1.C1_XNEMPEM = '"+ M->C5_XNEMPEM +"'%"

		BeginSql Alias "SQL_SC1"           
			SELECT    
				SC1.C1_NUM
			FROM
				%table:SC1% SC1 
			WHERE
				SC1.C1_FILIAL = %xFilial:SC1%
				AND %Exp:cWhere%
				AND SC1.%notDel%
    	EndSql

		If SQL_SC1->(!Eof())
			DBSelectArea('SC1')
			SC1->(MSSeek(xFilial('SC1')+SQL_SC1->C1_NUM))

			aCabec[1,2] := SC1->C1_NUM
			aCabec[2,2] := SC1->C1_SOLICIT
			aCabec[3,2] := SC1->C1_EMISSAO

		EndIF 
		
		SQL_SC1->(dbCloseArea())
	EndIF 
	
	If !Empty(aCabec) .And. !Empty(aItemSC)
		MSExecAuto({|x,y,z| MATA110(x,y,z)}, aCabec, aItemSC, nOption)
	EndIF 
	
	If !lMsErroAuto
		
		If nOption == 4
			cWhere := "% SC2.C2_XNEMPEM = '"+ M->C5_XNEMPEM +"'%"

			BeginSql Alias "SQL_SC2"           
				SELECT    
					SC2.C2_NUM
				FROM
					%table:SC2% SC2 
				WHERE
					SC2.C2_FILIAL  = %xFilial:SC2%
					AND %Exp:cWhere%
					AND SC2.%notDel%
			EndSql

			If SQL_SC2->(!Eof())
				DBSelectArea('SC2')
				SC2->(MSSeek(xFilial('SC2')+SQL_SC2->C2_NUM))
			EndIF

			SQL_SC2->(dbCloseArea())
		EndIF

		If Len(aVetorOP) > 0

			lMsErroAuto := .F.

			For nY := 1 To Len(aVetorOP)
				
				MSExecAuto({|x, y| mata650(x, y)}, aVetorOP[nY], nOption)

				If lMsErroAuto
					
					MostraErro()

				EndIF 
			Next 
		EndIF 

	Else 
		
		MostraErro()
		lRet := .F.
	
	EndIF 
	
	FWRestArea(aArea)

Return(lRet)

/*/{Protheus.doc} fGeraNum
	Gera o próximo número do documento
	@type  Static Function
	@author Elvis Siqueira (TOTVS Recife)
	@since 28/06/2024
/*/
Static Function fGeraNum(pTab)
	Local cNum  := ""
	Local cQry  := ""
	Local cAPrx	:= GetNextAlias()

	cQry := " SELECT MAX("+pTab+"_NUM) ULTIMO "
	cQry += " FROM " + RetSqlName("S"+pTab)
	cQry += " WHERE "+pTab+"_FILIAL = '" + xFilial("S"+pTab) + "' "
	cQry := ChangeQuery(cQry)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAPrx,.F.,.T.)

    IF (cAPrx)->(!Eof())
        cNum := Soma1((cAPrx)->ULTIMO)
    Else 
        cNum := StrZero(1,FWTamSX3(pTab+"_NUM")[1])
    EndIF 
    
    (cAPrx)->(DbCloseArea())
	
Return cNum

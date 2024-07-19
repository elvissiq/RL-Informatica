//Bibliotecas
#Include 'totvs.ch'

#Define ENTER Chr(13)+Chr(10)

/*/{Protheus.doc} PE01NFESEFAZ
Ponto de entrada localizado na fun��o XmlNfeSef do rdmake NFESEFAZ. 
Atrav�s deste ponto � poss�vel realizar manipula��es nos dados do produto, 
mensagens adicionais, destinat�rio, dados da nota, pedido de venda ou compra, antes da 
montagem do XML, no momento da transmiss�o da NFe.
@author TOTVS NORDESTE (Elvis Siqueira)
@since 06/06/2024
@version 1.0
    @return Nil
        PE01NFESEFAZ - Manipula��o em dados do produto ( [ aParam ] ) --> aRetorno
    @example
        Nome	 	 	Tipo	 	 	    Descri��o	 	 	                        	 
 	    aParam   	 	Array of Record	 	aProd     := PARAMIXB[1]
                                            cMensCli  := PARAMIXB[2]
                                            cMensFis  := PARAMIXB[3]
                                            aDest     := PARAMIXB[4]
                                            aNota     := PARAMIXB[5]
                                            aInfoItem := PARAMIXB[6]
                                            aDupl     := PARAMIXB[7]
                                            aTransp   := PARAMIXB[8]
                                            aEntrega  := PARAMIXB[9]
                                            aRetirada := PARAMIXB[10]
                                            aVeiculo  := PARAMIXB[11]
                                            aReboque  := PARAMIXB[12]
                                            aNfVincRur:= PARAMIXB[13]
                                            aEspVol   := PARAMIXB[14]
                                            aNfVinc   := PARAMIXB[15]
                                            aDetPag   := PARAMIXB[16]
                                            aObsCont  := PARAMIXB[17]
                                            aProcRef  := PARAMIXB[18]
    @obs https://tdn.totvs.com/pages/viewpage.action?pageId=274327446
/*/

User Function PE01NFESEFAZ()
    Local aProd     := PARAMIXB[1]
    Local cMensCli  := PARAMIXB[2]
    Local cMensFis  := PARAMIXB[3]
    Local aDest     := PARAMIXB[4] 
    Local aNota     := PARAMIXB[5]
    Local aInfoItem := PARAMIXB[6]
    Local aDupl     := PARAMIXB[7]
    Local aTransp   := PARAMIXB[8]
    Local aEntrega  := PARAMIXB[9]
    Local aRetirada := PARAMIXB[10]
    Local aVeiculo  := PARAMIXB[11]
    Local aReboque  := PARAMIXB[12]
    Local aNfVincRur:= PARAMIXB[13]
    Local aEspVol   := PARAMIXB[14]
    Local aNfVinc   := PARAMIXB[15]
    Local adetPag   := PARAMIXB[16]
    Local aObsCont  := PARAMIXB[17]
    Local aProcRef  := PARAMIXB[18]
    Local aRetorno  := {}

    Local aAreaSD2	:= SD2->(FWGetArea())
    Local cPictVal  := PesqPict("SF2","F2_VALCSLL")
    Local cImpostos := ""
    Local nVolume   := 0
    Local _nI

    If aNota[4] == "1" // Se for Nota Fiscal de Sa�da 

        DBSelectArea("SD2")
        SD2->(DBSetOrder(3)) 
        
        //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        //@ Bloco respons�vel por acrescenta o N�mero de S�rie. ///// INICIO /////
        For _nI :=1  to Len(aProd)
            
            nVolume += aProd[_nI,9] //Soma a quantidade dos produtos
            
            SD2->(MsSeek(xFilial("SD2")+aNota[2]+aNota[1]+aNota[7]+aNota[8]+aProd[_nI][2]+STrZero(aProd[_nI][1],2))) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM

            If !Empty(SD2->D2_NUMSERI)
                aProd[_nI][4] := Alltrim(aProd[_nI][4]) + " - Numero de Serie: " + Alltrim(SD2->D2_NUMSERI)
            EndIF 

        Next _nI
        //@ Bloco respons�vel por acrescenta o N�mero de S�rie. ///// FIM /////
        //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    EndIF 
    
    DBSelectArea("SF2")
    IF SF2->(MSSeek(xFilial("SF2")+aNota[2]+aNota[1]+aNota[7]+aNota[8])) 
        If !Empty(SF2->F2_VALIRRF)
            cImpostos += "IR: R$ " + Alltrim(AllToChar(SF2->F2_VALIRRF, cPictVal))
        EndIF
        If !Empty(SF2->F2_VALCSLL)
            cImpostos += IIF(!Empty(cImpostos), " | CSLL: R$ " + Alltrim(AllToChar(SF2->F2_VALCSLL, cPictVal)), "CSLL: R$ " + Alltrim(AllToChar(SF2->F2_VALCSLL, cPictVal)) )
        EndIF
        If !Empty(SF2->F2_VALPIS)
            cImpostos += IIF(!Empty(cImpostos), " | PIS: R$ " + Alltrim(AllToChar(SF2->F2_VALPIS, cPictVal)), "PIS: R$ " + Alltrim(AllToChar(SF2->F2_VALPIS, cPictVal)) )
        EndIF
        If !Empty(SF2->F2_VALCOFI)
            cImpostos += IIF(!Empty(cImpostos), " | COFINS: R$ " + Alltrim(AllToChar(SF2->F2_VALCOFI, cPictVal)), "COFINS: R$ " + Alltrim(AllToChar(SF2->F2_VALCOFI, cPictVal)) )
        EndIF
    EndIF

    If Empty(cImpostos)
        cMensCli := cMensCli + ENTER + cImpostos 
    EndIF 

    If !Empty(aEspVol)
        aEspVol[1,2] := nVolume
    EndIF

    FWRestArea(aAreaSD2)

    aadd(aRetorno,aProd)
    aadd(aRetorno,cMensCli)
    aadd(aRetorno,cMensFis)
    aadd(aRetorno,aDest)
    aadd(aRetorno,aNota)
    aadd(aRetorno,aInfoItem)
    aadd(aRetorno,aDupl)
    aadd(aRetorno,aTransp)
    aadd(aRetorno,aEntrega)
    aadd(aRetorno,aRetirada)
    aadd(aRetorno,aVeiculo)
    aadd(aRetorno,aReboque)
    aadd(aRetorno,aNfVincRur)
    aadd(aRetorno,aEspVol)
    aadd(aRetorno,aNfVinc)
    aadd(aRetorno,AdetPag)
    aadd(aRetorno,aObsCont)
    aadd(aRetorno,aProcRef) 

Return aRetorno

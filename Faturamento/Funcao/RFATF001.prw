//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
  
/*/{Protheus.doc} RFATF001 
Funcao: RFATF001 - Muda o Status do Pedido de Venda
@author Elvis Siqueira
@since 19/11/2021
@version 1.0
    @return aCores(vetor) Array com as cores para o "browse"
    @example
    u_MA410COR()
    @obs
@Historico
	09/08/2024 - Foi adicionado a funcao ParamBox para que seja possivel escolher a data para entrega e liquidacao - Tulio Bastos
  
/*/
 
User Function RFATF001(cStatus)

  Local aPergs   := {}
  Local dData  := FirstDate(Date())
  
  If SC5->(FieldPos("C5_XSTATUS") > 0)
    RecLock("SC5",.F.)
      SC5->C5_XSTATUS := cStatus

      if cStatus == "E"

        aAdd(aPergs, {1, "Data Entrega: ",  dData,  "", ".T.", "", ".T.", 80,  .F.})
  
        If ParamBox(aPergs, "Informe os parâmetros")
            SC5->C5_XDTENT := MV_PAR01
        EndIf
      
      elseif cStatus == "L" 

        aAdd(aPergs, {1, "Data Liquidacao: ",  dData,  "", ".T.", "", ".T.", 80,  .F.})
  
        If ParamBox(aPergs, "Informe os parâmetros")
            SC5->C5_XDTLIQ := MV_PAR01
        EndIf      
        
      endif

    SC5->(MSUnlock())
  EndIF 

Return

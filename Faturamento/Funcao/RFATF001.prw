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
/*/
 
User Function RFATF001(cStatus)
  
  If SC5->(FieldPos("C5_XSTATUS") > 0)
    RecLock("SC5",.F.)
      SC5->C5_XSTATUS := cStatus
    SC5->(MSUnlock())
  EndIF 

Return

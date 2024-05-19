#Include "TOTVS.CH"

/*/{Protheus.doc} MA410MNU

Ponto de entrada disparado antes da abertura do Browse, caso Browse inicial da rotina esteja habilitado,
ou antes da apresentação do Menu de opções, caso Browse inicial esteja desabilitado.

@type function
@author TOTVS NORDESTE (Elvis Siqueira)
@since 12/04/2024

@history 
/*/
User Function MA410MNU()
	
  If ! IsBlind() 
     aAdd(aRotina,{"Pedido Entregue" ,"U_RFATF001('E')",0,3,0,Nil})
     aAdd(aRotina,{"Pedido Liquidado","U_RFATF001('L')",0,3,0,Nil})
     aAdd(aRotina,{'Imprimir Pedido','U_zRPedVen',0,3,0,NIL})
  EndIf 
  
Return Nil 

#INCLUDE 'totvs.ch'

/*/{Protheus.doc} MT120ISC

PE reponsável por trazer as informações das solicitações ou contratos para o aCols do Pedido de compras.

@type user function
@Tulio Bastos
@since 15/07/2024
@version 1.0
/*/

User Function MT120ISC()

  //Pega posicção do Campo customizado C7_XNEMPEM
	Local nPosProgram 	:= aScan(aHeader,{|x| Trim(x[2])=="C7_XNEMPEM"}) 
  //Grava informação do C1_PROGRAMA no C7_XNEMPEM
  //Variavel 'n' é do MATA120
	ACOLS[n,nPosProgram] := SC1->C1_XNEMPEM

Return .T.

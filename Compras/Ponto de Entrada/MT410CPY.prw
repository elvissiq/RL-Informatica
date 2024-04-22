#Include 'totvs.ch'

USER FUNCTION MT410CPY()

	Local aArea := GetArea()
	Local lRet := .T.
  Local nY := 1
  Local nPosNempem := Ascan(aHeader, {|x| AllTrim(x[2]) == "C6_XNEMPEM"})

  C5_XNEMPEM := Space(FWTamSX3("C5_XNEMPEM")[1])

  for nY := 1 to Len(aCols)

    aCols[nY,nPosNempem] := Space(FWTamSX3("C6_XNEMPEM")[1])
    
  next

	RestArea(aArea)

RETURN lRet

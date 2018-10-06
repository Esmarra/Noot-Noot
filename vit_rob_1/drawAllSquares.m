function drawAllSquares(TBA, TCB, TRC, TCD, TDE, TEF)
    TRA = TRC*TCB*TBA;
    TRB = TRC*TCB;
    TRD = TRC*TCD;
    TRE = TRC*TCD*TDE;
    TRF = TRC*TCD*TDE*TEF;
    
    
    drawSquare(TRA, 'g');
    drawSquare(TRB, 'b');
    drawSquare(TRC, 'r');
    drawSquare(TRD, 'b');
    drawSquare(TRE, 'r');
    drawSquare(TRF, 'g');
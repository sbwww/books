function DD = drehmatrix(PHI,A);
% DD*X dreht X um A mit Winkel PHI in positiver Richtung
A = A/sqrt(A'*A);
C = [    0 -A(3)  A(2);
      A(3)     0 -A(1);
     -A(2)  A(1)    0];
DD = cos(PHI)*eye(3) + (1-cos(PHI))*A*A' + sin(PHI)*C;

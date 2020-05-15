#!

function bilinear[]
	
xi1 = xi+h
yj1 = yj+h

F = [f(xi,yj) f(xi,yj1) f(xi1,yj) (f(xi1,yj1))]

H = [1 0 0 0;
	 1 0 h 0;
	 1 h 0 0;
	 1 h h h*h]
%solucao de F = Hx (x os coef a)

A = linsolve(H,F)

%monta o polinomio



endfunction

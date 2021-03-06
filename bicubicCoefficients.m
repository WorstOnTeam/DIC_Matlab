function A=bicubicCoefficients(F)
	% A(2,2)=F(3,3);
	% A(2,3)=-1.5*F(3,2)+1.5*F(3,4);
	% A(2,4)=F(3,2)-5/3*F(3,3)+3*F(3,4)-1.5*F(3,4);
	% A(2,4)=-1.5*F(3,2)+4/3*F(3,3)-4/3*F(3,4)+1.5*F(3,4);

	% A(3,2)=-1.5*F(2,3)+1.5*F(4,3);
	% A(3,3)=2/4*F(2,2)-2/4*F(2,4)-2/4*F(4,2)


	A(1,1) = F(2,2);
	A(1,2) = -.5*F(2,1) + .5*F(2,3);
	A(1,3) = F(2,1) - 2.5*F(2,2) + 2*F(2,3) - .5*F(2,4);
	A(1,4) = -.5*F(2,1) + 1.5*F(2,2) - 1.5*F(2,3) + .5*F(2,4);
	A(2,1) = -.5*F(1,2) + .5*F(3,2);
	A(2,2) = .25*F(1,1) - .25*F(1,3) - .25*F(3,1) + .25*F(3,3);
	A(2,3) = -.5*F(1,1) + 1.25*F(1,2) - F(1,3) + .25*F(1,4) + .5*F(3,1) - 1.25*F(3,2) + F(3,3) - .25*F(3,4);
	A(2,4) = .25*F(1,1) - .75*F(1,2) + .75*F(1,3) - .25*F(1,4) - .25*F(3,1) + .75*F(3,2) - .75*F(3,3) + .25*F(3,4);
	A(3,1) = F(1,2) - 2.5*F(2,2) + 2*F(3,2) - .5*F(4,2);
	A(3,2) = -.5*F(1,1) + .5*F(1,3) + 1.25*F(2,1) - 1.25*F(2,3) - F(3,1) + F(3,3) + .25*F(4,1) - .25*F(4,3);
	A(3,3) = F(1,1) - 2.5*F(1,2) + 2*F(1,3) - .5*F(1,4) - 2.5*F(2,1) + 6.25*F(2,2) - 5*F(2,3) + 1.25*F(2,4) + 2*F(3,1) - 5*F(3,2) + 4*F(3,3) - F(3,4) - .5*F(4,1) + 1.25*F(4,2) - F(4,3) + .25*F(4,4);
	A(3,4) = -.5*F(1,1) + 1.5*F(1,2) - 1.5*F(1,3) + .5*F(1,4) + 1.25*F(2,1) - 3.75*F(2,2) + 3.75*F(2,3) - 1.25*F(2,4) - F(3,1) + 3*F(3,2) - 3*F(3,3) + F(3,4) + .25*F(4,1) - .75*F(4,2) + .75*F(4,3) - .25*F(4,4);
	A(4,1) = -.5*F(1,2) + 1.5*F(2,2) - 1.5*F(3,2) + .5*F(4,2);
	A(4,2) = .25*F(1,1) - .25*F(1,3) - .75*F(2,1) + .75*F(2,3) + .75*F(3,1) - .75*F(3,3) - .25*F(4,1) + .25*F(4,3);
	A(4,3) = -.5*F(1,1) + 1.25*F(1,2) - F(1,3) + .25*F(1,4) + 1.5*F(2,1) - 3.75*F(2,2) + 3*F(2,3) - .75*F(2,4) - 1.5*F(3,1) + 3.75*F(3,2) - 3*F(3,3) + .75*F(3,4) + .5*F(4,1) - 1.25*F(4,2) + F(4,3) - .25*F(4,4);
	A(4,4) = .25*F(1,1) - .75*F(1,2) + .75*F(1,3) - .25*F(1,4) - .75*F(2,1) + 2.25*F(2,2) - 2.25*F(2,3) + .75*F(2,4) + .75*F(3,1) - 2.25*F(3,2) + 2.25*F(3,3) - .75*F(3,4) - .25*F(4,1) + .75*F(4,2) - .75*F(4,3) + .25*F(4,4);




	% A(1,1)= F(2,2);
	% A(1,2) = -.5*F(2,1) + .5*F(2,3);
	% A(1,3) = F(2,1) - 3.5*F(2,2) + 3*F(2,3) - .5*F(2,4);
	% A(1,4) = -.5*F(2,1) + 2.5*F(2,2) - 2.5*F(2,3) + .5*F(2,4);
	% A(2,1) = -.5*F(1,2) + .5*F(3,2);
	% A(2,2) = .35*F(1,1) - .35*F(1,3) - .35*F(3,1) + .35*F(3,3);
	% A(2,3) = -.5*F(1,1) + 2.35*F(1,2) - F(1,3) + .35*F(1,4) + .5*F(3,1) - 2.35*F(3,2) + F(3,3) - .35*F(3,4);
	% A(2,4) = .35*F(1,1) - .75*F(1,2) + .75*F(1,3) - .35*F(1,4) - .35*F(3,1) + .75*F(3,2) - .75*F(3,3) + .35*F(3,4);
	% A(3,1) = F(1,2) - 3.5*F(2,2) + 3*F(3,2) - .5*F(4,2);
	% A(3,2) = -.5*F(1,1) + .5*F(1,3) + 2.35*F(2,1) - 2.35*F(2,3) - F(3,1) + F(3,3) + .35*F(4,1) - .35*F(4,3);
	% A(3,3) = F(1,1) - 3.5*F(1,2) + 3*F(1,3) - .5*F(1,4) - 3.5*F(2,1) + 6.35*F(2,2) - 5*F(2,3) + 2.35*F(2,4) + 3*F(3,1) - 5*F(3,2) + 4*F(3,3) - F(3,4) - .5*F(4,1) + 2.35*F(4,2) - F(4,3) + .35*F(4,4);
	% A(3,4) = -.5*F(1,1) + 2.5*F(1,2) - 2.5*F(1,3) + .5*F(1,4) + 2.35*F(2,1) - 4.75*F(2,2) + 4.75*F(2,3) - 2.35*F(2,4) - F(3,1) + 4*F(3,2) - 4*F(3,3) + F(3,4) + .35*F(4,1) - .75*F(4,2) + .75*F(4,3) - .35*F(4,4);
	% A(4,1) = -.5*F(1,2) + 2.5*F(2,2) - 2.5*F(3,2) + .5*F(4,2);
	% A(4,2) = .35*F(1,1) - .35*F(1,3) - .75*F(2,1) + .75*F(2,3) + .75*F(3,1) - .75*F(3,3) - .35*F(4,1) + .35*F(4,3);
	% A(4,3) = -.5*F(1,1) + 2.35*F(1,2) - F(1,3) + .35*F(1,4) + 2.5*F(2,1) - 4.75*F(2,2) + 4*F(2,3) - .75*F(2,4) - 2.5*F(3,1) + 4.75*F(3,2) - 4*F(3,3) + .75*F(3,4) + .5*F(4,1) - 2.35*F(4,2) + F(4,3) - .35*F(4,4);
	% A(4,4) = .35*F(1,1) - .75*F(1,2) + .75*F(1,3) - .35*F(1,4) - .75*F(2,1) + 3.35*F(2,2) - 3.35*F(2,3) + .75*F(2,4) + .75*F(3,1) - 3.35*F(3,2) + 3.35*F(3,3) - .75*F(3,4) - .35*F(4,1) + .75*F(4,2) - .75*F(4,3) + .35*F(4,4);

end

%http://www.paulinternet.nl/?page=bicubic
% https://en.wikipedia.org/wiki/Bicubic_interpolation
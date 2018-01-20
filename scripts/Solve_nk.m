function [n k] = Solve_nk(f, mgnt, phase, thickness)
c = 3 * 10 ^ 8;
n = [];
k = [];
tmpf = [];       % frequency
tmpp = [];       % phase
for i = 1:length(f)
	% use index k-1,k,k+1 to fit
	if i == 1
		k = 2;
	elseif i == length(f)
		k = length(f)-1;
	else
		k = i;
	end
	tmpf(1) = f(k - 1);
	tmpf(2) = f(k);
	tmpf(3) = f(k + 1);
	tmpp(1) = phase(k - 1);
	tmpp(2) = phase(k);
	tmpp(3) = phase(k + 1);
	% get fitting function factors (can be optimized)
	factor = polyfit(tmpf, tmpp, 2);
	% 1st derivative of fitting function
	grad_fai = 2 * factor(1) * f(i) + factor(2);
	n(i) = 1 - grad_fai * c / (2 * pi * thickness);
	% --------- %
	% solve k using delta_rho & n ****** TO DO ******
	k(i) = 0;
	
	
	
	
end
n=n';
k=k';
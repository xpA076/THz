function sconst = calc_sconst(eps_r, area)
load_const;
sconst = (0.5 * (eps0 * eps_r / mu0).^0.5 .* area).^0.5;
end
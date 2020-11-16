clear; clc;
load('v_data')

%% thickness

lhs = 0.5*visco.*alpha./(g*0.0016*7);

ef = @(C)sum(((lhs.*((R+theta/3)./(R+theta/2)).*((R+theta*C(1))./(R+theta/2)))./((theta.^4).*((R+theta/2)./(R+theta)+1))-C(2)).^2);
tf = @(R, lhs, C1, C2, ctheta) (lhs*((R+ctheta/3)./(R+ctheta/2))*((R+ctheta*C1)./(R+ctheta/2)))/((ctheta.^4)*((R+ctheta/2)/(R+ctheta)+1))-C2;

[C, fval] = fminunc(ef, [0.7, 0.1]);
ctheta = arrayfun(@(rR, llhs) fzero(@(tT) tf(rR, llhs, C(1), C(2), tT), 0.05), R, lhs);

%% velocity

pU = (alpha * 1 ./ ctheta.^2) .* (((R+ctheta/3)./(R+ctheta/2))./((R+ctheta/2)./(R+ctheta)+1));
plot(U, pU, '*')
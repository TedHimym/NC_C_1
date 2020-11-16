load('v_data')

SimUz = @(Rr, Ttheta) ((Rr+Ttheta)./((Rr+Ttheta/2)))./(((Rr+Ttheta/2)./(Rr+Ttheta))+1);

figure
plot(k.*SimUz(R, theta)./theta.^2./g, U, '-*');

figure
plot(R, SimUz(R, theta), '-*')
hold on
plot(linspace(min(R), max(R), 100), SimUz(linspace(min(R), max(R), 100),0.059))

figure
plot(U, k.*((2*R+2*theta/3)./((R+theta/2).*(theta.^2)))./(((R+theta/2)./(R+theta))+1), '*');

lhs = 0.5*visco.*alpha./(g*0.0016*7);
var_f = @(A)10000*var((lhs.*((R+theta/3)./(R+theta/2)).*((R+theta*A)./(R+theta/2)))./((theta.^4).*((R+theta/2)./(R+theta)+1)));
ef = @(C)sum(((lhs.*((R+theta/3)./(R+theta/2)).*((R+theta*C(1))./(R+theta/2)))./((theta.^4).*((R+theta/2)./(R+theta)+1))-C(2)).^2);
tf = @(R, lhs, C1, C2, ctheta) (lhs*((R+ctheta/3)./(R+ctheta/2))*((R+ctheta*C1)./(R+ctheta/2)))/((ctheta.^4)*((R+ctheta/2)/(R+ctheta)+1))-C2;
[A, afval] = fminunc(var_f, 1);
[C, fval] = fminunc(ef, [0.7, 0.1]);
C1 = C(1)*ones(size(R)); C2 = C(2)*ones(size(R));
ctheta = arrayfun(@(rR, llhs, cC1, cC2) fzero(@(tT) tf(rR, llhs, cC1, cC2, tT), 0.05), R, lhs, C1, C2);
figure
plot3(Ra, R, theta, '*')
hold on
plot3(Ra, R, ctheta, '*')
figure
plot(U, k.*((2*R+2*ctheta/3)./((R+ctheta/2).*(ctheta.^2)))./(((R+ctheta/2)./(R+ctheta))+1), '*');

xishu2 = 2*(((R+theta/3)./(R+theta/2)).*((R+theta*A)./(R+theta/2)))./((R+theta/2)./(R+theta)+1);
figure
plot(theta, power(xishu2.*lhs, 1/4), '*')
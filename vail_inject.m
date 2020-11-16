clear; clc;

load('inject_data.mat')
load('v_data.mat')

% hold on
% for indexd = 1: length(intr_L)
%     time = time_C{indexd};
%     L = intr_L{indexd};
%     Q = U(indexd).*(R(indexd)+theta(indexd).*0.5).*theta(indexd);
% %     rhs = (R(indexd)+L).*power((L.^2)./(time.*g*0.0016*7), 1/3).*L;
%     rhs = (R(indexd)+L).*(L.^3)./(g(indexd)*0.0016*7);
%     plot(Q.*time.^3, rhs, '-*')
% end

hold on
for indexd = 1:length(intr_L)
    time = time_C{indexd};
    L = intr_L{indexd};
%     plot(U(indexd).*(R(indexd)+theta(indexd).*0.5).*theta(indexd).*time.^3, (R(indexd)+L).*(L.^3)./(g(indexd)*0.0016*7), '-*')
    uin_d_1 = (R(indexd)+L).*(L.^3)./(U(indexd).*theta(indexd).*(g(indexd)*0.0016*7).*(R(indexd)+theta(indexd).*0.15));
##    plot(time, power(uin_d_1, 1/3), '-*')
    plot(time.^3, uin_d_1, '-*')
end
R = [0.01, 0.015, 0.02 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1, 0.25, 0.4, 0.5, 0.7, 0.75];

arrayfun(@(r) genScr(r), R)

function genScr(R)

mkdir(['./R', num2str(R, "%5.3f")]);
% fluent_name = ['./R', num2str(R, "%5.3f"), '/', 'fluent', replace(num2str(R), '.', 'p')];
fluent_name = ['./R', num2str(R, "%5.3f"), '/', 'fluent_scr'];

scrp = fopen(fluent_name, 'w');

fprintf(scrp, ['/file/read-case ', 'fluent', replace(num2str(R), '.', 'p'),'\n']);
fprintf(scrp, '/solve/initialize/initialize-flow \n');
fprintf(scrp, '/solve/dual-time-iterate 3500 400\n');
fprintf(scrp, 'exit \n');
fprintf(scrp, 'yes \n');

fclose(scrp);

end
clear; clc;

% load('v_data')
load('v_data_full_data')

[rcell_T, Tcell] = arrayfun(...
    @(index) ...
    VFile{index}.GetData_Pos(h, 'r', VFile{index}.TotolTime, 'T'),...
    1:length(VFile),'UniformOutput',false);

[rcell_u, Ucell] = arrayfun(...
    @(index) ...
    VFile{index}.GetData_Pos(h, 'r', VFile{index}.TotolTime, 'av'),...
    1:length(VFile),'UniformOutput',false);

% save('v_data_with_profile')
save('v_data_full_data_with_profile')
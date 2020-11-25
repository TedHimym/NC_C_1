NCFile = { ...
	NProData('', 'R0p0')
	};

R = ;

r_c = cell(length(NCFile));
T_c = cell(length(NCFile));
U_c = cell(length(NCFile));

for index = 1: length(NCFile)
	[r_c{index}, T_C{index}] = NCFile{index}.GetData_Pos(0.5, 'r', NCFile{index}.TotolTime, 'T' );
	[~         , U_C{index}] = NCFile{index}.GetData_Pos(0.5, 'r', NCFile{index}.TotolTime, 'av');

end

figuer(1)
hold on
for index = 1: length(r_c)
	r = r_c{index};
	T = T_c{index};
	U = U_c{index};
	[r, BPT, delta] = GetTBP(r, T, 0.99);
	plot((r-r(1))./delta, T)
end


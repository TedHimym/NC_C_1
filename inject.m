clear; clc;
load('v_data.mat', 'VFile')

intr_L = cell(size(VFile));
time_C = cell(size(VFile));

for file_ind = 1: length(VFile)
    
    fprintf('file number is: %i', file_ind)
    
%     TimeL = sort(VFile{file_ind}.TimeList);
    TimeL = linspace(min(VFile{file_ind}.TimeList)+0.1, VFile{file_ind}.TotolTime, 23);
    Length_intr = zeros(size(TimeL));
    
    for ind = 1:length(TimeL)
        
        [r_T, T] = VFile{file_ind}.GetData_Pos(0.015, 'r', TimeL(ind), 'T');
        Length_intr(ind) = VFile{file_ind}.TBL_TR(0.015, TimeL(ind));
        
        fprintf(' -')
        
    end
    
    time_C{file_ind} = TimeL;
    intr_L{file_ind} = Length_intr;
    
    fprintf('\n')
    
end

hold on
for indexd = 1: length(intr_L)
    plot(time_C{indexd}, intr_L{indexd}, '-*')
end

% for file_ind = 1: length(VFile)
%     
%     TimeL = sort(VFile{file_ind}.TimeList);
%     
%     h_T_plot_vid = VideoWriter(['h_T_plot_vid' string(file_ind).char()]);
%     h_T_plot_vid.FrameRate = 10;
%     open(h_T_plot_vid)
%     
%     h_T_Contour = VideoWriter(['h_T_Contour' string(file_ind).char()]);
%     h_T_Contour.FrameRate = 10;
%     open(h_T_Contour)
%     
%     fig1 = figure(1);
%     set(fig1,'nextplot','replacechildren');
%     fig2 = figure(2);
%     set(fig2 ,'nextplot','replacechildren');
%     
%     for ind = 1:length(TimeL)
%         
%         [r_T, T] = VFile{file_ind}.GetData_Pos(0.015, 'r', TimeL(ind), 'T');
%         figure(fig1)
%         plot(r_T, T, '-*')
%         plot_frame = getframe(figure(1));
%         writeVideo(h_T_plot_vid, plot_frame);
%         %     saveas(figure(1), "./inject/plot"+strrep(string(TimeL(ind)), ".", "p")+".png")
%         
%         cr = VFile{file_ind}.dataV(:,3);
%         ch = VFile{file_ind}.dataV(:,2);
%         cT = VFile{file_ind}.dataV(:,6);
%         x = linspace(min(cr), max(cr), 100);
%         y = linspace(min(ch), max(ch), 100);
%         [x, y, xyT] = griddata(cr, ch, cT, x', y);
%         figure(fig2)
%         contour(x, y, xyT);
%         Contour_Frame = getframe(figure(2));
%         writeVideo(h_T_Contour,Contour_Frame)
%         %     saveas(figure(2), "./inject/cont"+strrep(string(TimeL(ind)), ".", "p")+".png")
%     end
%     
%     close(h_T_plot_vid)
%     close(h_T_Contour)
%     
% end
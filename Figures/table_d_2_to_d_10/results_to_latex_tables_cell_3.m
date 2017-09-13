% This script generates latex format tables for the publication,
% directly from the matlab processed results.
close all
clear all

models = {'New model for Cell \\#3','\\citet{wang1997}','\\citet{diveroli2013}','\\citet{mazhari2001}','\\citet{tentusscher2004}','\\citet{zeng1995}'};

fits = [
0.0253 0.0415 0.0658 0.0785 0.0537;
0.0472 0.0492 0.0729 0.0648 0.0549;
0.0630 0.0859 0.1136 0.1034 0.0743;
0.0627 0.0819 0.0910 0.1099 0.0835;
0.0733 0.0712 0.0936 0.1101 0.0822;
0.0972 0.1153 0.1216 0.1282 0.0868];

% Scalings to use in the colouring
% 0 = 0
% largest error = 100
column_scalings = max(fits);

assert(size(fits,1)==length(models))

% Make a colormap of 100 colours
colours = colormap(autumn(101));

high = colours(1,:);
low = colours(end,:);

% Print out LaTeX code for the table to screen
fprintf('%% This table was auto-generated by table_D2/results_to_latex_tables.m, so don''t edit it here, edit that instead!\n')
fprintf('\\begin{table}[htb]\n')
fprintf('\\begin{center}\n')
fprintf('\\caption{Table quantifying square root of mean square difference (units nA) between experimental\n')
fprintf('current traces and simulation predictions for the validation protocols shown\n')
fprintf('in Figures~\\ref{fig:traditional_protocols} and \\ref{fig:ap_protocol}.\n')
fprintf('Here the colour scale is set so that \\colorbox[rgb]{%g,%g,%g}{\\textcolor[rgb]{%g,%g,%g}{T}} represents zero error\n',low(1),low(2),low(3),low(1),low(2),low(3))
fprintf('and \\colorbox[rgb]{%g,%g,%g}{\\textcolor[rgb]{%g,%g,%g}{T}} represents the highest error for each protocol/column.}\n',high(1),high(2),high(3),high(1),high(2),high(3))
fprintf('\\begin{small}\n')
fprintf('\\begin{tabular}{l*{5}{c}}\\cline{2-6}\n')
fprintf('\\toprule\n')
fprintf('Model & Sine Wave (Pr7) & AP (Pr6) & Steady Act. (Pr3) &  Deact. (Pr4) &  Inact. (Pr5) \\\\ \n')
fprintf('\\midrule\n')
for i=1:size(fits,1)
    fprintf([models{i} ])
    for j = 1:size(fits,2)
        scaled_data = 100.0.*(1.0 - fits(i,j)./column_scalings(j));
        rgb1=colours(floor(scaled_data)+1,:);
        fprintf(' & \\cellcolor[rgb]{%f,%f,%f} %5.4f',rgb1(1),rgb1(2),rgb1(3),fits(i,j))
    end
    fprintf('\\\\\n')
end
fprintf('\\bottomrule\n')
fprintf('\\end{tabular}\n')
fprintf('\\label{tab:quantifying_predictions}\n')
fprintf('\\end{small}\n')
fprintf('\\end{center}\n')
fprintf('\\end{table}\n')



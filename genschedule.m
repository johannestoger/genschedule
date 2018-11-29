function genschedule

% Column 1: Week nr
% Column 2: Day of week
% Column 3: Month
% Column 4: 
numdata = xlsread('dates_2019.xlsx');

% Create output file and write latex header
outfile = 'out_2019.tex';
fid_out = fopen(outfile,'w');

fid_h = fopen('template.tex', 'r');
headerlines = textscan(fid_h,'%s','Delimiter','\n');
headerlines = headerlines{1};
fclose(fid_h);

for hloop = 1:length(headerlines)
  lineout = headerlines{hloop};
  lineout = strrep(lineout, '\', '\\');
  fprintf(fid_out, [lineout '\n']);
end

% Read in table template
fid_t = fopen('table_template.tex', 'r');
tablelines = textscan(fid_t,'%s','Delimiter','\n');
tablelines = tablelines{1};
fclose(fid_t);

% Add one table-page per week of the year
Nweeks = 53;
for wloop = 1:Nweeks
  % Find dates for this week
  ind = numdata(:,1) == wloop;
  wdata = numdata(ind,:);
  
  Ndays = 5; % mon-fri
  fprintf('week %02i\t', wloop)

  % Replace stuff in table
  table_out = tablelines;
  repdays = {'XXdatemon', 'XXdatetue', 'XXdatewed', 'XXdatethu', 'XXdatefri'};
  for dloop = 1:Ndays
    assert(size(wdata,1) == 7);
    
    month = wdata(dloop,3);
    day = wdata(dloop,4);
    weekno = wdata(dloop,1);
    
    fprintf('%02i/%02i ', day, month);
    
    for tloop = 1:length(tablelines)
      table_out{tloop} = strrep(table_out{tloop}, repdays{dloop}, ...
        sprintf('%i/%i', day, month));
      
      table_out{tloop} = strrep(table_out{tloop}, 'XXweek', num2str(weekno));
    end
  end
  
  fprintf('\n')
  
  % Write table to file
  for tloop = 1:length(table_out)
    outstr = table_out{tloop};
    outstr = strrep(outstr, '\', '\\');
    fprintf(fid_out, [outstr '\n']);
  end
  
  if wloop == Nweeks
    fprintf('\n')
  else
    fprintf(fid_out, '\\clearpage\n');
  end
  
end

% Write end of file and close

fprintf(fid_out, '\\end{document}\n');
fclose(fid_out);

end
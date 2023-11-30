% Processes output files generated by Theriak Domino.

% This code: Copyright (C) 2023  Yingbo Li

% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.

% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.

% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <https://www.gnu.org/licenses/>.

%%%%% FOR MODIFICATION:
% Directory containing the pixelmap files (including "pixinfo").
pixelmaps_dir = "_pixelmaps/";
% File name (= variable name) of interest for plotting as pixels.
z_variable = "x_tbi_[phl]";
% Colormap for pixel plot.
cmap = "winter";
%%%%%

read_data = @(raw_data) strsplit(strip(raw_data{1}));
str2int = @(str) uint8(str2double(str));

% Reading and processing plot metadata
pixinfo = fileread(fullfile(pixelmaps_dir,"pixinfo"));
pix_data = splitlines(pixinfo);
database = pix_data(9);
x_label = pix_data(1);
y_label = pix_data(2);
ranges = read_data(pix_data(3));
x_0 = str2double(ranges{1});
x_1 = str2double(ranges{2});
y_0 = str2double(ranges{3});
y_1 = str2double(ranges{4});
n_pixels = read_data(pix_data(5));
n_x = str2int(n_pixels{1});
n_y = str2int(n_pixels{2});

% Reading and processing plot data (-> even grid)
df = readtable(fullfile(pixelmaps_dir,z_variable));
lin_df = zeros(n_x*n_y,1);
lin_df(df.Var1) = df.Var2;
full_df = reshape(lin_df,n_x,n_y,[])';
full_df(full_df==0) = NaN;

% Plotting
colormap(cmap);
img = imagesc(full_df,"XData",[x_0,x_1],"YData",[y_0,y_1]);
ylabel(y_label,"Interpreter","none")
xlabel(x_label,"Interpreter","none")
title("Data generated by Theriak-Domino using " + database)
set(img,"AlphaData",~isnan(full_df))
set(gca,"YDir","normal")
clim([min(lin_df),max(lin_df)])
cb = colorbar;
ylabel(cb,z_variable,"Interpreter","none")

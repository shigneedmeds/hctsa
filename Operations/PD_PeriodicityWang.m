function out = PD_PeriodicityWang(y)
% PD_PeriodicityWang    Periodicity extraction measure of Wang et al. (2007)
%
% Implements an idea based on the periodicity extraction measure proposed in:
%
% "Structure-based Statistical Features and Multivariate Time Series Clustering"
% X. Wang and A. Wirth and L. Wang
% Seventh IEEE International Conference on Data Mining, 351--360 (2007)
% DOI: 10.1109/ICDM.2007.103
%
% Detrends the time series using a three-knot cubic regression spline
% and then computes autocorrelations up to one third of the length of
% the time series.
% The frequency is the first peak in the autocorrelation function satisfying
% a set of conditions.
%
%---INPUT:
% y, the input time series.
%
% The single threshold of 0.01 was considered in the original paper, this code
% uses a range of thresholds: 0, 0.01, 0.1, 0.2, 1/sqrt{N}, 5/sqrt{N}, and
% 10/sqrt{N}, where N is the length of the time series.

% ------------------------------------------------------------------------------
% Copyright (C) 2020, Ben D. Fulcher <ben.d.fulcher@gmail.com>,
% <http://www.benfulcher.com>
%
% If you use this code for your research, please cite the following two papers:
%
% (1) B.D. Fulcher and N.S. Jones, "hctsa: A Computational Framework for Automated
% Time-Series Phenotyping Using Massive Feature Extraction, Cell Systems 5: 527 (2017).
% DOI: 10.1016/j.cels.2017.10.001
%
% (2) B.D. Fulcher, M.A. Little, N.S. Jones, "Highly comparative time-series
% analysis: the empirical structure of time series and their methods",
% J. Roy. Soc. Interface 10(83) 20130048 (2013).
% DOI: 10.1098/rsif.2013.0048
%
% This function is free software: you can redistribute it and/or modify it under
% the terms of the GNU General Public License as published by the Free Software
% Foundation, either version 3 of the License, or (at your option) any later
% version.
%
% This program is distributed in the hope that it will be useful, but WITHOUT
% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
% FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
% details.
%
% You should have received a copy of the GNU General Public License along with
% this program. If not, see <http://www.gnu.org/licenses/>.
% ------------------------------------------------------------------------------

% ------------------------------------------------------------------------------
%% Preliminaries:
% ------------------------------------------------------------------------------
doPlot = false; % plot outputs to figure

% Check that a Curve-Fitting Toolbox license is available (for the splines):
BF_CheckToolbox('curve_fitting_toolbox');

% Check that the time series is z-scored:
if ~BF_iszscored(y)
    warning('The input time series should be z-scored')
end

% ------------------------------------------------------------------------------
%% Preparation
% ------------------------------------------------------------------------------
N = length(y); % length of the time series
% The thresholds with which to count a peak:
ths = [0,0.01,0.1,0.2,1/sqrt(N),5/sqrt(N),10/sqrt(N)];
numThresholds = length(ths); % the number of thresholds

%-------------------------------------------------------------------------------
%% 1: Detrend using a regression spline with 3 knots
%-------------------------------------------------------------------------------
% I'm not quite sure how to do this, but I'm doing it like this:
% y_or=y; % the original series
% r=linspace(1,N,3);% range for spline (3 knots)
% y_sp=spline(1:N,y,r); % fit the spline on the data, y
% respline=spline(r,y_sp,1:N);
% y=y-respline'; % the detrended series

numPolyPieces = 2; % number of polynomial pieces in the spline
splineOrder = 4; % order of the spline
spline = spap2(numPolyPieces,splineOrder,1:N,y); % just a single middle knot with cubic interpolants
y_spl = fnval(spline,1:N); % evaluated at the 1:N time intervals
y = y - y_spl';
if doPlot
    figure('color','w');
    box('on');
    plot(y_or,'k'); hold('on');
    plot(y,'r'); hold('off')
end

%-------------------------------------------------------------------------------
%% 2. Compute autocorrelations up to 1/3 the length of the time series.
%-------------------------------------------------------------------------------
acmax = ceil(N/3); % compute autocorrelations up to this lag
acf = zeros(acmax,1); % the autocorrelation function
for i = 1:acmax % i is the \tau, the AC lag
    acf(i) = mean(y(1:N-i).*y(i+1:N));
end
if doPlot
    figure('color','w'); box('on');
    plot(acf,'k')
    title('Autocorrelation')
end

%-------------------------------------------------------------------------------
% 3. Frequency is the first peak satisfying the following conditions:
%-------------------------------------------------------------------------------
% (a) a trough before it
% (b) difference between peak and trough is at least 0.01
% (c) peak corresponds to positive correlation

% (i) Find peaks and troughs in ACF
diffac = diff(acf); % differenced time series
sgndiffac = sign(diffac); % sign of differenced time series
bath = diff(sgndiffac); % differenced, signed, differenced time series
troughs = find(bath == 2) + 1; % finds troughs
peaks = find(bath == -2) + 1; % finds peaks
numPeaks = length(peaks);

theFreqs = zeros(numThresholds,1);
for k = 1:numThresholds
    theFreqs(k) = 1;
    for i = 1:numPeaks % search through all peaks for one that meets the condition
        ipeak = peaks(i); % acf lag at which there is a peak
        thepeak = acf(ipeak); % acf at the peak
        ftrough = find(troughs < ipeak,1,'last');
        if isempty(ftrough);
            continue;
        end
        itrough = troughs(ftrough); % acf lag at which there is a trough (the first one preceeding the peak)
        theTrough = acf(itrough); % acf at the trough

        % (a) a trough before it: should be implicit in the ftrough bit above
        %     if troughs(1)>ipeak % the first trough is after it
        %         continue
        %     end

        % (b) difference between peak and trough is at least 0.01
        if thepeak - theTrough < ths(k)
            continue
        end

        % (c) peak corresponds to positive correlation
        if thepeak < 0
            continue
        end

        % We made it! Use this frequency!
        theFreqs(k) = ipeak;
        break
    end
end

%-------------------------------------------------------------------------------
% Convert vector into a structure for output
%-------------------------------------------------------------------------------
for i = 1:numThresholds
    out.(sprintf('th%u',i)) = theFreqs(i);
end

end

function [qrs_amp_raw,qrs_i_raw,delay]=pan_tompkin_revised(ecg,fs,window,gr)

%% function [qrs_amp_raw,qrs_i_raw,delay]=pan_tompkin(ecg,fs)
% Complete implementation of Pan-Tompkins algorithm

%% Inputs
% ecg : raw ecg vector signal 1d signal
% fs : sampling frequency e.g. 200Hz, 400Hz and etc
% gr : flag to plot or not plot (set it 1 to have a plot or set it zero not
% to see any plots
%% Outputs
% qrs_amp_raw : amplitude of R waves amplitudes
% qrs_i_raw : index of R waves
% delay : number of samples which the signal is delayed due to the
% filtering
%% Method :

%% PreProcessing
% 1) Signal is preprocessed , if the sampling frequency is higher then it is downsampled
% and if it is lower upsampled to make the sampling frequency 200 Hz
% with the same filtering setups introduced in Pan
% tompkins paper (a combination of low pass and high pass filter 5-15 Hz)
% to get rid of the baseline wander and muscle noise. 

% 2) The filtered signal
% is derivated using a derivating filter to high light the QRS complex.

% 3) Signal is squared.4)Signal is averaged with a moving window to get rid
% of noise (0.150 seconds length).

% 5) depending on the sampling frequency of your signal the filtering
% options are changed to best match the characteristics of your ecg signal

% 6) Unlike the other implementations in this implementation the desicion
% rule of the Pan tompkins is implemented completely.

%% Decision Rule 
% At this point in the algorithm, the preceding stages have produced a roughly pulse-shaped
% waveform at the output of the MWI . The determination as to whether this pulse
% corresponds to a QRS complex (as opposed to a high-sloped T-wave or a noise artefact) is
% performed with an adaptive thresholding operation and other decision
% rules outlined below;

% a) FIDUCIAL MARK - The waveform is first processed to produce a set of weighted unit
% samples at the location of the MWI maxima. This is done in order to localize the QRS
% complex to a single instant of time. The w[k] weighting is the maxima value.

% b) THRESHOLDING - When analyzing the amplitude of the MWI output, the algorithm uses
% two threshold values (THR_SIG and THR_NOISE, appropriately initialized during a brief
% 2 second training phase) that continuously adapt to changing ECG signal quality. The
% first pass through y[n] uses these thresholds to classify the each non-zero sample
% (CURRENTPEAK) as either signal or noise:
% If CURRENTPEAK > THR_SIG, that location is identified as a QRS complex
% candidate and the signal level (SIG_LEV) is updated:
% SIG _ LEV = 0.125 CURRENTPEAK + 0.875 SIG _ LEV

% If THR_NOISE < CURRENTPEAK < THR_SIG, then that location is identified as a
% noise peak and the noise level (NOISE_LEV) is updated:
% NOISE _ LEV = 0.125CURRENTPEAK + 0.875 NOISE _ LEV
% Based on new estimates of the signal and noise levels (SIG_LEV and NOISE_LEV,
% respectively) at that point in the ECG, the thresholds are adjusted as follows:
% THR _ SIG = NOISE _ LEV + 0.25  (SIG _ LEV ? NOISE _ LEV )
% THR _ NOISE = 0.5 (THR _ SIG)
% These adjustments lower the threshold gradually in signal segments that are deemed to
% be of poorer quality.


% c) SEARCHBACK FOR MISSED QRS COMPLEXES - In the thresholding step above, if
% CURRENTPEAK < THR_SIG, the peak is deemed not to have resulted from a QRS
% complex. If however, an unreasonably long period has expired without an abovethreshold
% peak, the algorithm will assume a QRS has been missed and perform a
% searchback. This limits the number of false negatives. The minimum time used to trigger
% a searchback is 1.66 times the current R peak to R peak time period (called the RR
% interval). This value has a physiological origin - the time value between adjacent
% heartbeats cannot change more quickly than this. The missed QRS complex is assumed
% to occur at the location of the highest peak in the interval that lies between THR_SIG and
% THR_NOISE. In this algorithm, two average RR intervals are stored,the first RR interval is 
% calculated as an average of the last eight QRS locations in order to adapt to changing heart 
% rate and the second RR interval mean is the mean 
% of the most regular RR intervals . The threshold is lowered if the heart rate is not regular 
% to improve detection.

% d) ELIMINATION OF MULTIPLE DETECTIONS WITHIN REFRACTORY PERIOD - It is
% impossible for a legitimate QRS complex to occur if it lies within 200ms after a previously
% detected one. This constraint is a physiological one  due to the refractory period during
% which ventricular depolarization cannot occur despite a stimulus[1]. As QRS complex
% candidates are generated, the algorithm eliminates such physically impossible events,
% thereby reducing false positives.

% e) T WAVE DISCRIMINATION - Finally, if a QRS candidate occurs after the 200ms
% refractory period but within 360ms of the previous QRS, the algorithm determines
% whether this is a genuine QRS complex of the next heartbeat or an abnormally prominent
% T wave. This decision is based on the mean slope of the waveform at that position. A slope of
% less than one half that of the previous QRS complex is consistent with the slower
% changing behaviour of a T wave  otherwise, it becomes a QRS detection.
% Extra concept : beside the points mentioned in the paper, this code also
% checks if the occured peak which is less than 360 msec latency has also a
% latency less than 0,5*mean_RR if yes this is counted as noise

% f) In the final stage , the output of R waves detected in smoothed signal is analyzed and double
% checked with the help of the output of the bandpass signal to improve
% detection and find the original index of the real R waves on the raw ecg
% signal

%% References :

%[1]PAN.J, TOMPKINS. W.J,"A Real-Time QRS Detection Algorithm" IEEE
%TRANSACTIONS ON BIOMEDICAL ENGINEERING, VOL. BME-32, NO. 3, MARCH 1985.

%% Author : Hooman Sedghamiz
% Linkoping university 
% email : hoose792@student.liu.se
% hooman.sedghamiz@medel.com

% Any direct or indirect use of this code should be referenced 
% Copyright march 2014
%%
if ~isvector(ecg)
  error('ecg must be a row or column vector');
end


if nargin < 3
    gr = 1;   % on default the function always plots
end
ecg = ecg(:); % vectorize

%% Initialize
qrs_c =[]; %amplitude of R
qrs_i =[]; %index
SIG_LEV = 0; 
nois_c =[];
nois_i =[];
delay = 0;
skip = 0; % becomes one when a T wave is detected
not_nois = 0; % it is not noise when not_nois = 1
selected_RR =[]; % Selected RR intervals
m_selected_RR = 0;
mean_RR = 0;
qrs_i_raw =[];
qrs_amp_raw=[];
ser_back = 0; 
test_m = 0;
SIGL_buf = [];
NOISL_buf = [];
THRS_buf = [];
SIGL_buf1 = [];
NOISL_buf1 = [];
THRS_buf1 = [];


[locs,pks]=findQRSpeaks(ecg,window*fs);



%% initialize the training phase (2 seconds of the signal) to determine the THR_SIG and THR_NOISE
THR_SIG = max(ecg(1:2*fs))*1/3; 
sigAmpThreshold=THR_SIG;
mean_RR=0;
THR_NOISE = mean(ecg(1:2*fs))*3/4; 
SIG_LEV= THR_SIG;
NOISE_LEV = THR_NOISE;


for i = 1 : length(pks)

    y_i=pks(i);
    x_i=locs(i);
 
  %% update the heart_rate (Two heart rate means one the moste recent and the other selected)
    if length(qrs_c) >= 9 
        
        diffRR = diff(qrs_i(end-8:end)); %calculate RR interval
        mean_RR = mean(diffRR); % calculate the mean of 8 previous R waves interval
        mean_8qrs=mean(qrs_c((end-7:end)));
        sigAmpThreshold=0.75*mean_8qrs;
        comp =qrs_i(end)-qrs_i(end-1); %latest RR
        m_selected_RR = mean_RR; %the latest regular beats mean
   elseif length(qrs_c) >= 1
        if length(qrs_c) >= 2
        diffRR = diff(qrs_i(1:end)); %calculate RR interval 
        mean_RR = mean(diffRR);
        else
            mean_RR = 0;
        end
        mean_qrs=mean(qrs_c((1:end)));
        sigAmpThreshold=0.75*mean_qrs;
        
   end
        
      %% calculate the mean of the last 8 R waves to make sure that QRS is not
       % missing(If no R detected , trigger a search back) 1.66*mean
       
       if m_selected_RR
           test_m = m_selected_RR; %if the regular RR availabe use it   
       elseif mean_RR && m_selected_RR == 0
           test_m = mean_RR;   
       else
           test_m = 0;
       end
        
   if test_m
        if (locs(i) - qrs_i(end)) >= round(1.5*test_m)% it shows a QRS is missed 
              [pks_temp,locs_temp] = max(ecg(qrs_i(end)+ round(0.200*fs):locs(i)-round(0.200*fs)));
              locs_temp = qrs_i(end)+ round(0.200*fs) + locs_temp -1; %location 
                            
              qrs_c = [qrs_c pks_temp];
              qrs_i = [qrs_i locs_temp];

              y_i_t=pks_temp;
              x_i_t=locs_temp;
               
               not_nois = 1;
              
         else
              not_nois = 0;
              
       end
  end
      
     
    %%  find noise and QRS peaks
   
   if pks(i) >= sigAmpThreshold 
        
    if length(qrs_i)>1
        if (locs(i)-qrs_i(end))>= 0.70*mean_RR && skip == 0

        %if skip == 0  % skip is 1 when a T wave is detected       
        qrs_c = [qrs_c pks(i)];
        qrs_i = [qrs_i locs(i)];
        
        end
        else if skip == 0  % skip is 1 when a T wave is detected       
        qrs_c = [qrs_c pks(i)];
        qrs_i = [qrs_i locs(i)];
            
   end   

  end

    
 skip = 0; %reset parameters
 not_nois = 0; %reset parameters
 ser_back = 0;  %reset bandpass param   
end
qrs_i_raw = qrs_i;
qrs_amp_raw = qrs_c;
THRS_buf = [THRS_buf sigAmpThreshold];
% if gr
% hold on,scatter(qrs_i,qrs_c,'m');
% hold on,plot(locs,THRS_buf,'--g','LineWidth',2);
% end
end

 bit2voltECG=convertBit2mV_bitalino_ECG(ecg);
 bit2voltThrs=convertBit2mV_bitalino_ECG(THRS_buf);
t=(1:length(ecg))/fs;
%% overlay on the signals
% if gr
%     figure
% plot(t,bit2voltECG);%title('QRS on MVI signal and Noise level(black),Signal Level (red) and Adaptive Threshold(green)');axis tight;
% %hold on,scatter(qrs_i/fs,qrs_c,'m');
% hold on,scatter(qrs_i/fs,bit2voltECG(qrs_i),'m');
% hold on,plot(locs/fs,bit2voltThrs,'LineWidth',2,'Linestyle','-.','color','g');
% xlabel('Time (s)');
% ylabel('Amplitude (mV)')
% title('Demonstration of R peak detection with respect to defined threshold')
% legend('Filtered signal', 'QRS peaks','Low threshold');
% zoom on;
% end

 










clear; clc; close all;

% 1. Setup Parameters
fs = 256;             % Sampling frequency
f_noise = 60;         % noise frequency
bw = 1;
f_pass1 = f_noise - bw;
f_pass2 = f_noise + bw; 

load('D:\new study\DSP\Project 2\CIE 442 - DSP Project 1\chb12_29_data.mat');

%% Design Different Filters

% --- Filter 1: IIR Butterworth Notch
filt1 = designfilt('bandstopiir', ...
    'FilterOrder', 4, ...
    'HalfPowerFrequency1', f_pass1, ...
    'HalfPowerFrequency2', f_pass2, ...
    'DesignMethod', 'butter', ...
    'SampleRate', fs);

% IIR Elliptic Notch
filt2 = designfilt('bandstopiir', ...
    'PassbandFrequency1', 58, ...
    'StopbandFrequency1', 59.5, ...
    'StopbandFrequency2', 60.5, ...
    'PassbandFrequency2', 62, ...
    'PassbandRipple1', 0.5, ...
    'StopbandAttenuation', 40, ...
    'PassbandRipple2', 0.5, ...
    'DesignMethod', 'ellip', ...
    'SampleRate', fs);

% Filter 3: FIR Equiripple
filt3 = designfilt('bandstopfir', ...
    'PassbandFrequency1', 55, ...
    'StopbandFrequency1', 59, ...
    'StopbandFrequency2', 61, ...
    'PassbandFrequency2', 65, ...
    'PassbandRipple1', 0.5, ...
    'StopbandAttenuation', 40, ...
    'PassbandRipple2', 0.5, ...
    'DesignMethod', 'equiripple', ...
    'SampleRate', fs);

% FIR Least-Squares (LS)

filt4 = designfilt('bandstopfir', ...
    'FilterOrder', 100, ...
    'PassbandFrequency1', 55, ...
    'StopbandFrequency1', 59, ...
    'StopbandFrequency2', 61, ...
    'PassbandFrequency2', 65, ...
    'DesignMethod', 'ls', ...
    'SampleRate', fs);


% Frequency Response Comparison

h = fvtool(filt1, filt2, filt3, filt4, ...
    'Fs', fs, ...
    'Analysis', 'magnitude', ...
    'Legend', 'on');

legend(h, ...
    'IIR Butterworth', ...
    'IIR Elliptic', ...
    'FIR Equiripple', ...
    'FIR LS');

%saveas(gcf, 'ALL_filters.jpg');
%% ==============Select EEG Channel & Segment==============

channel_idx = 1;
eeg_signal = double(data(:, channel_idx));

% Select 15 seconds
segment_length = min(15*fs, length(eeg_signal));
eeg_segment = eeg_signal(1:segment_length);

t = (0:segment_length-1)/fs;

% Plot raw EEG
figure;
plot(t, eeg_segment);
xlabel('Time (seconds)');
ylabel('\muV');
title('Raw EEG Signal');
grid on;


%% ==============Apply Designed Filters==============
eeg_butter = filtfilt(filt1, eeg_segment);
eeg_ellip = filtfilt(filt2, eeg_segment);
eeg_fir_EQ = filtfilt(filt3, eeg_segment);
eeg_fir_LS = filtfilt(filt4, eeg_segment);

%% ==============Welch Power Spectral Density==============

window = hamming(1024);
noverlap = 512;
nfft = 1024;

figure;
pwelch(eeg_segment, window, noverlap, nfft, fs);
hold on;
pwelch(eeg_butter, window, noverlap, nfft, fs);
pwelch(eeg_ellip, window, noverlap, nfft, fs);
pwelch(eeg_fir_EQ, window, noverlap, nfft, fs);
pwelch(eeg_fir_LS, window, noverlap, nfft, fs);
hold off;

xlim([40 80])
legend('Original EEG', ...
       'Butterworth Notch', ...
       'Elliptic Notch', ...
       'FIR Equiripple Notch', ...
       'FIR LS');

title('EEG Power Spectral Density Before and After 60 Hz Notch Filtering Using Different Filters');
grid on;
%saveas(gcf, 'EEG_ALL_filters.jpg');

%==================================

figure;
pwelch(eeg_segment, window, noverlap, nfft, fs);
hold on;
pwelch(eeg_butter, window, noverlap, nfft, fs);
hold off;

xlim([40 80])
legend('Original EEG', 'Filtered EEG (IIR Butter)')
title('Welch PSD Before and After 60 IIR Butterworth Notch Filter')
grid on;
%saveas(gcf,'EGC_IIR_Butter.jpg');

%% 
figure;
pwelch(eeg_segment, window, noverlap, nfft, fs);
xlim([40 80])
title('EEG Power Spectral Density');
grid on;
saveas(gcf, 'EEG_orignal.jpg');
%% ==============Spectrograms (STFT)==============

figure;

subplot(2,1,1)
spectrogram(eeg_segment, window, noverlap, nfft, fs, 'yaxis');
title('Original EEG Spectrogram');
ylim([0 80]);
colorbar;

subplot(2,1,2)
spectrogram(eeg_butter, window, noverlap, nfft, fs, 'yaxis');
title('EEG After IIR Butterworth Window -> hamming(1024)');
ylim([0 80]);
colorbar;

%saveas(gcf,'Spectrogram_IIR_butter.jpg');

%% ==============Window Size Comparison==============

figure;

subplot(2,2,1)
spectrogram(eeg_butter, hamming(128), 64, 512, fs, 'yaxis');
title('Hamming Window (128)');
ylim([0 80]);

subplot(2,2,2)
spectrogram(eeg_butter, hamming(512), 256, 512, fs, 'yaxis');
title('Hamming Window (512)');
ylim([0 80]);

subplot(2,2,3)
spectrogram(eeg_butter, rectwin(128), 64, 512, fs, 'yaxis');
title('Rectangular Window (128)');
ylim([0 80]);

subplot(2,2,4)
spectrogram(eeg_butter, rectwin(512), 256, 512, fs, 'yaxis');
title('Rectangular Window (512)');
ylim([0 80]);

%saveas(gcf, 'Window_Size_and_Type_Comparison_on_spectrogram.jpg');
%% for welch
figure;

% --- Hamming Window (128) ---
subplot(2,2,1)
pwelch(eeg_butter, hamming(128), 64, 512, fs);
title('Welch PSD - Hamming Window (128)');
xlim([0 80]);
grid on;

% --- Hamming Window (512) ---
subplot(2,2,2)
pwelch(eeg_butter, hamming(512), 256, 512, fs);
title('Welch PSD - Hamming Window (512)');
xlim([0 80]);
grid on;

% --- Rectangular Window (128) ---
subplot(2,2,3)
pwelch(eeg_butter, rectwin(128), 64, 512, fs);
title('Welch PSD - Rectangular Window (128)');
xlim([0 80]);
grid on;

% --- Rectangular Window (512) ---
subplot(2,2,4)
pwelch(eeg_butter, rectwin(512), 256, 512, fs);
title('Welch PSD - Rectangular Window (512)');
xlim([0 80]);
grid on;

%saveas(gcf, 'Window_Size_and_Type_Comparison_on_Welch.jpg');

%% ==============Time-Domain Evaluation==============
t = (0:length(eeg_segment)-1)/fs;

figure;

subplot(2,1,1)
plot(t, eeg_segment)
title('Original EEG Signal (Time-Domain Zoom)')
xlabel('Time (seconds)')
ylabel('\muV')
grid on

subplot(2,1,2)
plot(t, eeg_butter)
title('EEG Signal IIR butterworth')
xlabel('Time (seconds)')
ylabel('\muV')
grid on

%saveas(gcf,"TD_of_IIR.jpg");

%% Filter coff

% Butterworth filter coefficients
[b_butter, a_butter] = tf(filt1);

disp('Butterworth IIR Filter Coefficients:');
disp('b (numerator):'); disp(b_butter);
disp('a (denominator):'); disp(a_butter);

% Elliptic filter coefficients
[b_ellip, a_ellip] = tf(filt2);

disp('Elliptic IIR Filter Coefficients:');
disp('b (numerator):'); disp(b_ellip);
disp('a (denominator):'); disp(a_ellip);

% FIR equiripple coefficients
b_fir = tf(filt3);   % FIR has no denominator

disp('FIR Equiripple Filter Coefficients:');
disp('b:'); disp(b_fir);

% FIR LS coefficients
b_ls = tf(filt4);

disp('FIR Least-Squares Filter Coefficients:');
disp('b:'); disp(b_ls);

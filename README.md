# EEG Noise Removal Using Digital Filters

Digital Signal Processing project focused on removing 60 Hz power-line interference from EEG recordings using digital notch filters. Multiple FIR and IIR filter designs were implemented, analyzed, and compared using frequency-domain and time-frequency techniques.

## Overview

EEG signals are highly susceptible to power-line contamination, which appears as a narrowband interference at 60 Hz.

This project designs and evaluates several digital notch filters to suppress the interference while preserving the underlying EEG information.

Implemented filters:

- IIR Butterworth Notch Filter
- IIR Elliptic Notch Filter
- FIR Equiripple Notch Filter
- FIR Least-Squares Notch Filter

The final filter selection was based on:

- Stopband attenuation
- Passband distortion
- Phase linearity
- Computational efficiency

---

## Problem Specifications

| Parameter | Value |
|------------|--------|
| Signal Type | EEG |
| Sampling Frequency | 256 Hz |
| Interference Frequency | 60 Hz |
| Stopband | 59–61 Hz |
| Passband Ripple | 0.5 dB |
| Minimum Attenuation | 40 dB |

---

## Methodology

### 1. Filter Design

Designed and compared:

#### IIR Filters

- Butterworth Notch Filter
- Elliptic Notch Filter

#### FIR Filters

- Equiripple Notch Filter
- Least-Squares Notch Filter

---

### 2. Filter Evaluation

Performance was evaluated using:

- Magnitude response
- Stopband attenuation
- Passband ripple
- Phase characteristics
- Filter order
- Computational complexity

---

### 3. Frequency Analysis

Implemented:

- Welch Power Spectral Density (PSD)
- Short-Time Fourier Transform (STFT)
- Spectrogram Analysis

---

### 4. Validation

Compared:

- Original EEG signal
- Filtered EEG signal
- Frequency spectra
- Spectrograms
- Time-domain waveforms

---

## Results

### Key Findings

- All filters successfully removed the 60 Hz interference.
- Butterworth achieved the best overall trade-off between attenuation and computational efficiency.
- FIR filters provided linear phase behavior but required significantly higher filter orders.
- EEG waveform morphology remained largely preserved after filtering.

### Final Selected Filter

✅ 4th-order IIR Butterworth Notch Filter

Reasons:

- Strong 60 Hz suppression
- Low passband distortion
- Low computational cost
- Stable implementation

---

## Analysis Techniques

### Welch PSD

Used to verify attenuation of the 60 Hz spectral peak.

### STFT Spectrograms

Visualized frequency content before and after filtering.

### Window Analysis

Compared:

- Hamming Window
- Rectangular Window

for different window lengths to study time-frequency resolution tradeoffs.

---



---

## Technologies Used

- MATLAB
- Digital Signal Processing
- EEG Signal Processing
- FIR Filters
- IIR Filters
- Welch PSD
- STFT
- Spectrogram Analysis

---

## Authors

Abdelhady Mohamed  

## Course

CIE 442 – Digital Signal Processing

University of Science and Technology at Zewail City

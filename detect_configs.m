function par = detect_config(id)

% BW_min & SF_min: the minimum BW and SF under a specific slope, used to
%     generate downchirp with short window
% Threshold: the detection threshold after dechirp-FFT
% MaxPeakNum: maximum number of peaks after threshold decision
% SymbolNum: maximum number of symbols in payload

    LORA_SF = 9;
    LORA_BW = 125e3;
    Fs = 2e6;
    num_preamble = 5;
    num_sync = 2;
    num_DC = 2.25;

    BW_min = 125e3;
    SF_min = 8; 
    
    peak_tor = 2;
    Detect_th = 100;
    MaxPeakNum = 20;
    SymbolNum = 200;

    bin_gap_list = [];

    max_height_thresold = 0.9;
    detect_rate = 8;

    % detect fft variables
    zero_padding = 1;

    switch(id)
        case 1,
            par = LORA_SF;
        case 2,
            par = LORA_BW;
        case 3,
            par = Fs;
        case 4,
            par = num_preamble;
        case 5,
            par = num_sync;
        case 6,
            par = num_DC;
        case 7,
            par = Detect_th;
        case 8,
            par = MaxPeakNum;
        case 9,
            par = peak_tor;
        case 10,
            par = max_height_thresold;
        case 11,
            par = zero_padding;
        case 12,
            par = detect_rate;
        otherwise,
    end

end
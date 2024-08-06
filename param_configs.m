function par = param_configs(id)

    % LoRa PHY transmitting parameters
    LORA_SF = 9;%12;            % LoRa spreading factor
    LORA_BW = 125e3;%125e3;        % LoRa bandwidth
    
    % Receiving device parameters
    Fs = 2e6;%125e3*8;  % recerver's sampling rate 
    num_preamble = 8;       % num of Preamble Base Upchirps in a Lora Pkt
    num_sync = 2;
    num_DC = 2.25;
    num_data_sym = 120;
    
    DC_corr_threshold = 0.2;        % Value to be calibrated based on Correlation plot's noise floor
    DC_corr_pnts_threshold = 40;
    
    UC_corr_threshold = 0.1;        % Value to be calibrated based on Correlation plot's noise floor
    UC_corr_pnts_threshold = 40;
    SYNC1 = 8;
    SYNC2 = 16;
    
    path = '../../sig/IoTJ_exp/';            % Add path to the file
    fil_nm = 'P1_FC9168_SF9_BW125_CR4.cfile';                    % File name
    
    sample_num_per_symbol = Fs / LORA_BW * 2 ^ LORA_SF;
    win_step = sample_num_per_symbol/16;
    
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
            par = num_data_sym;
        case 8,
            par = win_step;
        case 9,
            par = sample_num_per_symbol;
        case 10,
            par = DC_corr_threshold;
        case 11,
            par = DC_corr_pnts_threshold;
        case 12,
            par = UC_corr_threshold;
        case 13,
            par = UC_corr_pnts_threshold;
        case 14,
            par = SYNC1;
        case 15,
            par = SYNC2;
        case 16,
            par = path;
        case 17,
            par = fil_nm;

        otherwise,
    end
end
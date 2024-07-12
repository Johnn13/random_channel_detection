classdef cpacket < handle
    properties

        % lora params
        SF;       
        BW;

        % packet params
        central_Freq;
        preamble_symbols;
        downchirp_symbols;
        payload_symbols;

        % 窗口偏移量以采样点为单位,中心频率偏移量以MHz为单位
        win_offset;
        fc_offset;
    end
    
    methods
        % 构造函数
        function obj = cpacket(x1,x2)
            switch nargin
                case 1 
                    obj.preamble_symbols = x1;

                case 2
                    obj.BW = x1;
                    obj.SF = x2;
                otherwise
                    error("Invalid initialize!");
            end
        end

        function init(obj)
            % 通过收集到的preamble symbols 初始化 SF/BW/CF
            
            % 步骤1:先根据获取到的峰值高度规律来求出 bw 和 SF
            % 原则:
            %   SF8的peak height达到最高有13个;
            %   SF10的peak height达到最高有9个;
            %   SF12的peak height达到最高有1个.
            max_height_thresold = detect_configs(10);
            ref_symbol = obj.preamble_symbols(end);
            ref_pk_height_trking = ref_symbol.pk_height_trking;
            [max_height, ~] = max(ref_pk_height_trking);
            % 求出ref_pk_height_trking中那些值与最大值差不多大的个数
            max_height_index = ref_pk_height_trking > max_height*max_height_thresold;
            max_height_number = sum(max_height_index);
            switch max_height_number
                case 13
                    obj.SF = detect_configs(1) - 4;
                    obj.BW = detect_configs(2)/4;
                
                case 9
                    obj.SF = detect_configs(1) - 4;
                    obj.BW = detect_configs(2)/4;
                    
                case {1,2,3}
                    obj.SF = detect_configs(1); 
                    obj.BW = detect_configs(2);
                otherwise
                    warning(" illegimate max_height_number");
            end
            % 根据最大值的peak index来计算中心频率、窗口偏移量、CFO等
            % 由于这三者无法解耦，只能通过upchirp和downchirp的结合才能算出
            tmp_pk_idx_trking = ref_symbol.pk_idx_trking(max_height_index);

            
        end

        function show(obj)
            fprintf('\n[DEBUG] Symbol info show\n');
            %展示bw和sf
            fprintf('\tSF is %d\t',obj.SF);
            fprintf('\tBW is %d\n',obj.BW);

            % 展示preamble_symbol的长度
            if isempty(obj.preamble_symbols)
                fprintf('\tpreamble_symbols is empty\n');
            else
                fprintf('\tpreamble_symbols length is %d\n',length(obj.preamble_symbols));
            end

            % downchirp_symbols
            if isempty(obj.downchirp_symbols)
                fprintf('\tdownchirp_symbols is empty\n');
            else
                fprintf('\tdownchirp_symbols length is %d\n',length(obj.downchirp_symbols));
            end

            fprintf('\twindow offset is %d\t',obj.win_offset);
            fprintf('\tcentral frequency offset is %d\n',obj.fc_offset);
        end     

    end
end
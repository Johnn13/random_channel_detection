classdef csymbol < handle
    % 该类用于保存一个symbol的峰值index和高度信息

    properties
        pk_idx_trking;
        pk_height_trking;
        pkt_id;
    end
    % 在该类提供修改 pk_idx_trking 和 pk_height_trking 的方法
    methods
        function obj = csymbol(pk_idx_trking, pk_height_trking)
            obj.pk_idx_trking = pk_idx_trking;
            obj.pk_height_trking = pk_height_trking;
        end

        function belong(obj, id)
            obj.pkt_id = id;
        end
        
        % 展示峰值信息,用于debug
        function show(obj)
            fprintf('\n[DEBUG] Symbol info show\n');
            fprintf('[peak] index tracking: ');
            for i = 1:length(obj.pk_idx_trking)
                fprintf('%6.2f--> ',obj.pk_idx_trking(i));
            end
            fprintf('\n[peak] height tracking: ');
            for i = 1:length(obj.pk_height_trking)
                fprintf('%6.2f--> ',obj.pk_height_trking(i));
            end
            fprintf('\n');
        end
    end
    
end
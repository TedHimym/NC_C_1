
classdef NProData < handle
    %����Բ����Ȼ����ģ�͵����ݷ���
    %   ��¼�����ļ������λ�á�ʱ�䲽���������ļ�������
    %   ���Խ��л�ͼ�����Ȳ���
    
    properties
        TotolTime;                  %��ʱ��
        Path = './';                %�ļ�·��
        NamePro = 'fluentTS-';      %�ļ�ǰ׺
        DataFileList;               %�����ļ����б�Ϊcell�б�
        TimeList;                   %�����ļ���Ӧʱ�䣬Ϊ����
        FileNumber = 0;             %�����ļ��ĸ�������GetDataFileNumber()������ʼ��
        time;
        Tx = 0.99;
        dataV;
    end
    
    methods
        %�����õ��������ļ��ĸ���
        function num = GetDataFileNumber(obj)
            fileList = dir(obj.Path); num = 0;
            for fileCell = {fileList.name}
                filename = fileCell{1};
                if(strcmp(filename(1:min(size(obj.NamePro,2),length(filename))), obj.NamePro))
                    num = num + 1;
                end
            end
        end
        %ͨ��ָ����ʱ������Ӧ�������ļ�����ȡ��Data
        function Data = GetData(obj, time)
            if obj.time == time
                Data = obj.dataV;
            else
                obj.time = time;
                TimeR = max(obj.TimeList((obj.time - obj.TimeList)>=0));
                TimeL = min(obj.TimeList((obj.time - obj.TimeList) <0));
                if (~size(TimeL, 1))
                    File = importdata([obj.Path obj.DataFileList{obj.TimeList==TimeR}]);
                    obj.dataV = File.data;
                    Data = obj.dataV;
                else
                    weightR = (obj.time - TimeL) / (TimeR - TimeL);
                    weightL = (TimeR - obj.time) / (TimeR - TimeL);
                    FileR = importdata([obj.Path obj.DataFileList{obj.TimeList==TimeR}]);
                    FileL = importdata([obj.Path obj.DataFileList{obj.TimeList==TimeL}]);
                    obj.dataV = weightL * FileL.data + weightR * FileR.data;
                    Data = obj.dataV;
                end
            end
        end
        %ͨ��ָ��ʱ��ָ���߶���뾶�õ��ٶ����¶ȵ�����
        function varargout = GetData_Pos(obj, h, r, time, type)
            if (isequal('av', type))
                index = 4;
            elseif (isequal('rv', type))
                index = 5;
            elseif (isequal('T', type))
                index = 6;
            else
                exit()
            end
            data = obj.GetData(time);
            if (isa(r, 'char') && isa(h, 'double'))
                r = unique(data(:,3));
                r = r(2:end);
            elseif (isa(r, 'double') && isa(h, 'char'))
                h = unique(data(:,2));
            elseif (isa(r, 'double') && isa(h, 'double'))
                
            elseif (isa(r, 'char') && isa(h, 'char'))
                r = unique(data(:,3));
                r = r(2:end);
                h = unique(data(:,2))';
            end
            [H, R, D] = griddata(data(:,2), data(:,3), data(:,index), h, r, 'linear');
            if (nargout == 1)
                varargout{1} = [H R D];
            elseif (nargout == 2)
                varargout{1} = R;
                varargout{2} = D;
            elseif (nargout == 3)
                varargout{1} = H;
                varargout{2} = R;
                varargout{3} = D;
            end
        end
        %ͨ��ָ���߽���Ⱥ͸߶���ʱ��õ��¶ȺͶ�Ӧ�İ뾶
        function [R, F] = T_r(obj, h, delta, time)
            [~, R, T] = obj.GetData_Pos(h, 'r', time, 'T');
            indexR = (R==min(R(R>delta+R(1))));
            indexL = (R==max(R(R<delta+R(1))));
            ER = delta+R(1);
            ET = interp1([R(indexL) R(indexR)], [T(indexL) T(indexR)], ER, 'linear');
            F = ([T(R<ER); ET]);
            R = [R(R<ER); ER];
        end
        %ͨ��ָ���߽���Ⱥ͸߶���ʱ��õ��ٶȺͶ�Ӧ�İ뾶
        function [InteR, Intef] = U_r(obj, h, delta, time)
            [~, R, T] = obj.GetData_Pos(h, 'r', time, 'av');
            indexR = (R==min(R(R>delta+R(1))));
            indexL = (R==max(R(R<delta+R(1))));
            ER = delta+R(1);
            ET = interp1([R(indexL) R(indexR)], [T(indexL) T(indexR)], ER, 'linear');
            Intef = ([T(R<ER); ET]);
            InteR = [R(R<ER); ER];
        end
        %ͨ��ָ���߽���Ⱥ͸߶���ʱ��õ���һ�����¶ȺͶ�Ӧ�İ뾶
        function [InteR, Intef] = f_NumericalData(obj, h, delta, time)
            [~, R, T] = obj.GetData_Pos(h, 'r', time, 'T');
            indexR = (R==min(R(R>delta+R(1))));
            indexL = (R==max(R(R<delta+R(1))));
            ER = delta+R(1);
            ET = interp1([R(indexL) R(indexR)], [T(indexL) T(indexR)], ER, 'linear');
            Intef = (max(T)-[T(R<ER); ET])/(max(T)-min(T));
            InteR = [R(R<ER); ER];
        end
        %ͨ��ָ���߽���Ⱥ͸߶���ʱ��õ���һ�����ٶȺͶ�Ӧ�İ뾶
        function [InteR, Integ] = g_NumericalData(obj, h, delta, time)
            [~, R, U] = obj.GetData_Pos(h, 'r', time, 'av');
            indexR = (R==min(R(R>delta+R(1))));
            indexL = (R==max(R(R<delta+R(1))));
            ER = delta+R(1);
            InteR = [R(R<ER); ER];
            EU = interp1([R(indexL) R(indexR)], [U(indexL) U(indexR)], ER, 'linear');
            Integ = [U(R<ER); EU] / obj.getmU(h,time);
        end
        %����ָ���߶��ϵı߽�����ڹ�һ�����¶�ͼ��
        function Tf(obj, h, delta, time)
            [InteR, Intef] = f_NumericalData(obj, h, delta, time);
            plot((InteR-InteR(1))/delta, Intef)
            hold on
%             pause
        end
        %����ָ���߶��ϵı߽�����ڹ�һ�����ٶ�ͼ��
        function Ug(obj, h, delta, time)
            [InteR, Intef] = g_NumericalData(obj, h, delta, time);
            plot((InteR-InteR(1))/delta, Intef)
            hold on
%             pause
        end        
        %��R����ĵ���
        function [dv] = dv_R(obj, type, h, time)
            [~, R, V] = obj.GetData_Pos(h, 'r', time, type);
            if (isequal('T', type))
                V = (max(V)-V)./(max(V)-min(V));
            elseif (isequal('av', type))
                V = -V ./ obj.getmU(h,time);
            end
            dv = zeros(1, size(R, 2));
            for index = 1:size(R, 2)
                dV = gradient(V(:,index), R(:,index));
                dv(index) = interp1(R(:,index), dV, R(1,index), 'spline');
            end
        end
        %�¶ȱ߽����
        function varargout = TBL_TR(obj, h, time)
            ER = zeros(1, length(h));
            TT = zeros(1, length(h));
            for index = 1:length(h)
                [~, R, T] = obj.GetData_Pos(h(index), 'r', time, 'T');
                ER(index) = min(T) + (max(T)-min(T))*obj.Tx;
                indexR=(T==min(T(T>ER(index))));
                indexL=(T==max(T(T<ER(index))));
                ER(index) = interp1([T(indexL) T(indexR)], [R(indexL) R(indexR)], ER(index), 'linear');
                TT(index) = ER(index) - min(R);
                if (nargout == 0)
                    varargout{1} = [TT, ER];
                elseif (nargout == 1)
                    varargout{1} = TT;
                elseif (nargout == 2)
                    varargout{1} = TT;
                    varargout{2} = ER;
                end
            end
        end
        %�ٶȱ߽����
        function [VT, ER] = VBL_TR(obj, h, time)
            ER = zeros(1, length(h));
            VT = zeros(1, length(h));
            for index = 1:length(h)
                [~, R, V] = obj.GetData_Pos(h(index), 'r', time, 'av');
                V = V(R>R(V==min(V)));
                R = R(R>R(V==min(V)));
                ER(index) = min(V) * 0.01;
                indexR=(V==min(V(V>ER(index))));
                indexL=(V==max(V(V<ER(index))));
                ER(index) = interp1([V(indexL) V(indexR)], [R(indexL) R(indexR)], ER(index), 'linear');
                VT(index) = ER(index) - min(R);
            end
        end
        %�õ������ٶ�
        function [mU, r] = getmU(obj,h,time)
            [~,R,U] = obj.GetData_Pos(h, 'r', time, 'av');
            mU = max(abs(U));
            r = R(abs(U)==mU);
        end
        %�����ϵĳ��ֲ�
        function Surface(obj, time, type)
            if (isequal('T', type))
                index = 6;
            elseif (isequal('av', type))
                index = 4;
            elseif (isequal('rv', type))
                index = 5;
            end
            data = obj.GetData(time);
            r = unique(data(:,3));
            h = unique(data(:,2));
            [X, Y, Z] = griddata(data(:,2), data(:,3), data(:,index), h', r, 'linear');
            figure
            surf(X, Y, Z)
        end
        
        function [InteV] = Integrate_fr(obj, h, delta,time)
            [InteR, Intef] = f_NumericalData(obj, h, delta, time);
            InteV = trapz(InteR, Intef.*InteR);
        end
        function [InteV] = Integrate_gfr(obj, h, delta,time)
            [~    , Intef] = f_NumericalData(obj, h, delta, time);
            [InteR, Integ] = g_NumericalData(obj, h, delta, time);
            InteV = trapz(InteR, abs(Integ).*Intef.*InteR);
        end
        function [InteV] = Integrate_ggr(obj, h, delta,time)
            [InteR, Integ] = g_NumericalData(obj, h, delta, time);
            InteV = trapz(InteR, Integ.^2.*InteR);
        end
        function [InteV] = Integrate_F(obj, h, delta, time)
            [InteR, Intef] = f_NumericalData(obj, h, delta, time);
            InteV = trapz(InteR-InteR(1), Intef);
        end
        function [InteV] = Integrate_fF(obj, h, delta, time)
            [InteR, Intef] = f_NumericalData(obj, h, delta, time);
            t = (InteR-InteR(1))/delta;
            InteV = trapz(t, Intef);
        end
        function [InteV] = Integrate_Fy(obj, h, delta, time)
            [InteR, Intef] = f_NumericalData(obj, h, delta, time);
            InteV = trapz(InteR-InteR(1), Intef.*(InteR-InteR(1)));
        end
        function [InteV] = Integrate_fFt(obj, h, delta, time)
            [InteR, Intef] = f_NumericalData(obj, h, delta, time);
            t = (InteR-InteR(1))/delta;
            InteV = trapz(t, Intef.*t);
        end
        function [InteV] = Integrate_GF(obj, h, delta,time)
            [~    , Intef] = f_NumericalData(obj, h, delta, time);
            [InteR, Integ] = g_NumericalData(obj, h, delta, time);
            InteV = trapz(InteR-InteR(1), abs(Integ).*Intef);
        end
        function [InteV] = Integrate_gGfF(obj, h, delta,time)
            [~    , Intef] = f_NumericalData(obj, h, delta, time);
            [InteR, Integ] = g_NumericalData(obj, h, delta, time);
            t = (InteR-InteR(1))/delta;
            InteV = trapz(t, abs(Integ).*Intef);
        end
        function [InteV] = Integrate_GFy(obj, h, delta,time)
            [~    , Intef] = f_NumericalData(obj, h, delta, time);
            [InteR, Integ] = g_NumericalData(obj, h, delta, time);
            InteV = trapz(InteR-InteR(1), abs(Integ).*Intef.*(InteR-InteR(1)));
        end
        function [InteV] = Integrate_gGfFt(obj, h, delta,time)
            [~    , Intef] = f_NumericalData(obj, h, delta, time);
            [InteR, Integ] = g_NumericalData(obj, h, delta, time);
            t = (InteR-InteR(1))/delta;
            InteV = trapz(t, abs(Integ).*Intef.*t);
        end
        function [InteV] = Integrate_GG(obj, h, delta,time)
            [InteR, Integ] = g_NumericalData(obj, h, delta, time);
            InteV = trapz(InteR-InteR(1), Integ.^2);
        end
        function [InteV] = Integrate_GGy(obj, h, delta,time)
            [InteR, Integ] = g_NumericalData(obj, h, delta, time);
            InteV = trapz(InteR-InteR(1), Integ.^2.*(InteR-InteR(1)));
        end
        
        %��ʼ���ຯ��
        function obj = NProData(Path, NamePro, varargin)
            if (nargin == 3)
                obj.time = varargin{1};
            end
            obj.time = 0;
            obj.dataV = 0;
            obj.Path = Path;
            obj.NamePro = NamePro;
            obj.FileNumber = obj.GetDataFileNumber();
            obj.DataFileList = cell(obj.FileNumber,1);
            obj.TimeList = zeros(obj.FileNumber,1);
            index = 1;
            filelist = dir(obj.Path);
            for fileCell = {filelist.name}
                filename = fileCell{1};
                if(strcmp(filename(1:min(size(NamePro,2),length(filename))), NamePro))
                    obj.TimeList(index) = str2double(filename(size(NamePro,2)+1:end));
                    obj.DataFileList{index} = filename;
                    index = index+1;
                end
            end
            obj.TotolTime = max(obj.TimeList);
        end
    end
    
    methods(Static)
% 
    end
end


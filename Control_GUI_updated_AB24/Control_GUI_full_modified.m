%%%%% DO NOT CHANGE THE CODE
% modified by Anne Bettens 16 Oct 2024

function varargout = Control_GUI_full(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Control_GUI_full_OpeningFcn, ...
    'gui_OutputFcn',  @Control_GUI_full_OutputFcn, ...
    'gui_LayoutFcn',  @Control_GUI_full_LayoutFcn, ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Control_GUI_full is made visible.
function Control_GUI_full_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Control_GUI_full (see VARARGIN)
if ~isempty(timerfindall)
    stop(timerfindall)
end
% Choose default command line output for Control_GUI_full
handles.output = hObject;
handles.U = [0 0;1 0; 10 0];

handles.plot(1)=plot(handles.U(:,1), handles.U(:,2), 'r--o');
hold on
handles.plot(2)=plot(handles.U(:,1), handles.U(:,2), 'b--o');
handles.plot(3)=plot(handles.U(:,1), handles.U(:,2), 'm--o');
handles.plot(4)=plot(handles.U(:,1), handles.U(:,2), 'k--o');
handles.plot(5)=plot(handles.U(:,1), handles.U(:,2), '--o', 'Color', [1 0.694 0.392]);

set(handles.plot(2), 'Visible', 'off')
set(handles.plot(3), 'Visible', 'off')
set(handles.plot(4), 'Visible', 'off')
set(handles.plot(5), 'Visible', 'off')

xlabel('Time')
ylabel('\deltaU')
grid on

handles.select = plot(-2000, -2000, 'go');
handles.ax = gca;
set(handles.ax, 'Xlim', [0 10]);
set(handles.ax, 'Ylim', [-25 25]);
handles.Ymin = -25;
handles.Ymax = 25;
handles.Xmin = 0;
handles.Xmax = 10;
handles.SimTime = 10;
handles.U0(1) = 0;
handles.U0(2) = 0;
handles.U0(3) = 0;
handles.U0(4) = 0;
handles.U0(5) = 0;
handles.Ufinal(1) = 0;
handles.Ufinal(2) = 0;
handles.Ufinal(3) = 0;
handles.Ufinal(4) = 0;
handles.Ufinal(5) = 0;
handles.control_index = 1;
handles.Add = 0;
handles.Delete = 0;
handles.Btndown = 0;
handles.select_flag = 0;
handles.Curr_x = 0;
handles.Curr_y = 0;
handles.Curr_index = 0;
handles.move_flag= 0;
handles.TimeStep = 0.01;
handles.freq(1) = 10;
handles.freq(2) = 10;
handles.freq(3) = 10;
handles.freq(4) = 10;
handles.freq(5) = 10;
handles.control_check = 1;
handles.control_check_dt = 1;
handles.control_check_de = [];
handles.control_check_da = [];
handles.control_check_dr = [];
handles.control_check_df = [];
handles.spline(1) = plot(handles.U(:,1), handles.U(:,2), 'r', 'Linewidth', 2);
handles.spline(2) = plot(handles.U(:,1), handles.U(:,2), 'b', 'Linewidth', 2);
handles.spline(3) = plot(handles.U(:,1), handles.U(:,2), 'm', 'Linewidth', 2);
handles.spline(4) = plot(handles.U(:,1), handles.U(:,2), 'k', 'Linewidth', 2);
handles.spline(5) = plot(handles.U(:,1), handles.U(:,2), 'Color', [1 0.694 0.392] , 'Linewidth', 2);
set(handles.spline(2), 'Visible', 'off')
set(handles.spline(3), 'Visible', 'off')
set(handles.spline(4), 'Visible', 'off')
set(handles.spline(5), 'Visible', 'off')
set(handles.Curr_y_txt, 'Enable', 'off')
set(handles.Curr_x_txt, 'Enable', 'off')

handles.RecTimer = timer(...
    'TimerFcn',{@RecTimerFun,handles},...
    'BusyMode', 'drop',...
    'StartDelay',20,...
    'ExecutionMode','fixedSpacing',...
    'Period', 1);

start(handles.RecTimer)

%========== Due Date ===============
% Also need to change date in timer function
T1 = [2024 11 01 23 00 0];
T0 = clock;
nsecrem = etime(T1, T0);

ndays = floor(nsecrem/86400);
nhours = floor((nsecrem-ndays*86400)/3600);
nmins = floor((nsecrem -ndays*86400 - 3600*nhours)/60);
nsecs = floor(nsecrem -ndays*86400 - 3600*nhours - 60*nmins);
set(handles.days_txt,'String',num2str(ndays))
set(handles.hours_txt,'String',num2str(nhours))
set(handles.minutes_txt','String',num2str(nmins))

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Control_GUI_full wait for user response (see UIRESUME)
% uiwait(handles.Control_GUI_full);



function varargout = Control_GUI_full_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;



function Ymax_txt_Callback(hObject, eventdata, handles)
temp = str2double(get(hObject,'String'));
if isnan(temp)
    temp = handles.Ymax;
end
handles.Ymax = temp;
if handles.Ymax <= handles.Ymin
    handles.Ymax = handles.Ymin+0.005;
end
set(handles.Ymax_txt, 'String', num2str(handles.Ymax))
set(handles.ax, 'Ylim', [handles.Ymin handles.Ymax]);
guidata(hObject, handles);

function Ymin_txt_Callback(hObject, eventdata, handles)
temp = str2double(get(hObject,'String'));
if isnan(temp)
    temp = handles.Ymin;
end
handles.Ymin = temp;
if handles.Ymin >= handles.Ymax
    handles.Ymin = handles.Ymax-0.005;
end
set(handles.Ymin_txt, 'String', num2str(handles.Ymin))
set(handles.ax, 'Ylim', [handles.Ymin handles.Ymax]);
guidata(hObject, handles);

function Xmin_txt_Callback(hObject, eventdata, handles)
temp = str2double(get(hObject,'String'));
if isnan(temp)
    temp = handles.Xmin;
end
handles.Xmin = temp;
if handles.Xmin >= handles.Xmax
    handles.Xmin = handles.Xmax-0.005;
end
if handles.Xmin < 0
    handles.Xmin = 0;
end
set(handles.Xmin_txt, 'String', num2str(handles.Xmin))
set(handles.ax, 'Xlim', [handles.Xmin handles.Xmax]);
guidata(hObject, handles);

function Xmax_txt_Callback(hObject, eventdata, handles)
temp = str2double(get(hObject,'String'));
if isnan(temp)
    temp = handles.Xmax;
end
handles.Xmax = temp;
if handles.Xmax <= handles.Xmin
    handles.Xmax = handles.Xmin+0.005;
end
if handles.Xmax > handles.SimTime
    handles.Xmax = handles.SimTime;
end
set(handles.ax, 'Xlim', [handles.Xmin handles.Xmax]);
set(handles.Xmax_txt, 'String', num2str(handles.Xmax))
guidata(hObject, handles);

function SimTime_txt_Callback(hObject, eventdata, handles)
Old_SimTime = handles.SimTime;
temp = str2double(get(hObject,'String'));
if isnan(temp)
    temp = handles.SimTime;
end
handles.SimTime = temp;
set(handles.SimTime_txt, 'String', num2str(handles.SimTime))
if handles.SimTime <= 1
    handles.SimTime = 1.005;
    set(handles.SimTime_txt, 'String', num2str(handles.SimTime))
end
if handles.SimTime < Old_SimTime
    for i = 1:5
    X = get(handles.plot(i), 'Xdata');
    Y = get(handles.plot(i), 'Ydata');
    Y(X>=handles.SimTime) = [];
    X(X>=handles.SimTime) = [];
    
    X(end+1) = handles.SimTime;
    Y(end+1) = handles.Ufinal(i);
    set(handles.plot(i), 'Xdata', X);
    set(handles.plot(i), 'Ydata', Y);
    end
elseif handles.SimTime > Old_SimTime
    for i = 1:5
    X = get(handles.plot(i), 'Xdata');
    Y = get(handles.plot(i), 'Ydata');
    X(end) = handles.SimTime;
    Y(end) = handles.Ufinal(i);
    set(handles.plot(i), 'Xdata', X);
    set(handles.plot(i), 'Ydata', Y);
    end
end

    handles.Xmax = handles.SimTime;
    set(handles.ax, 'Xlim', [handles.Xmin handles.Xmax]);
    set(handles.Xmax_txt, 'String', num2str(handles.Xmax));
temp = handles.control_index;
for i = 1:5
    handles.control_index = i;
handles = DrawSpline(handles);
end
handles.control_index = temp;
handles.select_flag = 0;
        handles.Curr_index = 0;
        handles.Curr_x = 0;
        handles.Curr_y = 0;
        set(handles.select, 'Xdata', -2000)
        set(handles.select, 'Ydata', -2000)
        set(handles.Curr_x_txt, 'Enable', 'off')
        set(handles.Curr_y_txt, 'Enable', 'off')
guidata(hObject, handles);

function U0_txt_Callback(hObject, eventdata, handles)
temp = str2double(get(hObject,'String'));
if isnan(temp)
    temp = handles.U0(handles.control_index);
end
handles.U0(handles.control_index) = temp;
set(handles.U0_txt, 'String', num2str(handles.U0(handles.control_index)))
Y = get(handles.plot(handles.control_index), 'Ydata');
Y(1:2) = handles.U0(handles.control_index);
set(handles.plot(handles.control_index), 'Ydata', Y);
handles = DrawSpline(handles);
guidata(hObject, handles);

function Ufinal_txt_Callback(hObject, eventdata, handles)
temp = str2double(get(hObject,'String'));
if isnan(temp)
    temp = handles.Ufinal(handles.control_index);
end
handles.Ufinal(handles.control_index) = temp;
set(handles.Ufinal_txt, 'String', num2str(handles.Ufinal(handles.control_index)))
Y = get(handles.plot(handles.control_index), 'Ydata');
Y(end) = handles.Ufinal(handles.control_index);
set(handles.plot(handles.control_index), 'Ydata', Y);
handles = DrawSpline(handles);
guidata(hObject, handles);

function Curr_x_txt_Callback(hObject, eventdata, handles)
if handles.select_flag == 1;
    temp = str2double(get(hObject,'String'));
    if isnan(temp)
    temp =  handles.Curr_x;
    end
    handles.Curr_x = temp;
    
    X = get(handles.plot(handles.control_index), 'Xdata');
    if handles.Curr_x <= X(handles.Curr_index-1)
        handles.Curr_x = X(handles.Curr_index-1)+0.005;
    elseif handles.Curr_x >= X(handles.Curr_index+1)
        handles.Curr_x = X(handles.Curr_index+1)-0.005;
    end
    set(handles.Curr_x_txt, 'String', num2str(handles.Curr_x))
    X(handles.Curr_index) = handles.Curr_x;
    set(handles.plot(handles.control_index), 'Xdata', X);
    set(handles.select, 'Xdata', handles.Curr_x)
end

handles = DrawSpline(handles);
guidata(hObject, handles);




function Curr_y_txt_Callback(hObject, eventdata, handles)
if handles.select_flag == 1;
    temp = str2double(get(hObject,'String'));
    if isnan(temp)
    temp =  handles.Curr_y;
    end
    handles.Curr_y = temp;
    
    Y = get(handles.plot(handles.control_index), 'Ydata');
    set(handles.Curr_y_txt, 'String', num2str(handles.Curr_y))
    Y(handles.Curr_index) = handles.Curr_y;
    set(handles.plot(handles.control_index), 'Ydata', Y);
    set(handles.select, 'Ydata', handles.Curr_y)
end
handles = DrawSpline(handles);
guidata(hObject, handles);


function Add_btn_Callback(hObject, eventdata, handles)
% if handles.Add == 0
    handles.Add = get(hObject, 'Value');
% end
if handles.Add == 1
    set(handles.Add_btn, 'BackgroundColor', [0 1 0])
    set(handles.Add_btn, 'Value', 1)
    handles.Delete = 0;
    set(handles.Delete_btn, 'BackgroundColor', [240 240 240]/255)
    set(handles.Delete_btn, 'Value', 0)
else
    set(handles.Add_btn, 'BackgroundColor', [240 240 240]/255)
end
guidata(hObject, handles);

function Delete_btn_Callback(hObject, eventdata, handles)
% if handles.Delete == 0
    handles.Delete = get(hObject, 'Value');
% end
if handles.Delete == 1
    set(handles.Delete_btn, 'BackgroundColor', [1 0 0])
    set(handles.Delete_btn, 'Value', 1)
    handles.Add = 0;
    set(handles.Add_btn, 'BackgroundColor', [240 240 240]/255)
    set(handles.Add_btn, 'Value', 0)
else
    set(handles.Delete_btn, 'BackgroundColor', [240 240 240]/255)
end
guidata(hObject, handles);


function Control_GUI_WindowButtonDownFcn(hObject, eventdata, handles)
handles.Btndown = 1;

if handles.Add == 0 && handles.Delete == 0
    P = get(handles.ax,'CurrentPoint');
    X_loc = P(1,1);
    Y_loc = P(1,2);
    if X_loc < handles.Xmin
        handles.select_flag = 0;
        handles.Curr_index = 0;
        handles.Curr_x = 0;
        handles.Curr_y = 0;
        set(handles.select, 'Xdata', -2000)
        set(handles.select, 'Ydata', -2000)
        set(handles.Curr_x_txt, 'Enable', 'off')
        set(handles.Curr_y_txt, 'Enable', 'off')
    elseif X_loc > handles.Xmax
        handles.select_flag = 0;
        handles.Curr_index = 0;
        handles.Curr_x = 0;
        handles.Curr_y = 0;
        set(handles.select, 'Xdata', -2000)
        set(handles.select, 'Ydata', -2000)
        set(handles.Curr_x_txt, 'Enable', 'off')
        set(handles.Curr_y_txt, 'Enable', 'off')
    elseif Y_loc < handles.Ymin
        handles.select_flag = 0;
        handles.Curr_index = 0;
        handles.Curr_x = 0;
        handles.Curr_y = 0;
        set(handles.select, 'Xdata', -2000)
        set(handles.select, 'Ydata', -2000)
        set(handles.Curr_x_txt, 'Enable', 'off')
        set(handles.Curr_y_txt, 'Enable', 'off')
    elseif Y_loc > handles.Ymax
        handles.select_flag = 0;
        handles.Curr_index = 0;
        handles.Curr_x = 0;
        handles.Curr_y = 0;
        set(handles.select, 'Xdata', -2000)
        set(handles.select, 'Ydata', -2000)
        set(handles.Curr_x_txt, 'Enable', 'off')
        set(handles.Curr_y_txt, 'Enable', 'off')
    else
        
        Threshold_X = (handles.Xmax - handles.Xmin)*0.02;
        Threshold_Y = (handles.Ymax - handles.Ymin)*0.04;
        X = get(handles.plot(handles.control_index), 'Xdata');
        Y = get(handles.plot(handles.control_index), 'Ydata');
        index = [];
        if length(X) > 3
            
            for i = 3 : (length(X)-1)
                Dist_x = X_loc - X(i);
                Dist_y = Y_loc - Y(i);
                if abs(Dist_x) < Threshold_X && abs(Dist_y) < Threshold_Y
                    index = [index i];
                end
                
            end
        end
        
        if ~isempty(index)
            if length(index)>1
                for i = 1:length(index)
                    Dist(i) = sqrt((X_loc - X(index(i)))^2+(Y_loc - Y(index(i)))^2);
                end
                index = index(Dist==min(Dist));
                
            end
            
            set(handles.select, 'Xdata', X(index));
            set(handles.select, 'Ydata', Y(index));
            handles.select_flag = 1;
            handles.Curr_index = index;
            handles.Curr_x = X(handles.Curr_index);
            handles.Curr_y = Y(handles.Curr_index);
            set(handles.Curr_y_txt, 'String', num2str(handles.Curr_y))
            set(handles.Curr_x_txt, 'String', num2str(handles.Curr_x))
            set(handles.Curr_y_txt, 'Enable', 'on')
            set(handles.Curr_x_txt, 'Enable', 'on')
        else
            handles.select_flag = 0;
            handles.Curr_index = 0;
            handles.Curr_x = 0;
            handles.Curr_y = 0;
            set(handles.select, 'Xdata', -2000)
            set(handles.select, 'Ydata', -2000)
            set(handles.Curr_x_txt, 'Enable', 'off')
            set(handles.Curr_y_txt, 'Enable', 'off')
        end
        
    end
end

if handles.Add == 1
    
    P = get(handles.ax,'CurrentPoint');
    X_loc = P(1,1);
    Y_loc = P(1,2);
    if X_loc < handles.Xmin
        
        handles.Add = 0;
        handles.Delete = 0;
        set(handles.Add_btn, 'BackgroundColor', [240 240 240]/255)
        set(handles.Add_btn, 'Value', 0)
        set(handles.Delete_btn, 'BackgroundColor', [240 240 240]/255)
        set(handles.Delete_btn, 'Value', 0)
        
    elseif X_loc > handles.Xmax
        handles.Add = 0;
        handles.Delete = 0;
        set(handles.Add_btn, 'BackgroundColor', [240 240 240]/255)
        set(handles.Add_btn, 'Value', 0)
        set(handles.Delete_btn, 'BackgroundColor', [240 240 240]/255)
        set(handles.Delete_btn, 'Value', 0)
    elseif Y_loc < handles.Ymin
        handles.Add = 0;
        handles.Delete = 0;
        set(handles.Add_btn, 'BackgroundColor', [240 240 240]/255)
        set(handles.Add_btn, 'Value', 0)
        set(handles.Delete_btn, 'BackgroundColor', [240 240 240]/255)
        set(handles.Delete_btn, 'Value', 0)
    elseif Y_loc > handles.Ymax
        handles.Add = 0;
        handles.Delete = 0;
        set(handles.Add_btn, 'BackgroundColor', [240 240 240]/255)
        set(handles.Add_btn, 'Value', 0)
        set(handles.Delete_btn, 'BackgroundColor', [240 240 240]/255)
        set(handles.Delete_btn, 'Value', 0)
    elseif X_loc < 1.005
        handles.Add = 0;
        handles.Delete = 0;
        set(handles.Add_btn, 'BackgroundColor', [240 240 240]/255)
        set(handles.Add_btn, 'Value', 0)
        set(handles.Delete_btn, 'BackgroundColor', [240 240 240]/255)
        set(handles.Delete_btn, 'Value', 0)
    else
%         handles.Add = 0;
%         set(handles.Add_btn, 'BackgroundColor', [240 240 240]/255)
%         set(handles.Add_btn, 'Value', 0)
        X = get(handles.plot(handles.control_index), 'Xdata');
        Y = get(handles.plot(handles.control_index), 'Ydata');
        
        if sum(X == X_loc)==0
            Y = [Y(X<X_loc) Y_loc Y(X>= X_loc)];
            X = [X(X<X_loc) X_loc X(X>= X_loc)];
            set(handles.plot(handles.control_index), 'Xdata', X);
            set(handles.plot(handles.control_index), 'Ydata', Y);
            
            set(handles.select, 'Xdata', X_loc);
            set(handles.select, 'Ydata', Y_loc);
            handles.select_flag = 1;
            index = 1:length(X);
            handles.Curr_index = index(X==X_loc);
            handles.Curr_x = X(handles.Curr_index);
            handles.Curr_y = Y(handles.Curr_index);
            set(handles.Curr_y_txt, 'String', num2str(handles.Curr_y))
            set(handles.Curr_x_txt, 'String', num2str(handles.Curr_x))
            set(handles.Curr_y_txt, 'Enable', 'on')
            set(handles.Curr_x_txt, 'Enable', 'on')
            
            handles = DrawSpline(handles);
        end
        
        
        
        
    end
end

if handles.Delete == 1;
    P = get(handles.ax,'CurrentPoint');
    X_loc = P(1,1);
    Y_loc = P(1,2);
    if X_loc < handles.Xmin
        handles.Add = 0;
        handles.Delete = 0;
        set(handles.Add_btn, 'BackgroundColor', [240 240 240]/255)
        set(handles.Add_btn, 'Value', 0)
        set(handles.Delete_btn, 'BackgroundColor', [240 240 240]/255)
        set(handles.Delete_btn, 'Value', 0)
    elseif X_loc > handles.Xmax
        handles.Add = 0;
        handles.Delete = 0;
        set(handles.Add_btn, 'BackgroundColor', [240 240 240]/255)
        set(handles.Add_btn, 'Value', 0)
        set(handles.Delete_btn, 'BackgroundColor', [240 240 240]/255)
        set(handles.Delete_btn, 'Value', 0)
    elseif Y_loc < handles.Ymin
        handles.Add = 0;
        handles.Delete = 0;
        set(handles.Add_btn, 'BackgroundColor', [240 240 240]/255)
        set(handles.Add_btn, 'Value', 0)
        set(handles.Delete_btn, 'BackgroundColor', [240 240 240]/255)
        set(handles.Delete_btn, 'Value', 0)
    elseif Y_loc > handles.Ymax
        handles.Add = 0;
        handles.Delete = 0;
        set(handles.Add_btn, 'BackgroundColor', [240 240 240]/255)
        set(handles.Add_btn, 'Value', 0)
        set(handles.Delete_btn, 'BackgroundColor', [240 240 240]/255)
        set(handles.Delete_btn, 'Value', 0)
    else
        
        Threshold_X = (handles.Xmax - handles.Xmin)*0.02;
        Threshold_Y = (handles.Ymax - handles.Ymin)*0.04;
        X = get(handles.plot(handles.control_index), 'Xdata');
        Y = get(handles.plot(handles.control_index), 'Ydata');
        index = [];
        if length(X) > 3
            
            for i = 3 : (length(X)-1)
                Dist_x = X_loc - X(i);
                Dist_y = Y_loc - Y(i);
                if abs(Dist_x) < Threshold_X && abs(Dist_y) < Threshold_Y
                    index = [index i];
                end
                
            end
        end
        
        if ~isempty(index)
            if length(index)>1
                for i = 1:length(index)
                    Dist(i) = sqrt((X_loc - X(index(i)))^2+(Y_loc - Y(index(i)))^2);
                end
                index = index(Dist==min(Dist));
                
            end
            X(index) = [];
            Y(index) = [];
            set(handles.plot(handles.control_index), 'Xdata', X);
            set(handles.plot(handles.control_index), 'Ydata', Y);
%             handles.Delete = 0;
%             set(handles.Delete_btn, 'BackgroundColor', [240 240 240]/255)
%             set(handles.Delete_btn, 'Value', 0)
            set(handles.select, 'Xdata', -2000);
            set(handles.select, 'Ydata', -2000);
            handles.select_flag = 0;
            handles.Curr_index = 0;
            set(handles.Curr_y_txt, 'Enable', 'off')
            set(handles.Curr_x_txt, 'Enable', 'off')
            
            handles = DrawSpline(handles);
        end
        
    end
end



guidata(hObject, handles);

function Control_GUI_WindowButtonMotionFcn(hObject, eventdata, handles)
if handles.Btndown == 1 && handles.select_flag == 1 && handles.Delete~=1 && handles.Add ~=1
    handles.move_flag = 1;
    P = get(handles.ax,'CurrentPoint');
    X_loc = P(1,1);
    Y_loc = P(1,2);
    
    X = get(handles.plot(handles.control_index), 'Xdata');
    Y = get(handles.plot(handles.control_index), 'Ydata');
    handles.Curr_x = X_loc;
    handles.Curr_y = Y_loc;
    
    if handles.Curr_x <= X(handles.Curr_index-1)
        handles.Curr_x = X(handles.Curr_index-1)+0.005;
    elseif handles.Curr_x >= X(handles.Curr_index+1)
        handles.Curr_x = X(handles.Curr_index+1)-0.005;
    end
    set(handles.Curr_x_txt, 'String', num2str(handles.Curr_x))
    set(handles.Curr_y_txt, 'String', num2str(handles.Curr_y))
    X(handles.Curr_index) = handles.Curr_x;
    Y(handles.Curr_index) = handles.Curr_y;
    set(handles.plot(handles.control_index), 'Ydata', Y);
    set(handles.select, 'Ydata', handles.Curr_y)
    set(handles.plot(handles.control_index), 'Xdata', X);
    set(handles.select, 'Xdata', handles.Curr_x)
    
    handles = DrawSpline(handles);
end
guidata(hObject, handles);

function Control_GUI_WindowButtonUpFcn(hObject, eventdata, handles)
handles.Btndown = 0;
if handles.move_flag == 1
    
    %         delete(handles.spline)
    %
    %     %redraw spline
    %     X = get(handles.plot, 'Xdata');
    %     Y = get(handles.plot, 'Ydata');
    %     Y = interp1(X,Y,0:0.01:handles.SimTime, 'spline');
    %
    %     handles.spline = plot(0:0.01:handles.SimTime,Y, 'r');
end
handles.move_flag = 0;

guidata(hObject, handles);

function save_btn_Callback(hObject, eventdata, handles)

GUI_save.X_dt = get(handles.plot(1), 'Xdata');
GUI_save.Y_dt = get(handles.plot(1), 'Ydata');

GUI_save.X_de = get(handles.plot(2), 'Xdata');
GUI_save.Y_de = get(handles.plot(2), 'Ydata');

GUI_save.X_da = get(handles.plot(3), 'Xdata');
GUI_save.Y_da = get(handles.plot(3), 'Ydata');

GUI_save.X_dr = get(handles.plot(4), 'Xdata');
GUI_save.Y_dr = get(handles.plot(4), 'Ydata');

GUI_save.X_df = get(handles.plot(5), 'Xdata');
GUI_save.Y_df = get(handles.plot(5), 'Ydata');

GUI_save.SimTime = handles.SimTime;
GUI_save.TimeStep = handles.TimeStep;
GUI_save.freq = handles.freq;

[FileName,PathName,FilterIndex] = uiputfile({'*.mat','All Files' },'Save Control Data',...
    'Control_Data');
if FileName~=0
    save([PathName FileName], 'GUI_save')
end


function load_btn_Callback(hObject, eventdata, handles)

[FileName,PathName,FilterIndex] =uigetfile({'*.mat','All Files' },'Load Situation',cd);
if FileName ~= 0
    load([PathName FileName])
    
    set(handles.plot(1), 'Xdata', GUI_save.X_dt)
    set(handles.plot(1), 'Ydata', GUI_save.Y_dt)
    
    set(handles.plot(2), 'Xdata', GUI_save.X_de)
    set(handles.plot(2), 'Ydata', GUI_save.Y_de)
    
    set(handles.plot(3), 'Xdata', GUI_save.X_da)
    set(handles.plot(3), 'Ydata', GUI_save.Y_da)
    
    set(handles.plot(4), 'Xdata', GUI_save.X_dr)
    set(handles.plot(4), 'Ydata', GUI_save.Y_dr)
    
    set(handles.plot(5), 'Xdata', GUI_save.X_df)
    set(handles.plot(5), 'Ydata', GUI_save.Y_df)
    
    set(handles.Ymin_txt, 'String', '-25')
    set(handles.Ymax_txt, 'String', '25')
    set(handles.Xmin_txt, 'String', '0')
    set(handles.Xmax_txt, 'String', num2str(GUI_save.SimTime))
    set(handles.SimTime_txt, 'String', num2str(GUI_save.SimTime))
    
    set(handles.U0_txt, 'String', num2str(GUI_save.Y_dt(1)))
    set(handles.Ufinal_txt, 'String', num2str(GUI_save.Y_dt(end)))
    
    set(handles.freq_txt, 'String', num2str(GUI_save.freq(1)))
    set(handles.TimeStep_txt, 'String', num2str(GUI_save.TimeStep))
    
    handles.Xmin = 0;
    handles.Xmax = GUI_save.SimTime;
    handles.Ymin = -25;
    handles.Ymax = 25;
    handles.TimeStep = GUI_save.TimeStep;
    handles.freq = GUI_save.freq;
    
    
    set(handles.select, 'Xdata', -2000)
    set(handles.select, 'Ydata', -2000)
    
    set(handles.ax, 'Xlim', [0 handles.Xmax]);
    set(handles.ax, 'Ylim', [-25 25]);
    
    
    handles.SimTime = GUI_save.SimTime;
    handles.U0(1) = GUI_save.Y_dt(1);
    handles.Ufinal(1) = GUI_save.Y_dt(end);
    
    handles.U0(2) = GUI_save.Y_de(1);
    handles.Ufinal(2) = GUI_save.Y_de(end);
    
    handles.U0(3) = GUI_save.Y_da(1);
    handles.Ufinal(3) = GUI_save.Y_da(end);
    
    handles.U0(4) = GUI_save.Y_dr(1);
    handles.Ufinal(4) = GUI_save.Y_dr(end);
    
    handles.U0(5) = GUI_save.Y_df(1);
    handles.Ufinal(5) = GUI_save.Y_df(end);
    
    handles.Add = 0;
    handles.Delete = 0;
    handles.Btndown = 0;
    handles.select_flag = 0;
    handles.Curr_x = 0;
    handles.Curr_y = 0;
    handles.Curr_index = 0;
    handles.move_flag= 0;
    
    handles.control_check = 1;
handles.control_check_dt = 1;
handles.control_check_de = [];
handles.control_check_da = [];
handles.control_check_dr = [];
handles.control_check_df = [];
    
    for i = 1:5
        handles.control_index = i;
    handles = DrawSpline(handles);
    end
    handles.control_index = 1;
    set(handles.Curr_y_txt, 'Enable', 'off')
    set(handles.Curr_x_txt, 'Enable', 'off')
    
    set(handles.Add_btn, 'BackgroundColor', [240 240 240]/255)
    set(handles.Add_btn, 'Value', 0)
    set(handles.Delete_btn, 'BackgroundColor', [240 240 240]/255)
    set(handles.Delete_btn, 'Value', 0)
    
    set(handles.spline(1), 'Visible', 'on')
    set(handles.spline(2), 'Visible', 'off')
    set(handles.spline(3), 'Visible', 'off')
    set(handles.spline(4), 'Visible', 'off')
    set(handles.spline(5), 'Visible', 'off')
    
    set(handles.plot(1), 'Visible', 'on')
    set(handles.plot(2), 'Visible', 'off')
    set(handles.plot(3), 'Visible', 'off')
    set(handles.plot(4), 'Visible', 'off')
    set(handles.plot(5), 'Visible', 'off')

    set(handles.Dt_radio, 'Value', 1)
    set(handles.De_radio, 'Value', 0)
    set(handles.Da_radio, 'Value', 0)
    set(handles.Dr_radio, 'Value', 0)
    set(handles.Df_radio, 'Value', 0)
    
    set(handles.Dt_check, 'Value', 1)
    set(handles.De_check, 'Value', 0)
    set(handles.Da_check, 'Value', 0)
    set(handles.Dr_check, 'Value', 0)
    set(handles.Df_check, 'Value', 0)
end




% Update handles structure
guidata(hObject, handles);

function output_btn_Callback(hObject, eventdata, handles)
X_dt_raw = get(handles.plot(1), 'Xdata');
Y_dt_raw = get(handles.plot(1), 'Ydata');
X_de_raw = get(handles.plot(2), 'Xdata');
Y_de_raw = get(handles.plot(2), 'Ydata');
X_da_raw = get(handles.plot(3), 'Xdata');
Y_da_raw = get(handles.plot(3), 'Ydata');
X_dr_raw = get(handles.plot(4), 'Xdata');
Y_dr_raw = get(handles.plot(4), 'Ydata');
X_df_raw = get(handles.plot(5), 'Xdata');
Y_df_raw = get(handles.plot(5), 'Ydata');
assignin('base','T_dt_raw',X_dt_raw)
assignin('base','U_dt_raw',Y_dt_raw)
assignin('base','T_de_raw',X_de_raw)
assignin('base','U_de_raw',Y_de_raw)
assignin('base','T_da_raw',X_da_raw)
assignin('base','U_da_raw',Y_da_raw)
assignin('base','T_dr_raw',X_dr_raw)
assignin('base','U_dr_raw',Y_dr_raw)
assignin('base','T_df_raw',X_df_raw)
assignin('base','U_df_raw',Y_df_raw)
X_filter = 0:handles.TimeStep:handles.SimTime;
Y_linear(1,:) = interp1(X_dt_raw,Y_dt_raw,X_filter, 'linear');
Y_linear(2,:) = interp1(X_de_raw,Y_de_raw,X_filter, 'linear');
Y_linear(3,:) = interp1(X_da_raw,Y_da_raw,X_filter, 'linear');
Y_linear(4,:) = interp1(X_dr_raw,Y_dr_raw,X_filter, 'linear');
Y_linear(5,:) = interp1(X_df_raw,Y_df_raw,X_filter, 'linear');
assignin('base','T_linear',X_filter)
assignin('base','U_linear',Y_linear)

Y_filter(1,:)=dig_filt_diff(Y_linear(1,:),handles.TimeStep,handles.freq(1));
Y_filter(2,:)=dig_filt_diff(Y_linear(2,:),handles.TimeStep,handles.freq(2));
Y_filter(3,:)=dig_filt_diff(Y_linear(3,:),handles.TimeStep,handles.freq(3));
Y_filter(4,:)=dig_filt_diff(Y_linear(4,:),handles.TimeStep,handles.freq(4));
Y_filter(5,:)=dig_filt_diff(Y_linear(5,:),handles.TimeStep,handles.freq(5));
assignin('base','T_filter',X_filter)
assignin('base','U_filter',Y_filter)
fprintf('\n\n Data stored in workspace: \n\n Raw Point Data stored in "T_raw & U_raw" \n Filtered Data stored in "T_filter & U_filter" \n Linear Data stored in "T_linear & U_linear" \n')
guidata(hObject, handles);


function TimeStep_txt_Callback(hObject, eventdata, handles)
temp = str2double(get(hObject,'String'));
    if isnan(temp)
    temp =  handles.TimeStep;
    end
    handles.TimeStep = temp;
    if handles.TimeStep <=0
        handles.TimeStep = 0.0001;
    end
    
    set(handles.TimeStep_txt, 'String', num2str(handles.TimeStep))
temp = handles.control_index;
for i = 1:5
    handles.control_index = i;
handles = DrawSpline(handles);
end
handles.control_index = temp;
guidata(hObject, handles);

function handles = DrawSpline(handles)

X = get(handles.plot(handles.control_index), 'Xdata');
Y = get(handles.plot(handles.control_index), 'Ydata');
Y = interp1(X,Y,0:handles.TimeStep:handles.SimTime, 'linear');

[zf]=dig_filt_diff(Y,handles.TimeStep,handles.freq(handles.control_index));
set(handles.spline(handles.control_index), 'Xdata', 0:handles.TimeStep:handles.SimTime)
set(handles.spline(handles.control_index), 'Ydata', zf)

function RecTimerFun(obj, event, handles)
T1 = [2015 5 22 23 00 0];
T0 = clock;
nsecrem = etime(T1, T0);

ndays = floor(nsecrem/86400);
nhours = floor((nsecrem-ndays*86400)/3600);
nmins = floor((nsecrem -ndays*86400 - 3600*nhours)/60);
nsecs = floor(nsecrem -ndays*86400 - 3600*nhours - 60*nmins);
set(handles.days_txt,'String',num2str(ndays))
set(handles.hours_txt,'String',num2str(nhours))
set(handles.minutes_txt','String',num2str(nmins))

function [zf]=dig_filt_diff(z,dt,Wn)

num1=[0 0 Wn^2];
num2=[0 Wn^2 0];
den=[1 2*Wn Wn^2];

[numd1,dend]=bilinear(num1,den,1/dt);
[numd2,dend]=bilinear(num2,den,1/dt);


zf=filtfilt(numd1,dend,z);


function freq_txt_Callback(hObject, eventdata, handles)
temp = str2double(get(hObject,'String'));
    if isnan(temp)
    temp =  handles.freq(handles.control_index);
    end
handles.freq(handles.control_index) = temp;
if handles.freq(handles.control_index) <=0
    handles.freq(handles.control_index) = 0.001;
end
set(handles.freq_txt, 'String', num2str(handles.freq(handles.control_index)))
handles = DrawSpline(handles);
guidata(hObject, handles);


function Dt_radio_Callback(hObject, eventdata, handles)
handles.control_index = 1;
set(handles.Dt_radio, 'Value', 1)
set(handles.De_radio, 'Value', 0)
set(handles.Da_radio, 'Value', 0)
set(handles.Dr_radio, 'Value', 0)
set(handles.Df_radio, 'Value', 0)
set(handles.plot(1), 'Visible', 'on')
set(handles.plot(2), 'Visible', 'off')
set(handles.plot(3), 'Visible', 'off')
set(handles.plot(4), 'Visible', 'off')
set(handles.plot(5), 'Visible', 'off')
set(handles.spline(1), 'Visible', 'on')
set(handles.spline(2), 'Visible', 'off')
set(handles.spline(3), 'Visible', 'off')
set(handles.spline(4), 'Visible', 'off')
set(handles.spline(5), 'Visible', 'off')
set(handles.Dt_check, 'Value', 1)
set(handles.De_check, 'Value', 0)
set(handles.Da_check, 'Value', 0)
set(handles.Dr_check, 'Value', 0)
set(handles.Df_check, 'Value', 0)
handles.control_check_dt = 1;
handles.control_check_de = [];
handles.control_check_da = [];
handles.control_check_dr = [];
handles.control_check_df = [];
handles.control_check = 1;
Y = get(handles.plot(handles.control_index), 'Ydata');
set(handles.U0_txt, 'String', num2str(Y(1)))
set(handles.Ufinal_txt, 'String', num2str(Y(end)))
set(handles.freq_txt, 'String', num2str(handles.freq(handles.control_index)))
set(handles.select, 'Xdata', -2000)
set(handles.select, 'Ydata', -2000)
set(handles.Curr_x_txt, 'Enable', 'off')
set(handles.Curr_y_txt, 'Enable', 'off')
handles.Add = 0;
handles.Delete = 0;
set(handles.Add_btn, 'BackgroundColor', [240 240 240]/255)
set(handles.Add_btn, 'Value', 0)
set(handles.Delete_btn, 'BackgroundColor', [240 240 240]/255)
set(handles.Delete_btn, 'Value', 0)
handles = DrawSpline(handles);
guidata(hObject, handles);


function De_radio_Callback(hObject, eventdata, handles)
handles.control_index = 2;
set(handles.Dt_radio, 'Value', 0)
set(handles.De_radio, 'Value', 1)
set(handles.Da_radio, 'Value', 0)
set(handles.Dr_radio, 'Value', 0)
set(handles.Df_radio, 'Value', 0)
set(handles.plot(1), 'Visible', 'off')
set(handles.plot(2), 'Visible', 'on')
set(handles.plot(3), 'Visible', 'off')
set(handles.plot(4), 'Visible', 'off')
set(handles.plot(5), 'Visible', 'off')
set(handles.spline(1), 'Visible', 'off')
set(handles.spline(2), 'Visible', 'on')
set(handles.spline(3), 'Visible', 'off')
set(handles.spline(4), 'Visible', 'off')
set(handles.spline(5), 'Visible', 'off')
set(handles.Dt_check, 'Value', 0)
set(handles.De_check, 'Value', 1)
set(handles.Da_check, 'Value', 0)
set(handles.Dr_check, 'Value', 0)
set(handles.Df_check, 'Value', 0)
handles.control_check_dt = [];
handles.control_check_de = 2;
handles.control_check_da = [];
handles.control_check_dr = [];
handles.control_check_df = [];
handles.control_check = 2;
Y = get(handles.plot(handles.control_index), 'Ydata');
set(handles.U0_txt, 'String', num2str(Y(1)))
set(handles.freq_txt, 'String', num2str(handles.freq(handles.control_index)))
set(handles.Ufinal_txt, 'String', num2str(Y(end)))
set(handles.select, 'Xdata', -2000)
set(handles.select, 'Ydata', -2000)
set(handles.Curr_x_txt, 'Enable', 'off')
set(handles.Curr_y_txt, 'Enable', 'off')
handles.Add = 0;
handles.Delete = 0;
set(handles.Add_btn, 'BackgroundColor', [240 240 240]/255)
set(handles.Add_btn, 'Value', 0)
set(handles.Delete_btn, 'BackgroundColor', [240 240 240]/255)
set(handles.Delete_btn, 'Value', 0)
handles = DrawSpline(handles);
guidata(hObject, handles);


function Da_radio_Callback(hObject, eventdata, handles)
handles.control_index = 3;
set(handles.Dt_radio, 'Value', 0)
set(handles.De_radio, 'Value', 0)
set(handles.Da_radio, 'Value', 1)
set(handles.Dr_radio, 'Value', 0)
set(handles.Df_radio, 'Value', 0)
set(handles.plot(1), 'Visible', 'off')
set(handles.plot(2), 'Visible', 'off')
set(handles.plot(3), 'Visible', 'on')
set(handles.plot(4), 'Visible', 'off')
set(handles.plot(5), 'Visible', 'off')
set(handles.spline(1), 'Visible', 'off')
set(handles.spline(2), 'Visible', 'off')
set(handles.spline(3), 'Visible', 'on')
set(handles.spline(4), 'Visible', 'off')
set(handles.spline(5), 'Visible', 'off')
set(handles.Dt_check, 'Value', 0)
set(handles.De_check, 'Value', 0)
set(handles.Da_check, 'Value', 1)
set(handles.Dr_check, 'Value', 0)
set(handles.Df_check, 'Value', 0)
handles.control_check_dt = [];
handles.control_check_de = [];
handles.control_check_da = 3;
handles.control_check_dr = [];
handles.control_check_df = [];
handles.control_check = 3;
Y = get(handles.plot(handles.control_index), 'Ydata');
set(handles.U0_txt, 'String', num2str(Y(1)))
set(handles.Ufinal_txt, 'String', num2str(Y(end)))
set(handles.freq_txt, 'String', num2str(handles.freq(handles.control_index)))
set(handles.select, 'Xdata', -2000)
set(handles.select, 'Ydata', -2000)
set(handles.Curr_x_txt, 'Enable', 'off')
set(handles.Curr_y_txt, 'Enable', 'off')
handles.Add = 0;
handles.Delete = 0;
set(handles.Add_btn, 'BackgroundColor', [240 240 240]/255)
set(handles.Add_btn, 'Value', 0)
set(handles.Delete_btn, 'BackgroundColor', [240 240 240]/255)
set(handles.Delete_btn, 'Value', 0)
handles = DrawSpline(handles);
guidata(hObject, handles);

function Dr_radio_Callback(hObject, eventdata, handles)
handles.control_index = 4;
set(handles.Dt_radio, 'Value', 0)
set(handles.De_radio, 'Value', 0)
set(handles.Da_radio, 'Value', 0)
set(handles.Dr_radio, 'Value', 1)
set(handles.Df_radio, 'Value', 0)
set(handles.plot(1), 'Visible', 'off')
set(handles.plot(2), 'Visible', 'off')
set(handles.plot(3), 'Visible', 'off')
set(handles.plot(4), 'Visible', 'on')
set(handles.plot(5), 'Visible', 'off')
set(handles.spline(1), 'Visible', 'off')
set(handles.spline(2), 'Visible', 'off')
set(handles.spline(3), 'Visible', 'off')
set(handles.spline(4), 'Visible', 'on')
set(handles.spline(5), 'Visible', 'off')
set(handles.Dt_check, 'Value', 0)
set(handles.De_check, 'Value', 0)
set(handles.Da_check, 'Value', 0)
set(handles.Dr_check, 'Value', 1)
set(handles.Df_check, 'Value', 0)
handles.control_check_dt = [];
handles.control_check_de = [];
handles.control_check_da = [];
handles.control_check_dr = 4;
handles.control_check_df = [];
handles.control_check = 4;
Y = get(handles.plot(handles.control_index), 'Ydata');
set(handles.U0_txt, 'String', num2str(Y(1)))
set(handles.Ufinal_txt, 'String', num2str(Y(end)))
set(handles.freq_txt, 'String', num2str(handles.freq(handles.control_index)))
set(handles.select, 'Xdata', -2000)
set(handles.select, 'Ydata', -2000)
set(handles.Curr_x_txt, 'Enable', 'off')
set(handles.Curr_y_txt, 'Enable', 'off')
handles.Add = 0;
handles.Delete = 0;
set(handles.Add_btn, 'BackgroundColor', [240 240 240]/255)
set(handles.Add_btn, 'Value', 0)
set(handles.Delete_btn, 'BackgroundColor', [240 240 240]/255)
set(handles.Delete_btn, 'Value', 0)
handles = DrawSpline(handles);
guidata(hObject, handles);

function Df_radio_Callback(hObject, eventdata, handles)
handles.control_index = 5;
set(handles.Dt_radio, 'Value', 0)
set(handles.De_radio, 'Value', 0)
set(handles.Da_radio, 'Value', 0)
set(handles.Dr_radio, 'Value', 0)
set(handles.Df_radio, 'Value', 1)
set(handles.plot(1), 'Visible', 'off')
set(handles.plot(2), 'Visible', 'off')
set(handles.plot(3), 'Visible', 'off')
set(handles.plot(4), 'Visible', 'off')
set(handles.plot(5), 'Visible', 'on')
set(handles.spline(1), 'Visible', 'off')
set(handles.spline(2), 'Visible', 'off')
set(handles.spline(3), 'Visible', 'off')
set(handles.spline(4), 'Visible', 'off')
set(handles.spline(5), 'Visible', 'on')
set(handles.Dt_check, 'Value', 0)
set(handles.De_check, 'Value', 0)
set(handles.Da_check, 'Value', 0)
set(handles.Dr_check, 'Value', 0)
set(handles.Df_check, 'Value', 1)
handles.control_check_dt = [];
handles.control_check_de = [];
handles.control_check_da = [];
handles.control_check_dr = [];
handles.control_check_df = 5;
handles.control_check = 5;
Y = get(handles.plot(handles.control_index), 'Ydata');
set(handles.U0_txt, 'String', num2str(Y(1)))
set(handles.Ufinal_txt, 'String', num2str(Y(end)))
set(handles.freq_txt, 'String', num2str(handles.freq(handles.control_index)))
set(handles.select, 'Xdata', -2000)
set(handles.select, 'Ydata', -2000)
set(handles.Curr_x_txt, 'Enable', 'off')
set(handles.Curr_y_txt, 'Enable', 'off')
handles.Add = 0;
handles.Delete = 0;
set(handles.Add_btn, 'BackgroundColor', [240 240 240]/255)
set(handles.Add_btn, 'Value', 0)
set(handles.Delete_btn, 'BackgroundColor', [240 240 240]/255)
set(handles.Delete_btn, 'Value', 0)
handles = DrawSpline(handles);
guidata(hObject, handles);

function Dt_check_Callback(hObject, eventdata, handles)
if handles.control_index == 1
    set(handles.Dt_check, 'Value', 1)
    handles.control_check_dt = 1;
else
    
    handles.control_check_dt = get(hObject, 'Value');
end
if handles.control_check_dt ~= 1
    set(handles.plot(1), 'Visible', 'off')
    set(handles.spline(1), 'Visible', 'off')
end
if handles.control_check_dt==0
    handles.control_check_dt = [];
end
handles.control_check = [handles.control_check_dt handles.control_check_de handles.control_check_da handles.control_check_dr handles.control_check_df];

for i = 1:length(handles.control_check)
    set(handles.plot(handles.control_check(i)), 'Visible', 'on')
    set(handles.spline(handles.control_check(i)), 'Visible', 'on')
end
guidata(hObject, handles);


function De_check_Callback(hObject, eventdata, handles)
if handles.control_index == 2
    set(handles.De_check, 'Value', 1)
    handles.control_check_de = 2;
else
    
    handles.control_check_de = get(hObject, 'Value')*2;
end
if handles.control_check_de ~= 2
    set(handles.plot(2), 'Visible', 'off')
    set(handles.spline(2), 'Visible', 'off')
end
if handles.control_check_de==0
    handles.control_check_de = [];
end
handles.control_check = [handles.control_check_dt handles.control_check_de handles.control_check_da handles.control_check_dr handles.control_check_df];



for i = 1:length(handles.control_check)
    set(handles.plot(handles.control_check(i)), 'Visible', 'on')
    set(handles.spline(handles.control_check(i)), 'Visible', 'on')
end

guidata(hObject, handles);

function Da_check_Callback(hObject, eventdata, handles)
if handles.control_index == 3
    set(handles.Da_check, 'Value', 1)
    handles.control_check_da = 3;
else
    
    handles.control_check_da = get(hObject, 'Value')*3;
end
if handles.control_check_da ~= 3
    set(handles.plot(3), 'Visible', 'off')
    set(handles.spline(3), 'Visible', 'off')
end
if handles.control_check_da==0
    handles.control_check_da = [];
end
handles.control_check = [handles.control_check_dt handles.control_check_de handles.control_check_da handles.control_check_dr handles.control_check_df];



for i = 1:length(handles.control_check)
    set(handles.plot(handles.control_check(i)), 'Visible', 'on')
    set(handles.spline(handles.control_check(i)), 'Visible', 'on')
end

guidata(hObject, handles);

function Dr_check_Callback(hObject, eventdata, handles)
if handles.control_index == 4
    set(handles.Dr_check, 'Value', 1)
    handles.control_check_dr = 4;
else
    
    handles.control_check_dr = get(hObject, 'Value')*4;
end
if handles.control_check_dr ~= 4
    set(handles.plot(4), 'Visible', 'off')
    set(handles.spline(4), 'Visible', 'off')
end

if handles.control_check_dr==0
    handles.control_check_dr = [];
end
handles.control_check = [handles.control_check_dt handles.control_check_de handles.control_check_da handles.control_check_dr handles.control_check_df];


for i = 1:length(handles.control_check)
    set(handles.plot(handles.control_check(i)), 'Visible', 'on')
    set(handles.spline(handles.control_check(i)), 'Visible', 'on')
end

guidata(hObject, handles);

function Df_check_Callback(hObject, eventdata, handles)
if handles.control_index == 5
    set(handles.Df_check, 'Value', 1)
    handles.control_check_df = 5;
else
    
    handles.control_check_df = get(hObject, 'Value')*5;
end
if handles.control_check_df ~= 5
    set(handles.plot(5), 'Visible', 'off')
    set(handles.spline(5), 'Visible', 'off')
end

if handles.control_check_df==0
    handles.control_check_df = [];
end
handles.control_check = [handles.control_check_dt handles.control_check_de handles.control_check_da handles.control_check_dr handles.control_check_df];


for i = 1:length(handles.control_check)
    set(handles.plot(handles.control_check(i)), 'Visible', 'on')
    set(handles.spline(handles.control_check(i)), 'Visible', 'on')
end

guidata(hObject, handles);


%% =================================================
function Ymax_txt_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Ymin_txt_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Xmin_txt_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Xmax_txt_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function SimTime_txt_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function U0_txt_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Ufinal_txt_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Curr_x_txt_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Curr_y_txt_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function TimeStep_txt_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close Control_GUI_full.
function Control_GUI_CloseRequestFcn(hObject, eventdata, handles)
if ~isempty(timerfindall)
    stop(timerfindall)
    delete(timerfindall)
end
delete(hObject);




function freq_txt_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Creates and returns a handle to the GUI figure. 
function h1 = Control_GUI_full_LayoutFcn(policy)
% policy - create a new figure or use a singleton. 'new' or 'reuse'.

persistent hsingleton;
if strcmpi(policy, 'reuse') & ishandle(hsingleton)
    h1 = hsingleton;
    return;
end

appdata = [];
appdata.GUIDEOptions = struct(...
    'active_h', [], ...
    'taginfo', struct(...
    'figure', 2, ...
    'axes', 2, ...
    'text', 25, ...
    'edit', 12, ...
    'pushbutton', 5, ...
    'togglebutton', 2, ...
    'uipanel', 4, ...
    'radiobutton', 7, ...
    'checkbox', 6), ...
    'override', 0, ...
    'release', 13, ...
    'resize', 'none', ...
    'accessibility', 'callback', ...
    'mfile', 1, ...
    'callbacks', 1, ...
    'singleton', 1, ...
    'syscolorfig', 1, ...
    'blocking', 0, ...
    'lastSavedFile', 'C:\Users\Darren\Dropbox\Tutoring\Flight Mechanics 1\Control_GUI_SOURCE\Control_GUI_full.m', ...
    'lastFilename', 'C:\Users\Darren\Dropbox\Tutoring\Flight Mechanics 1\Control_GUI_SOURCE\Control_GUI.fig');
appdata.lastValidTag = 'Control_GUI';
appdata.GUIDELayoutEditor = [];
appdata.initTags = struct(...
    'handle', [], ...
    'tag', 'Control_GUI');

h1 = figure(...
'Units','characters',...
'PaperUnits',get(0,'defaultfigurePaperUnits'),...
'CloseRequestFcn',@(hObject,eventdata)Control_GUI_full('Control_GUI_CloseRequestFcn',hObject,eventdata,guidata(hObject)),...
'Color',[0.941176470588235 0.941176470588235 0.941176470588235],...
'Colormap',[0 0 0.5625;0 0 0.625;0 0 0.6875;0 0 0.75;0 0 0.8125;0 0 0.875;0 0 0.9375;0 0 1;0 0.0625 1;0 0.125 1;0 0.1875 1;0 0.25 1;0 0.3125 1;0 0.375 1;0 0.4375 1;0 0.5 1;0 0.5625 1;0 0.625 1;0 0.6875 1;0 0.75 1;0 0.8125 1;0 0.875 1;0 0.9375 1;0 1 1;0.0625 1 1;0.125 1 0.9375;0.1875 1 0.875;0.25 1 0.8125;0.3125 1 0.75;0.375 1 0.6875;0.4375 1 0.625;0.5 1 0.5625;0.5625 1 0.5;0.625 1 0.4375;0.6875 1 0.375;0.75 1 0.3125;0.8125 1 0.25;0.875 1 0.1875;0.9375 1 0.125;1 1 0.0625;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.9375 0 0;0.875 0 0;0.8125 0 0;0.75 0 0;0.6875 0 0;0.625 0 0;0.5625 0 0],...
'IntegerHandle','off',...
'InvertHardcopy',get(0,'defaultfigureInvertHardcopy'),...
'MenuBar','none',...
'Name','Control_GUI',...
'NumberTitle','off',...
'PaperPosition',get(0,'defaultfigurePaperPosition'),...
'PaperSize',get(0,'defaultfigurePaperSize'),...
'PaperType',get(0,'defaultfigurePaperType'),...
'Position',[103.8 9.92307692307692 248.2 51.6923076923077],...
'Resize','off',...
'WindowButtonDownFcn',@(hObject,eventdata)Control_GUI_full('Control_GUI_WindowButtonDownFcn',hObject,eventdata,guidata(hObject)),...
'WindowButtonMotionFcn',@(hObject,eventdata)Control_GUI_full('Control_GUI_WindowButtonMotionFcn',hObject,eventdata,guidata(hObject)),...
'WindowButtonUpFcn',@(hObject,eventdata)Control_GUI_full('Control_GUI_WindowButtonUpFcn',hObject,eventdata,guidata(hObject)),...
'HandleVisibility','callback',...
'UserData',[],...
'Tag','Control_GUI',...
'Visible','on',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'plot_ax';

h2 = axes(...
'Parent',h1,...
'Units','characters',...
'Position',[22.6 19.3076923076923 217.4 27],...
'CameraPosition',[0.5 0.5 9.16025403784439],...
'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
'Color',get(0,'defaultaxesColor'),...
'ColorOrder',get(0,'defaultaxesColorOrder'),...
'LooseInset',[30.524 6.68461538461538 22.306 4.55769230769231],...
'XColor',get(0,'defaultaxesXColor'),...
'YColor',get(0,'defaultaxesYColor'),...
'ZColor',get(0,'defaultaxesZColor'),...
'Tag','plot_ax',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

h3 = get(h2,'title');

set(h3,...
'Parent',h2,...
'Units','data',...
'FontUnits','points',...
'BackgroundColor','none',...
'Color',[0 0 0],...
'DisplayName',blanks(0),...
'EdgeColor','none',...
...
'DVIMode','auto',...
'FontAngle','normal',...
'FontName','Helvetica',...
'FontSize',10,...
'FontWeight','normal',...
'HorizontalAlignment','center',...
'LineStyle','-',...
'LineWidth',0.5,...
'Margin',2,...
'Position',[0.5 1.01851851851852 1.00005459937205],...
'Rotation',0,...
'String',blanks(0),...
'Interpreter','tex',...
'VerticalAlignment','bottom',...
'ButtonDownFcn',[],...
'CreateFcn', {@local_CreateFcn, [], ''} ,...
'DeleteFcn',[],...
'BusyAction','queue',...
'HandleVisibility','off',...
'HelpTopicKey',blanks(0),...
'HitTest','on',...
'Interruptible','on',...
'SelectionHighlight','on',...
'Serializable','on',...
'Tag',blanks(0),...
'UserData',[],...
'Visible','on',...
'XLimInclude','on',...
'YLimInclude','on',...
'ZLimInclude','on',...
'CLimInclude','on',...
'ALimInclude','on',...
'IncludeRenderer','on',...
'Clipping','off');

h4 = get(h2,'xlabel');

set(h4,...
'Parent',h2,...
'Units','data',...
'FontUnits','points',...
'BackgroundColor','none',...
'Color',[0 0 0],...
'DisplayName',blanks(0),...
'EdgeColor','none',...
...
'DVIMode','auto',...
'FontAngle','normal',...
'FontName','Helvetica',...
'FontSize',10,...
'FontWeight','normal',...
'HorizontalAlignment','center',...
'LineStyle','-',...
'LineWidth',0.5,...
'Margin',2,...
'Position',[0.499080036798528 -0.066951566951567 1.00005459937205],...
'Rotation',0,...
'String',blanks(0),...
'Interpreter','tex',...
'VerticalAlignment','cap',...
'ButtonDownFcn',[],...
'CreateFcn', {@local_CreateFcn, [], ''} ,...
'DeleteFcn',[],...
'BusyAction','queue',...
'HandleVisibility','off',...
'HelpTopicKey',blanks(0),...
'HitTest','on',...
'Interruptible','on',...
'SelectionHighlight','on',...
'Serializable','on',...
'Tag',blanks(0),...
'UserData',[],...
'Visible','on',...
'XLimInclude','on',...
'YLimInclude','on',...
'ZLimInclude','on',...
'CLimInclude','on',...
'ALimInclude','on',...
'IncludeRenderer','on',...
'Clipping','off');

h5 = get(h2,'ylabel');

set(h5,...
'Parent',h2,...
'Units','data',...
'FontUnits','points',...
'BackgroundColor','none',...
'Color',[0 0 0],...
'DisplayName',blanks(0),...
'EdgeColor','none',...
...
'DVIMode','auto',...
'FontAngle','normal',...
'FontName','Helvetica',...
'FontSize',10,...
'FontWeight','normal',...
'HorizontalAlignment','center',...
'LineStyle','-',...
'LineWidth',0.5,...
'Margin',2,...
'Position',[-0.0262189512419503 0.497150997150997 1.00005459937205],...
'Rotation',90,...
'String',blanks(0),...
'Interpreter','tex',...
'VerticalAlignment','bottom',...
'ButtonDownFcn',[],...
'CreateFcn', {@local_CreateFcn, [], ''} ,...
'DeleteFcn',[],...
'BusyAction','queue',...
'HandleVisibility','off',...
'HelpTopicKey',blanks(0),...
'HitTest','on',...
'Interruptible','on',...
'SelectionHighlight','on',...
'Serializable','on',...
'Tag',blanks(0),...
'UserData',[],...
'Visible','on',...
'XLimInclude','on',...
'YLimInclude','on',...
'ZLimInclude','on',...
'CLimInclude','on',...
'ALimInclude','on',...
'IncludeRenderer','on',...
'Clipping','off');

h6 = get(h2,'zlabel');

set(h6,...
'Parent',h2,...
'Units','data',...
'FontUnits','points',...
'BackgroundColor','none',...
'Color',[0 0 0],...
'DisplayName',blanks(0),...
'EdgeColor','none',...
...
'DVIMode','auto',...
'FontAngle','normal',...
'FontName','Helvetica',...
'FontSize',10,...
'FontWeight','normal',...
'HorizontalAlignment','right',...
'LineStyle','-',...
'LineWidth',0.5,...
'Margin',2,...
'Position',[-0.104415823367065 1.1951566951567 1.00005459937205],...
'Rotation',0,...
'String',blanks(0),...
'Interpreter','tex',...
'VerticalAlignment','middle',...
'ButtonDownFcn',[],...
'CreateFcn', {@local_CreateFcn, [], ''} ,...
'DeleteFcn',[],...
'BusyAction','queue',...
'HandleVisibility','off',...
'HelpTopicKey',blanks(0),...
'HitTest','on',...
'Interruptible','on',...
'SelectionHighlight','on',...
'Serializable','on',...
'Tag',blanks(0),...
'UserData',[],...
'Visible','off',...
'XLimInclude','on',...
'YLimInclude','on',...
'ZLimInclude','on',...
'CLimInclude','on',...
'ALimInclude','on',...
'IncludeRenderer','on',...
'Clipping','off');

appdata = [];
appdata.lastValidTag = 'text1';

h7 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'FontSize',12,...
'Position',[1.6 46.2307692307693 11.8 1.53846153846154],...
'String','Ymax',...
'Style','text',...
'Tag','text1',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text2';

h8 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'FontSize',12,...
'Position',[2.6 21.6923076923077 11.8 1.53846153846154],...
'String','Ymin',...
'Style','text',...
'Tag','text2',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Ymax_txt';

h9 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Control_GUI_full('Ymax_txt_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',12,...
'Position',[2.4 44.2307692307693 11.4 2.07692307692308],...
'String','25',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Control_GUI_full('Ymax_txt_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','Ymax_txt');

appdata = [];
appdata.lastValidTag = 'Ymin_txt';

h10 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Control_GUI_full('Ymin_txt_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',12,...
'Position',[2.8 19.3846153846154 11.4 2.07692307692308],...
'String','-25',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Control_GUI_full('Ymin_txt_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','Ymin_txt');

appdata = [];
appdata.lastValidTag = 'Xmin_txt';

h11 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Control_GUI_full('Xmin_txt_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',12,...
'Position',[16.4 13.0769230769231 11.4 2.07692307692308],...
'String','0',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Control_GUI_full('Xmin_txt_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','Xmin_txt');

appdata = [];
appdata.lastValidTag = 'text3';

h12 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'FontSize',12,...
'Position',[16 15.3846153846154 11.8 1.53846153846154],...
'String','Xmin',...
'Style','text',...
'Tag','text3',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Xmax_txt';

h13 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Control_GUI_full('Xmax_txt_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',12,...
'Position',[230 13 11.4 2.07692307692308],...
'String','10',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Control_GUI_full('Xmax_txt_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','Xmax_txt');

appdata = [];
appdata.lastValidTag = 'text4';

h14 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'FontSize',12,...
'Position',[229.8 15.4615384615385 11.8 1.53846153846154],...
'String','Xmax',...
'Style','text',...
'Tag','text4',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Add_btn';

h15 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)Control_GUI_full('Add_btn_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',12,...
'Position',[56.2 7.7692307692308 40.2 4],...
'String','Add Point',...
'Style','togglebutton',...
'Tag','Add_btn',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Delete_btn';

h16 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)Control_GUI_full('Delete_btn_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',12,...
'Position',[56 2.7692307692308 40.2 3.92307692307692],...
'String','Delete Point',...
'Style','togglebutton',...
'Tag','Delete_btn',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Curr_panel';

h17 = uipanel(...
'Parent',h1,...
'Units','characters',...
'FontSize',12,...
'Title','Current Point',...
'Tag','Curr_panel',...
'Clipping','on',...
'Position',[105.2 3.61538461538465 36.8 8.84615384615385],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Curr_x_txt';

h18 = uicontrol(...
'Parent',h17,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Control_GUI_full('Curr_x_txt_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',12,...
'Position',[14.4 4.76923076923077 19.4 1.92307692307692],...
'String','0',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Control_GUI_full('Curr_x_txt_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','Curr_x_txt');

appdata = [];
appdata.lastValidTag = 'Curr_y_txt';

h19 = uicontrol(...
'Parent',h17,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Control_GUI_full('Curr_y_txt_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',12,...
'Position',[14.4 1 19.2 1.92307692307692],...
'String','0',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Control_GUI_full('Curr_y_txt_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','Curr_y_txt');

appdata = [];
appdata.lastValidTag = 'text10';

h20 = uicontrol(...
'Parent',h17,...
'Units','characters',...
'FontSize',12,...
'Position',[1 4.76923076923077 11.4 1.92307692307692],...
'String','X',...
'Style','text',...
'Tag','text10',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text11';

h21 = uicontrol(...
'Parent',h17,...
'Units','characters',...
'FontSize',12,...
'Position',[1 1 11.4 1.92307692307692],...
'String','Y',...
'Style','text',...
'Tag','text11',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'save_btn';

h22 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)Control_GUI_full('save_btn_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',12,...
'Position',[150.6 7.7692307692308 40.2 3.92307692307692],...
'String','Save',...
'Tag','save_btn',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'load_btn';

h23 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)Control_GUI_full('load_btn_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',12,...
'Position',[150.4 2.84615384615387 40.2 3.92307692307692],...
'String','Load',...
'Tag','load_btn',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'output_btn';

h24 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)Control_GUI_full('output_btn_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',12,...
'Position',[194.8 7.76923076923077 40.2 3.92307692307692],...
'String','Output To Workspace',...
'Tag','output_btn',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'TimeStep_txt';

h25 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Control_GUI_full('TimeStep_txt_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',12,...
'Position',[218.4 4.15384615384616 11.4 2.07692307692308],...
'String','0.01',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Control_GUI_full('TimeStep_txt_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','TimeStep_txt');

appdata = [];
appdata.lastValidTag = 'text12';

h26 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'FontSize',12,...
'Position',[195.6 3.76923076923077 20 2.76923076923077],...
'String','Output Timestep',...
'Style','text',...
'Tag','text12',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipanel2';

h27 = uipanel(...
'Parent',h1,...
'Units','characters',...
'FontSize',12,...
'Title','Variables',...
'Tag','uipanel2',...
'Clipping','on',...
'Position',[4.6 0.846153846153872 45.2 11.6153846153846],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text5';

h28 = uicontrol(...
'Parent',h27,...
'Units','characters',...
'FontSize',12,...
'Position',[1.6 6.53846153846154 19.6 2.76923076923077],...
'String','Simulation Time',...
'Style','text',...
'Tag','text5',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'SimTime_txt';

h29 = uicontrol(...
'Parent',h27,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Control_GUI_full('SimTime_txt_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',12,...
'Position',[24.8 7 12.6 1.7],...
'String','10',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Control_GUI_full('SimTime_txt_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','SimTime_txt');

appdata = [];
appdata.lastValidTag = 'text8';

h30 = uicontrol(...
'Parent',h27,...
'Units','characters',...
'FontSize',12,...
'Position',[1.4 4.30769230769231 19.6 1.46153846153846],...
'String','U0',...
'Style','text',...
'Tag','text8',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'U0_txt';

h31 = uicontrol(...
'Parent',h27,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Control_GUI_full('U0_txt_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',12,...
'Position',[24.8 4.23076923076923 12.6 1.7],...
'String','0',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Control_GUI_full('U0_txt_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','U0_txt');

appdata = [];
appdata.lastValidTag = 'text9';

h32 = uicontrol(...
'Parent',h27,...
'Units','characters',...
'FontSize',12,...
'Position',[2.4 1.61538461538461 17.6 1.46153846153846],...
'String','Ufinal',...
'Style','text',...
'Tag','text9',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Ufinal_txt';

h33 = uicontrol(...
'Parent',h27,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Control_GUI_full('Ufinal_txt_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',12,...
'Position',[24.8 1.53846153846154 12.6 1.7],...
'String','0',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Control_GUI_full('Ufinal_txt_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','Ufinal_txt');

appdata = [];
appdata.lastValidTag = 'text13';

h34 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'FontSize',12,...
'ForegroundColor',[1 0 0],...
'Position',[179.6 49.3846153846154 17.6 1.84615384615385],...
'String','DAY(S)',...
'Style','text',...
'Tag','text13',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text14';

h35 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'FontSize',12,...
'ForegroundColor',[1 0 0],...
'Position',[202.6 49.3846153846154 17.6 1.84615384615385],...
'String','HOUR(S)',...
'Style','text',...
'Tag','text14',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text15';

h36 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'FontSize',12,...
'ForegroundColor',[1 0 0],...
'Position',[226.6 49.3846153846154 17.6 1.84615384615385],...
'String','MINUTE(S)',...
'Style','text',...
'Tag','text15',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'days_txt';

h37 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'FontSize',12,...
'ForegroundColor',[1 0 0],...
'Position',[179.6 46.8846153846154 17.6 1.84615384615385],...
'String','0',...
'Style','text',...
'Tag','days_txt',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'hours_txt';

h38 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'FontSize',12,...
'ForegroundColor',[1 0 0],...
'Position',[202.6 46.8846153846154 17.6 1.84615384615385],...
'String','0',...
'Style','text',...
'Tag','hours_txt',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'minutes_txt';

h39 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'FontSize',12,...
'ForegroundColor',[1 0 0],...
'Position',[226.6 46.8846153846154 17.6 1.84615384615385],...
'String','0',...
'Style','text',...
'Tag','minutes_txt',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text22';

h40 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'FontSize',12,...
'Position',[195.6 0.230769230769231 20 3],...
'String','Output Frequency',...
'Style','text',...
'Tag','text22',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'freq_txt';

h41 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Control_GUI_full('freq_txt_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',12,...
'Position',[218.4 0.923076923076925 11.4 2.07692307692308],...
'String','10',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Control_GUI_full('freq_txt_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','freq_txt');

appdata = [];
appdata.lastValidTag = 'Dt_radio';

h42 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)Control_GUI_full('Dt_radio_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',12,...
'ForegroundColor',[1 0 0],...
'Position',[45 48.1538461538462 8.2 2.15384615384615],...
'String','Dt',...
'Style','radiobutton',...
'Value',1,...
'Tag','Dt_radio',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'De_radio';

h43 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)Control_GUI_full('De_radio_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',12,...
'ForegroundColor',[0 0 1],...
'Position',[57.2 48.1538461538462 8.2 2.15384615384615],...
'String','De',...
'Style','radiobutton',...
'Tag','De_radio',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Da_radio';

h44 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)Control_GUI_full('Da_radio_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',12,...
'ForegroundColor',[1 0 1],...
'Position',[69.4 48.1538461538462 8.2 2.15384615384615],...
'String','Da',...
'Style','radiobutton',...
'Tag','Da_radio',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Dr_radio';

h45 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)Control_GUI_full('Dr_radio_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',12,...
'Position',[81.6 48.1538461538462 8.2 2.15384615384615],...
'String','Dr',...
'Style','radiobutton',...
'Tag','Dr_radio',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Dt_check';

h46 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)Control_GUI_full('Dt_check_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',12,...
'ForegroundColor',[1 0 0],...
'Position',[102.6 13.1538461538462 8.2 2.15384615384615],...
'String','Dt',...
'Style','checkbox',...
'Value',1,...
'Tag','Dt_check',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'De_check';

h47 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)Control_GUI_full('De_check_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',12,...
'ForegroundColor',[0 0 1],...
'Position',[114.8 13.1538461538462 8.2 2.15384615384615],...
'String','De',...
'Style','checkbox',...
'Tag','De_check',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Da_check';

h48 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)Control_GUI_full('Da_check_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',12,...
'ForegroundColor',[1 0 1],...
'Position',[127 13.1538461538462 8.2 2.15384615384615],...
'String','Da',...
'Style','checkbox',...
'Tag','Da_check',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Dr_check';

h49 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)Control_GUI_full('Dr_check_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',12,...
'Position',[139.2 13.1538461538462 8.2 2.15384615384615],...
'String','Dr',...
'Style','checkbox',...
'Tag','Dr_check',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text23';

h50 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'FontSize',12,...
'Position',[80.4000000000001 13.3846153846154 20 1.61538461538462],...
'String','Show Plot',...
'Style','text',...
'Tag','text23',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text24';

h51 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'FontSize',12,...
'Position',[22.8000000000001 48.3846153846154 20 1.61538461538462],...
'String','Change Data',...
'Style','text',...
'Tag','text24',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Df_radio';

h52 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)Control_GUI_full('Df_radio_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',12,...
'ForegroundColor',[1 0.694117647058824 0.392156862745098],...
'Position',[93.8 48.1538461538462 8.2 2.15384615384615],...
'String','Df',...
'Style','radiobutton',...
'Tag','Df_radio',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Df_check';

h53 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)Control_GUI_full('Df_check_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',12,...
'ForegroundColor',[1 0.694117647058824 0.392156862745098],...
'Position',[151.4 13.1538461538462 8.2 2.15384615384615],...
'String','Df',...
'Style','checkbox',...
'Tag','Df_check',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );


hsingleton = h1;


% --- Set application data first then calling the CreateFcn. 
function local_CreateFcn(hObject, eventdata, createfcn, appdata)

if ~isempty(appdata)
   names = fieldnames(appdata);
   for i=1:length(names)
       name = char(names(i));
       setappdata(hObject, name, getfield(appdata,name));
   end
end

if ~isempty(createfcn)
   if isa(createfcn,'function_handle')
       createfcn(hObject, eventdata);
   else
       eval(createfcn);
   end
end


% --- Handles default GUIDE GUI creation and callback dispatch
function varargout = gui_mainfcn(gui_State, varargin)

gui_StateFields =  {'gui_Name'
    'gui_Singleton'
    'gui_OpeningFcn'
    'gui_OutputFcn'
    'gui_LayoutFcn'
    'gui_Callback'};
gui_Mfile = '';
for i=1:length(gui_StateFields)
    if ~isfield(gui_State, gui_StateFields{i})
        error(message('MATLAB:guide:StateFieldNotFound', gui_StateFields{ i }, gui_Mfile));
    elseif isequal(gui_StateFields{i}, 'gui_Name')
        gui_Mfile = [gui_State.(gui_StateFields{i}), '.m'];
    end
end

numargin = length(varargin);

if numargin == 0
    % CONTROL_GUI_FULL
    % create the GUI only if we are not in the process of loading it
    % already
    gui_Create = true;
elseif local_isInvokeActiveXCallback(gui_State, varargin{:})
    % CONTROL_GUI_FULL(ACTIVEX,...)
    vin{1} = gui_State.gui_Name;
    vin{2} = [get(varargin{1}.Peer, 'Tag'), '_', varargin{end}];
    vin{3} = varargin{1};
    vin{4} = varargin{end-1};
    vin{5} = guidata(varargin{1}.Peer);
    feval(vin{:});
    return;
elseif local_isInvokeHGCallback(gui_State, varargin{:})
    % CONTROL_GUI_FULL('CALLBACK',hObject,eventData,handles,...)
    gui_Create = false;
else
    % CONTROL_GUI_FULL(...)
    % create the GUI and hand varargin to the openingfcn
    gui_Create = true;
end

if ~gui_Create
    % In design time, we need to mark all components possibly created in
    % the coming callback evaluation as non-serializable. This way, they
    % will not be brought into GUIDE and not be saved in the figure file
    % when running/saving the GUI from GUIDE.
    designEval = false;
    if (numargin>1 && ishghandle(varargin{2}))
        fig = varargin{2};
        while ~isempty(fig) && ~ishghandle(fig,'figure')
            fig = get(fig,'parent');
        end
        
        designEval = isappdata(0,'CreatingGUIDEFigure') || isprop(fig,'__GUIDEFigure');
    end
        
    if designEval
        beforeChildren = findall(fig);
    end
    
    % evaluate the callback now
    varargin{1} = gui_State.gui_Callback;
    if nargout
        [varargout{1:nargout}] = feval(varargin{:});
    else       
        feval(varargin{:});
    end
    
    % Set serializable of objects created in the above callback to off in
    % design time. Need to check whether figure handle is still valid in
    % case the figure is deleted during the callback dispatching.
    if designEval && ishghandle(fig)
        set(setdiff(findall(fig),beforeChildren), 'Serializable','off');
    end
else
    if gui_State.gui_Singleton
        gui_SingletonOpt = 'reuse';
    else
        gui_SingletonOpt = 'new';
    end

    % Check user passing 'visible' P/V pair first so that its value can be
    % used by oepnfig to prevent flickering
    gui_Visible = 'auto';
    gui_VisibleInput = '';
    for index=1:2:length(varargin)
        if length(varargin) == index || ~ischar(varargin{index})
            break;
        end

        % Recognize 'visible' P/V pair
        len1 = min(length('visible'),length(varargin{index}));
        len2 = min(length('off'),length(varargin{index+1}));
        if ischar(varargin{index+1}) && strncmpi(varargin{index},'visible',len1) && len2 > 1
            if strncmpi(varargin{index+1},'off',len2)
                gui_Visible = 'invisible';
                gui_VisibleInput = 'off';
            elseif strncmpi(varargin{index+1},'on',len2)
                gui_Visible = 'visible';
                gui_VisibleInput = 'on';
            end
        end
    end
    
    % Open fig file with stored settings.  Note: This executes all component
    % specific CreateFunctions with an empty HANDLES structure.

    
    % Do feval on layout code in m-file if it exists
    gui_Exported = ~isempty(gui_State.gui_LayoutFcn);
    % this application data is used to indicate the running mode of a GUIDE
    % GUI to distinguish it from the design mode of the GUI in GUIDE. it is
    % only used by actxproxy at this time.   
    setappdata(0,genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]),1);
    if gui_Exported
        gui_hFigure = feval(gui_State.gui_LayoutFcn, gui_SingletonOpt);

        % make figure invisible here so that the visibility of figure is
        % consistent in OpeningFcn in the exported GUI case
        if isempty(gui_VisibleInput)
            gui_VisibleInput = get(gui_hFigure,'Visible');
        end
        set(gui_hFigure,'Visible','off')

        % openfig (called by local_openfig below) does this for guis without
        % the LayoutFcn. Be sure to do it here so guis show up on screen.
        movegui(gui_hFigure,'onscreen');
    else
        gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt, gui_Visible);
        % If the figure has InGUIInitialization it was not completely created
        % on the last pass.  Delete this handle and try again.
        if isappdata(gui_hFigure, 'InGUIInitialization')
            delete(gui_hFigure);
            gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt, gui_Visible);
        end
    end
    if isappdata(0, genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]))
        rmappdata(0,genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]));
    end

    % Set flag to indicate starting GUI initialization
    setappdata(gui_hFigure,'InGUIInitialization',1);

    % Fetch GUIDE Application options
    gui_Options = getappdata(gui_hFigure,'GUIDEOptions');
    % Singleton setting in the GUI M-file takes priority if different
    gui_Options.singleton = gui_State.gui_Singleton;

    if ~isappdata(gui_hFigure,'GUIOnScreen')
        % Adjust background color
        if gui_Options.syscolorfig
            set(gui_hFigure,'Color', get(0,'DefaultUicontrolBackgroundColor'));
        end

        % Generate HANDLES structure and store with GUIDATA. If there is
        % user set GUI data already, keep that also.
        data = guidata(gui_hFigure);
        handles = guihandles(gui_hFigure);
        if ~isempty(handles)
            if isempty(data)
                data = handles;
            else
                names = fieldnames(handles);
                for k=1:length(names)
                    data.(char(names(k)))=handles.(char(names(k)));
                end
            end
        end
        guidata(gui_hFigure, data);
    end

    % Apply input P/V pairs other than 'visible'
    for index=1:2:length(varargin)
        if length(varargin) == index || ~ischar(varargin{index})
            break;
        end

        len1 = min(length('visible'),length(varargin{index}));
        if ~strncmpi(varargin{index},'visible',len1)
            try set(gui_hFigure, varargin{index}, varargin{index+1}), catch break, end
        end
    end

    % If handle visibility is set to 'callback', turn it on until finished
    % with OpeningFcn
    gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
    if strcmp(gui_HandleVisibility, 'callback')
        set(gui_hFigure,'HandleVisibility', 'on');
    end

    feval(gui_State.gui_OpeningFcn, gui_hFigure, [], guidata(gui_hFigure), varargin{:});

    if isscalar(gui_hFigure) && ishghandle(gui_hFigure)
        % Handle the default callbacks of predefined toolbar tools in this
        % GUI, if any
        guidemfile('restoreToolbarToolPredefinedCallback',gui_hFigure); 
        
        % Update handle visibility
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);

        % Call openfig again to pick up the saved visibility or apply the
        % one passed in from the P/V pairs
        if ~gui_Exported
            gui_hFigure = local_openfig(gui_State.gui_Name, 'reuse',gui_Visible);
        elseif ~isempty(gui_VisibleInput)
            set(gui_hFigure,'Visible',gui_VisibleInput);
        end
        if strcmpi(get(gui_hFigure, 'Visible'), 'on')
            figure(gui_hFigure);
            
            if gui_Options.singleton
                setappdata(gui_hFigure,'GUIOnScreen', 1);
            end
        end

        % Done with GUI initialization
        if isappdata(gui_hFigure,'InGUIInitialization')
            rmappdata(gui_hFigure,'InGUIInitialization');
        end

        % If handle visibility is set to 'callback', turn it on until
        % finished with OutputFcn
        gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
        if strcmp(gui_HandleVisibility, 'callback')
            set(gui_hFigure,'HandleVisibility', 'on');
        end
        gui_Handles = guidata(gui_hFigure);
    else
        gui_Handles = [];
    end

    if nargout
        [varargout{1:nargout}] = feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    else
        feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    end

    if isscalar(gui_hFigure) && ishghandle(gui_hFigure)
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);
    end
end

function gui_hFigure = local_openfig(name, singleton, visible)

% openfig with three arguments was new from R13. Try to call that first, if
% failed, try the old openfig.
if nargin('openfig') == 2
    % OPENFIG did not accept 3rd input argument until R13,
    % toggle default figure visible to prevent the figure
    % from showing up too soon.
    gui_OldDefaultVisible = get(0,'defaultFigureVisible');
    set(0,'defaultFigureVisible','off');
    gui_hFigure = openfig(name, singleton);
    set(0,'defaultFigureVisible',gui_OldDefaultVisible);
else
    gui_hFigure = openfig(name, singleton, visible);  
    %workaround for CreateFcn not called to create ActiveX
    if feature('HGUsingMATLABClasses')
        peers=findobj(findall(allchild(gui_hFigure)),'type','uicontrol','style','text');    
        for i=1:length(peers)
            if isappdata(peers(i),'Control')
                actxproxy(peers(i));
            end            
        end
    end
end

function result = local_isInvokeActiveXCallback(gui_State, varargin)

try
    result = ispc && iscom(varargin{1}) ...
             && isequal(varargin{1},gcbo);
catch
    result = false;
end

function result = local_isInvokeHGCallback(gui_State, varargin)

try
    fhandle = functions(gui_State.gui_Callback);
    result = ~isempty(findstr(gui_State.gui_Name,fhandle.file)) || ...
             (ischar(varargin{1}) ...
             && isequal(ishghandle(varargin{2}), 1) ...
             && (~isempty(strfind(varargin{1},[get(varargin{2}, 'Tag'), '_'])) || ...
                ~isempty(strfind(varargin{1}, '_CreateFcn'))) );
catch
    result = false;
end



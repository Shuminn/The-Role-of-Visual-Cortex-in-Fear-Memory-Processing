function Localizer_Exp(sub)
%% *Set Experiment Parameters*
%global stimulus_pix_left,stimulus_pix_right;
%persistent X;
Screen('Preference', 'SkipSyncTests',0);
% Practice parameters
debug_mode = false;
scanning_mode= true;
practice_mode = false;
do_practice_in_scanner=false;

% Scanner parameters
tr_duration_sec=2;
stimulus_duration_sec= 0.25;
num_frames_per_stimulus=15;
block_duration_sec=12;
duration_by_trs = ceil(block_duration_sec / tr_duration_sec);


% Initialize experiment runtime variables
num_blocks = 48;% total
num_trials = 2304;%stimulus
num_trials_each_block = 48;
num_trials_each_tr = tr_duration_sec/stimulus_duration_sec;
nBlock = 0 ;
nTrial = 0;


% Block parameters
wait_time_before_first_stim_sec = 0;
wait_time_after_last_stim_sec = 0;
wait_trs_before_block = ceil(wait_time_before_first_stim_sec / tr_duration_sec);
wait_trs_after_block = ceil(wait_time_after_last_stim_sec / tr_duration_sec);

% Monitor parameters
monitor_size_exp_setup_cm=[45.1 25];%scanning monitor
monitor_size_contr_setup_cm=[47.6,27.7]; %control computer

distance_from_monitor_cm=99.5;

background_grayscale_value=0.5;%monitor background color

% Stimulus parameters
stimulus_size_degrees=2;
stimulus_ecc_degrees=5;
img_alpha=1;

% Fixation parameters
fix_cross_width = 2;
fix_cross_size = 10;
fix_cross_grayscale_value=0;% 0 = black, 1 = white


% File parameters
output_directory = "Results";
file_name_trial_codes = sprintf('sub%d_trial_codes',sub);
file_name_practice_codes = sprintf('sub%d_practice_codes',sub);
save_file_name = ['fmriDG_s' num2str(sub) '_'  'expdata.mat'];
debug_file_name = ['fmriDG_s' num2str(sub) '_'  'crash_workspace.mat'];
%% Define Constants

% Keyboard codes
KBOARD_CODE_SPACE=KbName('space');
KBOARD_CODE_ESC = KbName('esc');
KBOARD_CODE_Y = KbName('y');
KBOARD_CODE_B = KbName('b');
SCANNER_KEY = KbName('S');

% Define inline functions
deg2rad = @(d) d/180*pi;
visual_degree_to_cm = @(angle, dist_from_monitor) dist_from_monitor * tan(deg2rad(angle));
cm_to_visual_degree = @(shift, dist_from_monitor) rad2deg(atan(shift / dist_from_monitor));
%% Initialize Variables

disp('Initializing Variables...');

% Load practice trial lists
%Load = load(file_name_practice_codes);
%practice_position_index = Load.practice_codes.practice_position_index;
%practice_img = Load.practice_codes.practice_img;
%clear Load;

% Load trial lists
Load = load(file_name_trial_codes);
position_index = Load.trial_codes.position_index;
img = Load.trial_codes.img;
clear Load;


%%%???
stop_exp = false;
stop_block = false;
curr_trial = 0;
curr_trial_in_block = 0;
scan_timestamp=[];

% Initialize monitor variables
if scanning_mode
    monitor_size = monitor_size_exp_setup_cm;
else
    monitor_size = monitor_size_contr_setup_cm;
end

whichScreen = max(Screen('Screens'));
%whichScreen(max(Screen('Screens')));
ScrInfo = Screen('resolution',whichScreen);
ScrSize = [ScrInfo.width,ScrInfo.height];
screen_center_pix = [ScrInfo.width/2,ScrInfo.height/2];
pixels_per_cm = sqrt(ScrSize(1)^2 + ScrSize(2)^2) / sqrt(monitor_size(1)^2 + monitor_size(2)^2);
stimulus_size_pixels = visual_degree_to_cm (stimulus_size_degrees,distance_from_monitor_cm) * pixels_per_cm;
stimulus_ecc_pixels = visual_degree_to_cm(stimulus_ecc_degrees,distance_from_monitor_cm) * pixels_per_cm;
stimulus_center_pix_left =[(ScrInfo.width/2 - stimulus_ecc_pixels ),(ScrInfo.height/2 + stimulus_ecc_pixels)];
%stimulus_center_pix_left =[(ScrInfo.width/2 - stimulus_ecc_pixels ),(ScrInfo.height/2 )];
%stimulus_center_pix_right=[(ScrInfo.width/2 + stimulus_ecc_pixels ),(ScrInfo.height/2 )];
stimulus_center_pix_right=[(ScrInfo.width/2 + stimulus_ecc_pixels ),(ScrInfo.height/2 + stimulus_ecc_pixels)];
stimulus_pix_left = [(stimulus_center_pix_left(1)-(stimulus_size_pixels/2)),(stimulus_center_pix_left(2)-(stimulus_size_pixels/2)), ...
    (stimulus_center_pix_left(1)+(stimulus_size_pixels/2)),(stimulus_center_pix_left(2)+(stimulus_size_pixels/2))];
stimulus_pix_right = [(stimulus_center_pix_right(1)-(stimulus_size_pixels/2)),(stimulus_center_pix_right(2)-(stimulus_size_pixels/2)), ...
    (stimulus_center_pix_right(1)+(stimulus_size_pixels/2)),(stimulus_center_pix_right(2)+(stimulus_size_pixels/2))];

%%% Initialize output expdata structure ??
expdata.info.subject_number = sub;
expdata.info.session_time = datestr(now);
expdata.info.tr = tr_duration_sec;

tmpvec = zeros(48,1); % initialize with size 2 just to force a column vector
tmpcel = cell(48,1);  % initialize with size 2 just to force a column vector
expdata.blocks = table(tmpvec,tmpvec,tmpvec,tmpcel,tmpvec,tmpvec,'VariableNames',{'stimulus_shown_time','position_index','stimulus_duration','position_text','scan_begin_time','stimulus_off_time'});%first 4 very ****
%% Initialize Input/Output Devices??

disp('Initializing I/O...');

% Start recording output to the Matlab command window
log_file_name = ['fmriDG_s' num2str(sub) '_log.txt'];
logtxt=fopen(fullfile(output_directory,log_file_name),'w');
fclose(logtxt);
diary(fullfile(output_directory,log_file_name));
diary on;
%% Initialize PsychToolBox Display

try
    disp('Initializing Display...');
    clear Screen;
    
    % Set debug mode
    if debug_mode
        PsychDebugWindowConfiguration(0,0.8);
    end
    
    % Open a graphics window
    
    [window,rect] = Screen('OpenWindow', whichScreen);
    frameDuration=Screen('GetFlipInterval',window)
    
    % Set alpha blending function (this allows transparency)
    Screen(window,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    % Hide the mouse cursor

    if ~debug_mode
        HideCursor(whichScreen);
    end
    
    % Retrieve color codes for black, white, gray and red
    black = BlackIndex(window);  % Retrieves the CLUT color code for black.
    white = WhiteIndex(window);  % Retrieves the CLUT color code for white.
    gray = (white - black)*background_grayscale_value + black;
    red = [white/2 black black];
    
    % Define fixation cross (No idea of what to do!) %%???
    [X,Y] = RectCenter(rect);
    %[X,Y]=[960,960.4135];
    FixCross = [X-fix_cross_width,Y-fix_cross_size,X+fix_cross_width,Y+fix_cross_size;X-fix_cross_size,Y-fix_cross_width,X+fix_cross_size,Y+fix_cross_width];
    FixCross_target = [X-fix_cross_size,Y-fix_cross_width,X+fix_cross_size,Y+fix_cross_width];
    
    Screen('Flip', window);
    WaitSecs(0.1);
    
    % Load textures
    disp('Loading textures...');
    %num_practice_img = length(practice_img);
    %for i = 1: num_practice_img
     %   textures.practice_img{i} = Screen('MakeTexture', window, practice_img{i});
    %end
    num_img = length(img);
    for i = 1:num_img
        textures.img{i} = Screen('MakeTexture', window, img{i});
    end
    
    % Set font
    Screen('TextFont',window, 'Simsun');
    Screen('Textfont', window, '-:lang=zh-CN');
    Screen('Preference','TextEncodingLocale','UTF8');
    
catch err % This is what happens if there was an error within the function
    % Show error
    disp('ERROR! terminating...');
    
    %disp('Saving expdata...');
    % save exp data
    %save(fullfile(output_directory,save_file_name),'expdata');
    
    disp('Saving workspace for debugging');
    % save exp data as well as entire workspace for debugging
    save(fullfile(output_directory,debug_file_name),'expdata');
    % terminate
    terminate_exp;
    commandwindow;
    
    disp('Now throwing error:');
    for i = length(err.stack):-1:1
        disp(err.stack(i));
    end
    disp(['ERROR: ' err.message]);
    
    % Close diary
    diary off
    
    return;
end
%% Run Experiment
global stimulus_pix_left stimulus_pix_right;
global  stop_block stop_exp SCANNER_KEY KBOARD_CODE_SPACE KBOARD_CODE_ESC;
global KBOARD_CODE_Y KBOARD_CODE_B window gray black;
global num_img textures;
try
    
    % Start logging keyboard (and TR trigger) input
    % There is some error that can come up where the experiment will not
    % start after the first run due to some problem with the Kb Queue.
    % Closing and restarting Matlab is one solution for this...
    KbQueueCreate;
    KbQueueStart;
    disp('show fixcross');
    Screen('FillRect', window, 1, FixCross');
    Screen('Flip',window);
    KbQueueFlush;
    disp('Press Space to enter instruction page...');
    wait_for_tr_or_kb_input; 
    disp('Show instructions...');
    % Instructions
    Screen('FillRect', window, gray);
    immatrix=imread('instruction.png');
    instruction=Screen('MakeTexture',window,immatrix);
    Screen('DrawTexture',window,instruction);
    Screen('Flip', window);
    KbQueueFlush;
    disp('Press Space to enter waiting page...');
    wait_for_tr_or_kb_input; % Press Space to Begin
    
    % Run practice block
    if practice_mode==true
        disp('Run practice block...');
        % Alert to begin!
        Screen('FillRect', window, 1, FixCross');
        Screen('Flip',window);
        WaitSecs(2);
        for i = 1:num_practice_img
            Screen('DrawTexture',window,textures.practice_img{i},[],stimulus_pix_left);
            Screen('FillRect', window, fix_cross_grayscale_value, FixCross');
            Screen('Flip',window);
            WaitSecs(stimulus_duration_sec);
        end
        Screen('FillRect', window, fix_cross_grayscale_value, FixCross');
        WaitSecs(block_duration_sec);
        Screen('Flip',window);
        stop_exp=true;
    elseif practice_mode==false
        if do_practice_in_scanner==true
            disp('Run practice block...');
            %Alert to begin!
            Screen('FillRect', window, 1, FixCross');
            Screen('Flip',window);
            WaitSecs(2);
            for i = 1:num_practice_img
                Screen('DrawTexture',window,textures.practice_img{i},[],stimulus_pix_left);
                Screen('FillRect', window, fix_cross_grayscale_value, FixCross');
                Screen('Flip',window);
                WaitSecs(stimulus_duration_sec);
            end
            Screen('FillRect', window, fix_cross_grayscale_value, FixCross');
            WaitSecs(block_duration_sec);
            Screen('Flip',window);
            curr_block=1;
        end
    end
    
    curr_block=1;
    stop_exp=false;
    nTrial_in_left_block=0;%AllLeftBlock 
    %InOneBlock
    Screen('Flip',window);
    fprintf('Waiting for first scanner input trigger...\n');
    [scan_timestamp(curr_block),~]=wait_for_tr_or_kb_input;
    WaitSecs(8);
    Screen('FillRect', window, fix_cross_grayscale_value, FixCross');
    Screen('Flip',window);
    WaitSecs(11.999);
    while curr_block <= 24 && ~stop_exp
        if rem(curr_block,2)==1
            nTrial_in_one_block = 1;
            for i = (nTrial_in_left_block+1):(nTrial_in_left_block+num_trials_each_block)
                Screen('DrawTexture',window,textures.img{i},[],stimulus_pix_left);
                Screen('FillRect', window, fix_cross_grayscale_value, FixCross');
                t1=Screen('Flip',window);
                if nTrial_in_one_block==1
                    expdata.blocks.stimulus_shown_time(curr_block)=t1;
                    nTrial_in_one_block=48;
                end
                Screen('FillRect', window, fix_cross_grayscale_value, FixCross');
                t2=Screen('Flip',window,t1+0.243);
            end
            curr_block=curr_block+1;
        elseif rem(curr_block,2)==0
            Screen('FillRect', window, fix_cross_grayscale_value, FixCross');
            t3=Screen('Flip',window);
            if nTrial_in_one_block==48
                expdata.blocks.stimulus_off_time(curr_block-1)=t2;
            end
            disp('Run experimental blocks...');
            disp(['Block ' num2str(curr_block)]);
            nTrial_in_left_block=nTrial_in_left_block+num_trials_each_block;
            %WriteLeftBlockData
            expdata.blocks.position_index(curr_block-1)=1;
            expdata.blocks.stimulus_duration(curr_block-1)=expdata.blocks.stimulus_off_time(curr_block-1)-expdata.blocks.stimulus_shown_time(curr_block-1);
            expdata.blocks.position_text{curr_block-1}='left';
            expdata.blocks.scan_begin_time(1)=scan_timestamp(1);
            %WriteFoveaData
            expdata.blocks.stimulus_shown_time(curr_block)=t3
            expdata.blocks.position_index(curr_block)=0;
            expdata.blocks.position_text{curr_block}='Fovea';
            t4=Screen('Flip',window,t3+11.999);
            expdata.blocks.stimulus_off_time(curr_block)=t4
            expdata.blocks.stimulus_duration(curr_block)=t4-t3;
            curr_block = curr_block + 1;
        end
    end
    
    KbQueueFlush;
    %disp('Press Space to enter waiting page...');
    %wait_for_tr_or_kb_input; % Press Space to Begin
    stop_exp=false;
    fprintf('Waiting for first scanner input trigger...\n');
    [scan_timestamp(curr_block),~]=wait_for_tr_or_kb_input;
    WaitSecs(8);
    Screen('FillRect', window, fix_cross_grayscale_value, FixCross');
    Screen('Flip',window);
    WaitSecs(11.999);
    while curr_block>24 && curr_block <= 48 && ~stop_exp       
        if rem(curr_block,2)==1
            nTrial_in_one_block = 1;
            for i = (nTrial_in_left_block+1):(nTrial_in_left_block+num_trials_each_block)
                Screen('DrawTexture',window,textures.img{i},[],stimulus_pix_left);
                Screen('FillRect', window, fix_cross_grayscale_value, FixCross');
                t1=Screen('Flip',window);
                if nTrial_in_one_block==1
                    expdata.blocks.stimulus_shown_time(curr_block)=t1;
                    nTrial_in_one_block=48;
                end
                Screen('FillRect', window, fix_cross_grayscale_value, FixCross');
                t2=Screen('Flip',window,t1+0.243);
            end
            curr_block=curr_block+1;
        elseif rem(curr_block,2)==0
            Screen('FillRect', window, fix_cross_grayscale_value, FixCross');
            t3=Screen('Flip',window);
            if nTrial_in_one_block==48
                expdata.blocks.stimulus_off_time(curr_block-1)=t2;
            end
            disp('Run experimental blocks...');
            disp(['Block ' num2str(curr_block)]);
            nTrial_in_left_block=nTrial_in_left_block+num_trials_each_block;
            %WriteLeftBlockData
            expdata.blocks.position_index(curr_block-1)=1;
            expdata.blocks.stimulus_duration(curr_block-1)=expdata.blocks.stimulus_off_time(curr_block-1)-expdata.blocks.stimulus_shown_time(curr_block-1);
            expdata.blocks.position_text{curr_block-1}='left';
            expdata.blocks.scan_begin_time(25)=scan_timestamp(25);
            %WriteFoveaData
            expdata.blocks.stimulus_shown_time(curr_block)=t3
            expdata.blocks.position_index(curr_block)=0;
            expdata.blocks.position_text{curr_block}='Fovea';
            t4=Screen('Flip',window,t3+11.999);
            expdata.blocks.stimulus_off_time(curr_block)=t4
            expdata.blocks.stimulus_duration(curr_block)=t4-t3;
            curr_block = curr_block + 1;
        end
    end
    %Save Data

    Screen('Flip',window);

    save(fullfile(output_directory,save_file_name),'expdata');
    disp('Terminating Exp...');
    
    % Thank you
    ThanksTxt = ('Thank you very much!');
    Screen('FillRect', window, gray);
    DrawFormattedText(window,double(ThanksTxt),'center','center',black,[],[],[],2);
    Screen('Flip', window);
    WaitSecs(0.8);
    
    % Shut down experiment
    terminate_exp;
    
    % Close diary
    diary off
    
catch err % This is what happens if there was an error within the function
    % Show error
    disp('ERROR! terminating...');
    
    disp('Saving workspace for debugging');
    save(fullfile(output_directory,debug_file_name),'expdata');

    % save exp data as well as entire workspace for debugging
    %save(fullfile(output_directory,debug_file_name));
    
    % terminate
    terminate_exp;
    
    disp('Now throwing error:');
    for i = length(err.stack):-1:1
        disp(err.stack(i));
    end
    disp(['ERROR: ' err.message]);
    
    % Close diary
    diary off
    
    return;
end

disp('Done.');

%% *Nested Function*

    function [scan_timestamp, pressed_keys] = wait_for_tr_or_kb_input
        %global SCANNER_KEY,KBOARD_CODE_SPACE,KBOARD_CODE_ESC,curr_scan,textures,stop_block,stop_exp;
        pressed = false;
        while ~pressed
            pause(0.001);
            [pressed, pressed_keys] = KbQueueCheck;
        end
        if pressed_keys(SCANNER_KEY)
            scan_timestamp = pressed_keys(SCANNER_KEY);
        elseif pressed_keys(KBOARD_CODE_SPACE)
        elseif pressed_keys(KBOARD_CODE_ESC)
            [stop_block,stop_exp]=query_stop;
        end
    end
   
    function [stop_block,stop_exp]= query_stop
        %global KBOARD_CODE_Y,KBOARD_CODE_B,window,gray,black;
        txt = 'Press ''y'' to end experiment, ''b'' to end the block, \n or any other key to continue';
        Screen('FillRect', window, gray);
        DrawFormattedText(window,double(txt),'center','center',black,[],[],[],2);
        Screen('Flip', window); 
        wait_for_response = true;
        while wait_for_response
            pause(0.001);
            [pressed, pressed_keys] = KbQueueCheck;
            if pressed_keys(KBOARD_CODE_Y)
                stop_block = true;
                stop_exp = true;
                wait_for_response = false;
            elseif pressed_keys(KBOARD_CODE_B)
                stop_block = true;
                wait_for_response = false;
            elseif pressed
                wait_for_response = false;
            end
        end
        Screen('FillRect', window, gray);
        Screen('Flip',window);
    end

%     function B=whichScreen(A)
%         
%         if nargin>0
%             X=A;
%         end
%         B=X
%     end

    
    function terminate_exp()
       % global num_practice_img,num_img,textures;
        ShowCursor;
        Screen('Close');
       % Screen('CloseAll');
%         if exist('textures','var')
%             for i=1:num_practice_img
%                 Screen('Close',textures.practice_img{i});
%             end
%             for i=1:num_img
%                 Screen('Close',textures.img{i});
%             end
%         end
        % Close PTB screen
        sca;
        % Give focus back to Matlab
        commandwindow;
    end

end
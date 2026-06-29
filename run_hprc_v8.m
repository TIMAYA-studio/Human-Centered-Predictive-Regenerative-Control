clear; clc; close all;

% HPRC v8:
% Human Intent + Load Transfer based Front-Rear Regenerative Control
%
% Purpose:
% - Estimate driver braking intention
% - Estimate longitudinal load transfer during regenerative braking
% - Adapt front-rear regenerative torque distribution
% - Reduce pitch motion while maintaining stopping performance

% Parameters
m = 1800;
Rw = 0.32;
v0 = 100/3.6;
Tmax = 2500;

% Vehicle geometry
h_cg = 0.55;        % Center of gravity height [m]
wheelbase = 2.8;   % Wheelbase [m]
g = 9.81;

dt = 0.01;
t = 0:dt:10;

tau_pitch = 0.4;
K_pitch = 0.002;

% Brake input
brake = zeros(size(t));
brake(t >= 1) = 1;

modes = ["Conventional", "RTSC", "HPRC_v6", "HPRC_v7", "HPRC_v8"];

tau_rtsc = 0.4;

% HPRC parameters
tau_fast = 0.12;
tau_comfort = 0.44;
risk_gain = 0.16;
min_scale = 0.70;

% Front-Rear distribution
front_base = 0.60;
rear_base  = 0.40;

results = table;

% Logs
frontTorqueLog = zeros(length(modes), length(t));
rearTorqueLog = zeros(length(modes), length(t));
frontRatioLogAll = zeros(length(modes), length(t));
loadTransferLogAll = zeros(length(modes), length(t));
intentLogAll = zeros(length(modes), length(t));

figure; hold on; grid on;

for mode = modes

    v = zeros(size(t));
    T = zeros(size(t));
    pitch = zeros(size(t));

    T_front = zeros(size(t));
    T_rear = zeros(size(t));
    front_ratio_log = zeros(size(t));
    loadTransferLog = zeros(size(t));
    intent_score = zeros(size(t));

    v(1) = v0;

    for k = 1:length(t)-1

        T_request = Tmax * brake(k);

        if mode == "Conventional"

            T(k) = T_request;

        elseif mode == "RTSC"

            T(k+1) = T(k) + (dt/tau_rtsc) * (T_request - T(k));

        elseif mode == "HPRC_v6" || mode == "HPRC_v7" || mode == "HPRC_v8"

            if k > 1
                brake_rate = (brake(k) - brake(k-1)) / dt;
                pitch_rate_now = (pitch(k) - pitch(k-1)) / dt;
            else
                brake_rate = 0;
                pitch_rate_now = 0;
            end

            speed_ratio = v(k) / v0;

            % Human Intent Estimator
            intent = 0.55 * min(abs(brake_rate), 1) ...
                   + 0.30 * min(abs(pitch_rate_now)/10, 1) ...
                   + 0.15 * min(speed_ratio, 1);

            intent = min(max(intent, 0), 1);
            intent_score(k) = intent * 100;

            % Predictive Torque Planner
            tau_now = tau_comfort - intent * (tau_comfort - tau_fast);

            torque_scale = 1.0 - risk_gain * min(abs(pitch_rate_now)/10, 1);
            torque_scale = min(max(torque_scale, min_scale), 1.0);

            T_target_total = T_request * torque_scale;

            if mode == "HPRC_v6"

                T(k+1) = T(k) + (dt/tau_now) * (T_target_total - T(k));

            elseif mode == "HPRC_v7"

                pitch_effect = min(abs(pitch_rate_now)/10, 1);

                front_ratio = front_base - 0.20 * pitch_effect;
                front_ratio = min(max(front_ratio, 0.40), 0.60);

                rear_ratio = 1.0 - front_ratio;

                T_front_target = T_target_total * front_ratio;
                T_rear_target  = T_target_total * rear_ratio;

                T_front(k+1) = T_front(k) + (dt/tau_now) * (T_front_target - T_front(k));
                T_rear(k+1)  = T_rear(k)  + (dt/tau_now) * (T_rear_target  - T_rear(k));

                T(k+1) = T_front(k+1) + T_rear(k+1);

                front_ratio_log(k) = front_ratio;

                % HPRC v8:
                % 1. Estimate pitch tendency
                % 2. Estimate longitudinal load transfer
                % 3. Reduce front regenerative torque ratio
                % 4. Shift torque to rear axle to suppress pitch motion                


            elseif mode == "HPRC_v8"

                pitch_effect = min(abs(pitch_rate_now)/10, 1);

                % Estimated deceleration from current regenerative torque
                ax = abs(T(k)) / (Rw * m);  % [m/s^2]

                % Longitudinal load transfer
                load_transfer = m * ax * h_cg / wheelbase;  % [N]
                load_ratio = min(load_transfer / (m*g), 0.15);

                % Load-transfer-based front-rear distribution
                front_ratio = front_base ...
                            - 0.12 * pitch_effect ...
                            - 0.25 * load_ratio ...
                            - 0.04 * intent;

                front_ratio = min(max(front_ratio, 0.40), 0.60);

                rear_ratio = 1.0 - front_ratio;

                T_front_target = T_target_total * front_ratio;
                T_rear_target  = T_target_total * rear_ratio;

                T_front(k+1) = T_front(k) + (dt/tau_now) * (T_front_target - T_front(k));
                T_rear(k+1)  = T_rear(k)  + (dt/tau_now) * (T_rear_target  - T_rear(k));

                T(k+1) = T_front(k+1) + T_rear(k+1);

                front_ratio_log(k) = front_ratio;
                loadTransferLog(k) = load_transfer;
            end
        end

        % Vehicle dynamics
        a = -(T(k)/Rw) / m;
        v(k+1) = max(0, v(k) + a*dt);

        % Pitch dynamics
        if mode == "HPRC_v7" || mode == "HPRC_v8"
            pitch_torque_effect = T_front(k) - 0.35 * T_rear(k);
            pitch_target = K_pitch * pitch_torque_effect;
        else
            pitch_target = K_pitch * T(k);
        end

        pitch(k+1) = pitch(k) + (dt/tau_pitch) * (pitch_target - pitch(k));
    end

    pitch_rate = [0 diff(pitch)/dt];

    idx_stop = find(v <= 0.01, 1);
    if isempty(idx_stop)
        stop_time = NaN;
    else
        stop_time = t(idx_stop);
    end

    max_pitch = max(pitch);
    max_pitch_rate = max(abs(pitch_rate));

    newRow = table(mode, stop_time, max_pitch, max_pitch_rate, ...
        'VariableNames', {'Mode','StopTime_s','MaxPitch_deg','MaxPitchRate_deg_s'});

    results = [results; newRow];

    modeIdx = find(modes == mode);

    frontTorqueLog(modeIdx,:) = T_front;
    rearTorqueLog(modeIdx,:) = T_rear;
    frontRatioLogAll(modeIdx,:) = front_ratio_log;
    loadTransferLogAll(modeIdx,:) = loadTransferLog;
    intentLogAll(modeIdx,:) = intent_score;

    plot(t, v*3.6, 'LineWidth', 1.5);
end

xlabel('Time [s]');
ylabel('Vehicle Speed [km/h]');
title('Vehicle Speed: Conventional vs RTSC vs HPRC v6/v7/v8');
legend(modes);

disp(results);

figure;
bar(categorical(results.Mode), results.MaxPitchRate_deg_s);
grid on;
ylabel('Max Pitch Rate [deg/s]');
title('Pitch Rate Comparison');

figure;
bar(categorical(results.Mode), results.StopTime_s);
grid on;
ylabel('Stop Time [s]');
title('Stop Time Comparison');

figure;
plot(t, frontTorqueLog(5,:), 'LineWidth', 1.5); hold on;
plot(t, rearTorqueLog(5,:), 'LineWidth', 1.5);
grid on;
xlabel('Time [s]');
ylabel('Regenerative Torque [Nm]');
title('HPRC v8 Front-Rear Torque Distribution');
legend('Front Torque', 'Rear Torque');

figure;
plot(t, frontRatioLogAll(5,:)*100, 'LineWidth', 1.5);
grid on;
xlabel('Time [s]');
ylabel('Front Torque Ratio [%]');
title('HPRC v8 Load-Transfer-Based Front Torque Ratio');
ylim([40 65]);

figure;
plot(t, loadTransferLogAll(5,:), 'LineWidth', 1.5);
grid on;
xlabel('Time [s]');
ylabel('Estimated Load Transfer [N]');
title('HPRC v8 Estimated Longitudinal Load Transfer');

figure;
plot(t, intentLogAll(5,:), 'LineWidth', 1.5);
grid on;
xlabel('Time [s]');
ylabel('Intent Score [%]');
title('HPRC v8 Human Intent Estimation');
ylim([0 100]);


% HPRC v8 causal timeline
hprcIndex = 5;

figure('Name','HPRC v8 Control Timeline');

subplot(6,1,1)
plot(t,brake,'k','LineWidth',2)
grid on
ylabel('Brake')

subplot(6,1,2)
plot(t,intentLogAll(5,:),'b','LineWidth',2)
grid on
ylabel('Intent [%]')

subplot(6,1,3)
plot(t,frontRatioLogAll(5,:)*100,'LineWidth',2)
grid on
ylabel('Front Ratio [%]')

subplot(6,1,4)
plot(t,frontTorqueLog(5,:),'b','LineWidth',2)
hold on
plot(t,rearTorqueLog(5,:),'r','LineWidth',2)
grid on
ylabel('Torque [Nm]')
legend('Front','Rear')

subplot(6,1,5)
plot(t,loadTransferLogAll(5,:),'LineWidth',2)
grid on
ylabel('Load [N]')

subplot(6,1,6)
plot(t,pitch_rate,'LineWidth',2)
grid on
ylabel('Pitch Rate')
xlabel('Time [s]')


% Save results
projectRoot = fileparts(fileparts(mfilename('fullpath')));
resultsDir = fullfile(projectRoot, 'results');

if ~exist(resultsDir, 'dir')
    mkdir(resultsDir);
end

figHandles = findall(0, 'Type', 'figure');
figHandles = flipud(figHandles);

for i = 1:length(figHandles)
    filename = fullfile(resultsDir, sprintf('hprc_v8_figure_%d.png', i));
    saveas(figHandles(i), filename);
end

writetable(results, fullfile(resultsDir, 'hprc_v8_results.csv'));

disp("HPRC v8 figures and results saved.");
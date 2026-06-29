%% RTSC Project Parameters

clear;
clc;
close all;

%% Vehicle Parameters

m = 1800;          % Vehicle Mass [kg]
g = 9.81;          % Gravity [m/s^2]
L = 2.8;           % Wheelbase [m]
h = 0.55;          % Center of Gravity Height [m]

v0 = 100/3.6;      % Initial Speed [m/s]

%% Brake

T_reg_max = 2500;  % Max Regenerative Torque [Nm]

%% Tire

Rw = 0.32;         % Tire Radius [m]

disp("Parameters Loaded")
projectRoot = fileparts(fileparts(mfilename('fullpath')));
load(fullfile(projectRoot, 'hprc_tau_map.mat'));

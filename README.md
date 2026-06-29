# 🚗 Human-Centered Predictive Regenerative Control

MATLAB | Simulink | EV Control

Human-centered regenerative braking control for electric vehicles.

## Overview

This project develops a human-centered regenerative braking control system for electric vehicles.

The goal is to reduce uncomfortable pitch motion during braking while maintaining stopping performance.

## Key Idea

Conventional regenerative braking applies torque rapidly, which can cause large pitch motion.

RTSC smooths regenerative torque using a fixed time constant.

HPRC extends this idea by estimating driver braking intention and vehicle load transfer, then adaptively distributing regenerative torque between front and rear axles.

## Proposed Method

HPRC v8 consists of:

- Human Intent Estimator
- Load Transfer Estimator
- Adaptive Front-Rear Torque Planner
- Vehicle and Pitch Dynamics Model

## Simulation Result

| Method | Stop Time [s] | Max Pitch Angle [deg] | Max Pitch Rate [deg/s] |
|---|---:|---:|---:|
| Conventional | 7.40 | 5.00 | 12.50 |
| RTSC | 7.80 | 5.00 | 4.6568 |
| HPRC v6 | 7.84 | 5.00 | 4.6206 |
| HPRC v7 | 7.81 | 2.30 | 1.9312 |
| HPRC v8 | 7.81 | 2.153 | 1.9051 |

## Main Result

HPRC v8 reduced maximum pitch rate by approximately 59% compared with fixed RTSC while maintaining almost the same stopping time.

## Future Work

- Simulink implementation of HPRC v8
- Four-wheel independent regenerative torque distribution
- Road friction estimation
- Yaw and pitch integrated control
- Application to e-Axle control

## Figures

### HPRC v8 Control Timeline
![HPRC Timeline](results/hprc_v8_figure_8.png)

### Pitch Rate Comparison
![Pitch Rate](results/hprc_v8_figure_2.png)

### Front-Rear Torque Distribution
![Front-Rear Torque](results/hprc_v8_figure_4.png)

### Load Transfer Estimation
![Load Transfer](results/hprc_v8_figure_6.png)


 
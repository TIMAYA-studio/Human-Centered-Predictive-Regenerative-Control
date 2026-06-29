# 🚗 Human-Centered Predictive Regenerative Control (HPRC)

**MATLAB | Simulink | Electric Vehicle Control**

A human-centered regenerative braking control strategy for electric vehicles that reduces vehicle pitch motion while maintaining braking performance.

---

# Overview

This project proposes a **Human-Centered Predictive Regenerative Control (HPRC)** strategy for electric vehicles.

Unlike conventional regenerative braking, the proposed controller estimates the driver's braking intention and predicts longitudinal load transfer to adaptively distribute regenerative torque between the front and rear axles.

The objective is to improve ride comfort by suppressing vehicle pitch motion without significantly increasing stopping time.

---

# Key Features

- Human Intent Estimation
- Longitudinal Load Transfer Estimation
- Adaptive Front–Rear Regenerative Torque Distribution
- Pitch Motion Suppression
- MATLAB Simulation
- Simulink-Based Vehicle Model

---

# Control Concept

```text
Brake Input
      │
      ▼
Human Intent Estimator
      │
      ▼
Load Transfer Estimator
      │
      ▼
Adaptive Torque Planner
      │
      ▼
Front / Rear Regenerative Torque
      │
      ▼
Vehicle Dynamics
      │
      ▼
Reduced Pitch Motion
```

---

# Simulation Results

| Method | Stop Time (s) | Max Pitch Angle (deg) | Max Pitch Rate (deg/s) |
|---------|--------------:|----------------------:|------------------------:|
| Conventional | 7.40 | 5.000 | 12.500 |
| RTSC | 7.80 | 5.000 | 4.6568 |
| HPRC v6 | 7.84 | 5.000 | 4.6206 |
| HPRC v7 | 7.81 | 2.300 | 1.9312 |
| **HPRC v8** | **7.81** | **2.153** | **1.9051** |

---

# Main Achievement

Compared with the fixed-time-constant RTSC strategy, **HPRC v8**

- reduced maximum pitch angle by approximately **57%**
- reduced maximum pitch rate by approximately **59%**
- maintained nearly the same stopping time

These results demonstrate that predictive front–rear regenerative torque distribution can significantly improve ride comfort without sacrificing braking performance.

---

# System Architecture

![System Architecture](HPRC_System_Architecture.png)

---

# Figures

## HPRC v8 Control Timeline

![Timeline](hprc_v8_figure_8.png)

---

## Pitch Rate Comparison

![Pitch Rate](hprc_v8_figure_2.png)

---

## Front–Rear Regenerative Torque Distribution

![Front-Rear Torque](hprc_v8_figure_4.png)

---

## Estimated Longitudinal Load Transfer

![Load Transfer](hprc_v8_figure_6.png)

---

# Future Work

- Simulink implementation of HPRC
- Four-wheel independent regenerative braking control
- Road friction estimation
- Integrated yaw–pitch control
- Application to e-Axle control
- Hardware-in-the-loop (HIL) validation
- Experimental validation using an electric vehicle

---

# Development Environment

- MATLAB R2026a
- Simulink
- Windows 11

---

# Keywords

- MATLAB
- Simulink
- Electric Vehicle
- Regenerative Braking
- Vehicle Dynamics
- Predictive Control
- Human-Centered Control
- Model-Based Development
- e-Axle
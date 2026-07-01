# 🚗 Human-Centered Predictive Regenerative Control (HPRC)

**MATLAB | Simulink | Electric Vehicle Control | Model-Based Development**

A human-centered regenerative braking control strategy for electric vehicles that predicts driver braking intention and longitudinal load transfer to suppress vehicle pitch motion while maintaining braking performance.

---

# Overview

This project proposes a **Human-Centered Predictive Regenerative Control (HPRC)** strategy for electric vehicles.

Conventional regenerative braking typically distributes regenerative torque using fixed control rules. Although effective for energy recovery, this approach does not explicitly consider driver intention or dynamic vehicle behavior during braking.

The proposed controller estimates the driver's braking intention, predicts longitudinal load transfer, and adaptively distributes regenerative torque between the front and rear axles. The objective is to improve ride comfort by reducing vehicle pitch motion without significantly increasing stopping time.

The controller was developed in **MATLAB** and further implemented in **Simulink** using a model-based development (MBD) approach.

---

# Highlights

- Human Intent Estimation
- Longitudinal Load Transfer Estimation
- Adaptive Front–Rear Regenerative Torque Distribution
- Pitch Motion Suppression
- MATLAB Implementation
- Simulink Model-Based Development
- Robustness Evaluation
- Parameter Sensitivity Analysis

---

# Control Architecture

```
Brake Pedal
      │
      ▼
Human Intent Estimator
      │
      ▼
Load Transfer Estimator
      │
      ▼
Front Ratio Planner
      │
      ▼
Torque Distributor
      │
      ▼
Front / Rear Regenerative Torque
      │
      ▼
Pitch Dynamics
      │
      ▼
Vehicle Motion
```

---

# Simulation Results

| Method | Stop Time (s) | Max Pitch Angle (deg) | Max Pitch Rate (deg/s) |
|---------|--------------:|----------------------:|------------------------:|
| Conventional | 7.40 | 5.000 | 12.5000 |
| RTSC | 7.80 | 5.000 | 4.6568 |
| **HPRC v8** | **7.81** | **2.1533** | **1.8991** |

Compared with RTSC, the proposed controller

- Reduced maximum pitch angle by approximately **57%**
- Reduced maximum pitch rate by approximately **59%**
- Maintained nearly identical stopping performance

---

# Robustness Evaluation

## Initial Speed Test

Vehicle speeds:

- 40 km/h
- 60 km/h
- 80 km/h
- 100 km/h
- 120 km/h

### Result

- Stable performance over all tested speeds
- Maximum pitch rate remained approximately **1.90 deg/s**
- Nearly identical stopping performance across all speed conditions

---

## Brake Pattern Test

Brake patterns evaluated

- Weak braking
- Medium braking
- Strong braking
- Progressive (Step-up) braking

### Result

| Method | Max Pitch Rate (deg/s) |
|---------|-----------------------:|
| RTSC | 2.3372 |
| **HPRC v8** | **0.9339** |

The proposed controller achieved approximately **60% reduction** in pitch rate during progressive braking.

---

## Road Friction Test

Road friction coefficients were varied to evaluate controller robustness.

| Road Surface | μ | Method | Stop Time (s) | Max Pitch Rate (deg/s) |
|--------------|---:|---------|--------------:|-----------------------:|
| Dry | 1.0 | Conventional | 7.40 | 12.5000 |
| Dry | 1.0 | RTSC | 7.80 | 4.6568 |
| Dry | 1.0 | **HPRC v8** | **7.81** | **1.8991** |
| Wet | 0.6 | Conventional | 7.40 | 12.5000 |
| Wet | 0.6 | RTSC | 7.80 | 4.6568 |
| Wet | 0.6 | **HPRC v8** | **7.81** | **1.8991** |
| Low-μ Road | 0.3 | Conventional | 10.44 | 8.4758 |
| Low-μ Road | 0.3 | RTSC | 10.84 | 3.1576 |
| Low-μ Road | 0.3 | **HPRC v8** | **10.84** | **1.3341** |

The proposed controller maintained stable braking performance while significantly reducing pitch motion. Under the low-μ road condition, HPRC v8 reduced the maximum pitch rate by approximately **58%** compared with RTSC.

---

# Parameter Sensitivity

The influence of the parameter **risk_gain** was investigated.

| risk_gain | Stop Time (s) | Max Pitch Rate (deg/s) |
|-----------:|--------------:|-----------------------:|
| 0.10 | 7.80 | 1.9231 |
| 0.12 | 7.80 | 1.9171 |
| 0.14 | 7.81 | 1.9111 |
| **0.18 (Selected)** | **7.81** | **1.8991** |
| 0.20 | 7.82 | 1.8932 |

Although **risk_gain = 0.20** produced the smallest pitch rate, the improvement over **0.18** was minimal while slightly increasing stopping time.

Therefore, **risk_gain = 0.18** was selected as the best trade-off between ride comfort and braking performance.

---

# Simulink Validation

The HPRC controller was also implemented in **Simulink**.

Unlike the MATLAB numerical simulation, the Simulink model consists of independent subsystems for

- Human Intent Estimator
- Load Transfer Estimator
- Front Ratio Planner
- Torque Distributor
- Pitch Dynamics

allowing model-based verification of the proposed controller.

| Mode | Stop Time (s) | Max Pitch Rate (Normalized) |
|------|--------------:|----------------------------:|
| Conventional | 7.41 | 0.275 |
| **HPRC v8** | **7.41** | **0.170** |

The Simulink implementation achieved approximately **38% reduction** in pitch rate while maintaining the same stopping performance.

---

# Figures

## System Architecture

![System Architecture](results/HPRC_System_Architecture.png)

## HPRC v8 Control Timeline

![Timeline](results/hprc_v8_figure_8.png)

## Pitch Rate Comparison

![Pitch Rate](results/hprc_v8_figure_2.png)

## Front–Rear Torque Distribution

![Front Rear Torque](results/hprc_v8_figure_4.png)

## Estimated Longitudinal Load Transfer

![Load Transfer](results/hprc_v8_figure_6.png)

---

# Future Work

Future extensions include

- Four-wheel independent regenerative braking
- Adaptive road friction estimation
- Integrated pitch–yaw vehicle control
- e-Axle control
- Hardware-in-the-loop (HIL) validation
- Real-time embedded implementation
- Experimental validation using an electric vehicle
- HPRC v9 with integrated vehicle dynamics

---

# Development Environment

- MATLAB R2026a
- Simulink
- Windows 11

---

# Keywords

- Electric Vehicle
- Regenerative Braking
- Vehicle Dynamics
- Human-Centered Control
- Predictive Control
- MATLAB
- Simulink
- Model-Based Development
- e-Axle
- Ride Comfort

---

# Author

## Haruto Doi (土井 陽斗)

Faculty of Information Sciences  
Hiroshima City University

### Research Interests

- Electric Vehicle Control
- Vehicle Dynamics
- Regenerative Braking
- Human-Centered Control
- MATLAB / Simulink
- Model-Based Development
- e-Axle Control

📧 **haruto.doi2005@gmail.com**
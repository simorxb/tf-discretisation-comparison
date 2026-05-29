# Transfer Function Discretisation Comparison – Second-Order System

[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=simorxb/tf-discretisation-comparison)

## Summary

This project compares three common methods for converting a continuous-time transfer function into a discrete-time model in MATLAB: matched pole-zero mapping, Tustin (bilinear) transformation, and exact zero-order-hold (ZOH) discretisation via the matrix exponential. Step responses of the discretised models are plotted against the continuous-time reference on a single figure.

## Project Overview

Digital controllers and estimators are designed in discrete time, yet physical plants are usually modeled in continuous time. The choice of discretisation method affects sample-to-sample behaviour, frequency warping, and how closely a digital implementation tracks its continuous-time design. This repository isolates that effect on a simple second-order low-pass system and visualises the difference through step-response comparison.

The continuous plant is a unity-gain second-order transfer function with moderate damping. Three discretisations are built at a user-defined sample time $T_s$, then evaluated on the same step input. Discrete responses are shown as sample dots; the continuous response is overlaid as a smooth curve for direct comparison.

### Key Features

- **Continuous plant model** defined as a transfer function in MATLAB.
- **Matched discretisation** using `c2d` with the `'matched'` method.
- **Tustin discretisation** using the bilinear transform via `c2d` with the `'tustin'` method.
- **Exact ZOH discretisation** computed explicitly from state-space data with an augmented matrix exponential.
- **Step-response overlay** of continuous and discrete models on one plot.

## Plant Model

The continuous-time plant is

$$
G(s) = \frac{1}{s^2 + 0.5~s + 1}
$$

Where:

- $s$ is the Laplace variable
- The denominator coefficients correspond to natural frequency $\omega_n = 1~\mathrm{rad/s}$ and damping ratio $\zeta = 0.25$

## Discretisation Methods

Three discrete-time models $G(z)$ are obtained from $G(s)$ at sample time $T_s$.

### Matched pole-zero mapping

MATLAB's `'matched'` option maps continuous poles and zeros to the $z$-domain while preserving gain at a selected frequency. It is often used when preserving the qualitative frequency response of lightly damped modes matters.

### Tustin (bilinear) transform

The Tustin method maps the $s$-plane to the $z$-plane through

$$
s = \frac{2}{T_s}\,\frac{1 - z^{-1}}{1 + z^{-1}}
$$

It introduces frequency warping but is widely used because it preserves stability and is straightforward to apply directly to transfer-function coefficients.

### Exact ZOH via matrix exponential

For a continuous-time state-space model $\dot{x} = A_c x + B_c u$, $y = C_c x + D_c u$, exact ZOH discretisation over one sample interval gives

$$
\begin{bmatrix} A_d & B_d \\\ 0 & I \end{bmatrix} = \exp\left(\begin{bmatrix} A_c & B_c \\\ 0 & 0 \end{bmatrix} T_s\right)
$$

Where:

- $A_d$ and $B_d$ are the discrete state matrices
- $\exp(\cdot)$ is the matrix exponential

This is the exact solution under a zero-order hold on the input between sample instants. It serves as a reference for what `'zoh'` discretisation computes internally from state-space data.

## Simulation Setup

- **Sample time**: $T_s = 2~\mathrm{s}$ (editable in `compare_discretisation.m`)
- **Input**: unit step
- **Simulation horizon**: $20~\mathrm{s}$
- **Continuous response**: evaluated on a dense time grid
- **Discrete responses**: evaluated at sample instants $t = 0, T_s, 2T_s, \ldots$

## Results and Performance

Running `compare_discretisation.m` produces one figure with:

- a continuous step response (solid line)
- matched, Tustin, and exact ZOH responses (dots at sample times)

### Key Observations

- **Exact ZOH vs matched/Tustin**: at a relatively large $T_s$ relative to the plant dynamics, the three methods diverge noticeably in overshoot, settling time, and sample values.
- **Tustin frequency warping**: bilinear mapping can shift effective damping and natural frequency compared with the continuous model.
- **Visual sampling**: plotting discrete outputs as dots emphasises that digital models only define behaviour at sample instants.

## Key Takeaways

- Discretisation is not unique; method choice matters when $T_s$ is a significant fraction of the plant time constants.
- Exact ZOH discretisation from the matrix exponential is the hold-exact state-space solution and is useful as a reference implementation.
- Overlaying continuous and discrete step responses on one plot makes sample-time effects easy to interpret.

## Author

This project is developed by Simone Bertoni. Learn more about my work on my personal website - [Simone Bertoni - Control Lab](https://simonebertonilab.com/).

## Contact

For further communication, connect with me on [LinkedIn](https://www.linkedin.com/in/simone-bertoni-control-eng/).

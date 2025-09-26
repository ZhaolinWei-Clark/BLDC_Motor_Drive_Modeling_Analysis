# BLDC Motor Drive Modeling and Analysis

This repository implements and analyzes a Brushless DC (BLDC) motor drive using both detailed switch-level models and average-value models for 180-degree and 120-degree three-phase inverters with Hall sensor commutation.

The project includes:
- Detailed inverter-fed BLDC drive model (180° conduction) with Hall sensors
- Average-Value Model (AVM) for the 180° conduction case
- Transfer function extraction and linearization at operating points
- Torque–speed characteristic analysis vs. commutation advance angle
- Maximum torque per voltage (MTPV) trajectory and torque–speed curve
- 120° conduction modeling (detailed description and AVM) and comparison vs. 180° conduction
- Scripts to reproduce figures and comparisons

Applicable references: Standard BLDC theory (electromechanical energy conversion), VSI inverter modeling, and average modeling of power converters (e.g., Sudhoff and related literature).

---

## System Parameters

- DC bus voltage: Vdc = 45 V  
- Stator resistance (per phase): Rs = 0.25 Ω  
- Number of poles: p = 8  
- Stator synchronous inductance (phase): Lss = 0.375 mH  
- PM flux linkage (peak, line-neutral EMF constant): λm' = 0.521 mV·s  
- Rotor inertia: J = 0.022 kg·m²  
- Coulomb friction torque: Tfric = 0.012 N·m  
- Initial commutation advance angle: φv = 0° (varied later)

Notes:
- Sign and units of λm’ follow the project’s EMF convention; ensure consistency between back-EMF and torque models.
- If your modeling framework uses different units (e.g., SI base vs. per-unit), convert consistently.

---

## Repository Structure

- models/
  - bldc_180_detailed/ … detailed 180° conduction model with Hall logic and 6-step commutation
  - bldc_180_avm/ … average-value model (180°)
  - bldc_120_avm/ … average-value model (120°)
  - hall/ … Hall sensor logic, commutation tables, and timing utilities
- scripts/
  - run_part1a.m  … simulation and plotting for Part 1(a)
  - run_part1b.m  … AVM study for Part 1(b)
  - run_part1c_tf.m  … linearization and transfer function extraction
  - run_part1d_speed_torque.m / .py … torque–speed via steady-state equations vs. φv
  - run_part1e_compare.m  … overlay dynamic model points on analytical curves
  - run_part1f_mtpv.m … MTPV angle schedule and torque–speed
  - run_part2_suite.m  … Part 2 studies (120° AVM and comparisons)
- utils/
  - motor_params.(m|py) … parameter pack
  - emf_torque_models.(m|py) … back-EMF and torque equations (trapezoidal or quasi-sinusoidal)
  - inverter_models.(m|py) … switching and average models
  - linearize.(m|py) … operating point solve and small-signal linearization
  - plots.(m|py) … common plotting utilities
- docs/
  - figures/ … generated plots
  - notes/ … derivations and references
- README.md … this file

You can use either MATLAB/Simulink or Python (NumPy/SciPy) variants; see scripts and models folders for both flavors if included.

---

## Modeling Overview

1. Electrical model (phase domain or αβ):
   - v = R i + L di/dt + e
   - Back-EMF e is aligned with rotor position and Hall sectors (trapezoidal/six-step form); for AVM, duty-averaged phase voltages are used.

2. Mechanical model:
   - J dωr/dt = Te − Tl − Tfric
   - θ̇ = ωr

3. Torque:
   - Te = (3/2)(p/2) λm iq (sinusoidal approximation) or discrete sector-based torque for trapezoidal BLDC. Ensure consistency with EMF shape and commutation.

4. Inverter models:
   - Detailed (180°): 6-step switching with two devices on at any time, commutation every 60° electrical, includes DC link current, switching states, and Hall logic.
   - AVM (180°): duty-averaged phase voltages mapped from sector and commanded duty; neglects switching ripple.
   - AVM (120°): conduction window of 120° electrical; distinct voltage mapping and torque production per sector; commutation neglected in basic AVM.

---

## How to Run

1. Set up environment:
   - MATLAB/Simulink R2021a+
   - Clone repo and add scripts/utils to path.

2. Configure parameters:
   - Edit utils/motor_params to confirm units and desired φv (advance angle), load torque profile, and simulation time.

3. Execute studies:
   - Part 1(a): scripts/run_part1a to simulate detailed 180° model, load step at t = 0.1 s with Tl = 1.5 N·m. Plots: vdci, phase currents ia, ib, ic, DC bus current idc, electromagnetic torque Te, mechanical speed ωr.
   - Part 1(b): scripts/run_part1b to simulate AVM (180°) with same scenario; compare with Part 1(a).
   - Part 1(c): scripts/run_part1c_tf to linearize about operating points (no load and Tl = 1.5 N·m) and extract H(s) = Te(s)/vdc(s). Save Bode/step plots and numerical transfer functions.
   - Part 1(d): scripts/run_part1d_speed_torque to compute steady-state torque–speed curves for φv = −30°, 0°, +30° using steady-state equations.
   - Part 1(e): scripts/run_part1e_compare to overlay dynamic model points (detailed and AVM) on analytical torque–speed curves.
   - Part 1(f): scripts/run_part1f_mtpv to derive φv(ωr) that maximizes torque for given speed and Vdc, and plot the MTPV torque–speed curve.

4. Part 2 (120° conduction):
   - scripts/run_part2_suite to:
     - Describe and configure 120° detailed and AVM mappings.
     - Run AVM for the Part 1(a) scenario (commutation neglected).
     - Plot torque–speed for φv = −30°, 0°, +30° and compare to 180° case.
     - Verify model points vs. steady-state curves.

All figures are saved to docs/figures.

---

## Key Tasks and Outputs

- Part 1(a): Startup from zero, load step Tl = 1.5 N·m at t = 0.1 s, simulate to t = 2.5 s; plot vdci, ia, idc, Te, ωr.
- Part 1(b): 180° AVM replication, side-by-side comparison; comment on ripple and dynamic fidelity.
- Part 1(c): Extract H(s) = Te/vdc at two operating points; discuss load dependence (nonlinear operating point).
- Part 1(d): Torque–speed curves for φv = −30°, 0°, +30°; discuss effect of advance on torque and base speed.
- Part 1(e): Validate detailed and AVM models against steady-state curves; identify mismatches (e.g., ripple-induced average torque loss at high speed).
- Part 1(f): Derive φv(ωr) for MTPV and plot; compare vs. fixed-angle curves.
- Part 2: 120° AVM study, torque–speed vs. φv, and comparison vs. 180° conduction; discuss torque ripple and average torque differences.

---

## Notes on Implementation Details

- Hall sensor logic:
  - 6 sectors, 60° electrical each, with standard 6-step sequence; ensure correct sign of back-EMF and current alignment.
- Back-EMF shape:
  - Trapezoidal with 120° flat-top is typical for BLDC; you can parameterize the flatness to examine sensitivity.
- Current control:
  - If you include a simple duty regulator, document it; baseline studies may use open-loop fixed duty to reach target speed/torque.
- Linearization:
  - Freeze rotor speed and currents at operating point; small-signal around operating point yields H(s) ≈ Te/vdc via AVM mapping.
- Friction model:
  - Default includes Coulomb friction Tfric; optionally add viscous term Bω for realism (set B=0 if not specified).

---

## Derivation Sketches

- Transfer function H(s) = Te(s)/vdc(s):
  - From AVM: vphase ≈ m(θ, φv)·(Vdc/2) where m is sector-dependent modulation.
  - Electrical dynamics: Δi(s) = Gii(s)·Δv(s), Te ≈ Kt(θ, φv)·i; H(s) ≈ Kt·Gii·∂vphase/∂vdc.
  - Load affects operating point (Kt, Gii depend on ωr, back-EMF), so H(s) changes with load.

- MTPV angle schedule:
  - For voltage-limited operation at higher speeds, choose φv to maximize Te subject to |v| ≤ Vdc.
  - For trapezoidal BLDC, advancing commutation improves EMF-current alignment as speed increases; φv*(ωr) grows with ωr until limited by commutation overlap and current dynamics.

Provide your chosen formula or numeric schedule in scripts/run_part1f_mtpv.

---

## Reproducibility

- Set random seeds if any stochastic elements are used (typically none here).
- Record parameter snapshots in each script; scripts save a YAML/JSON of parameters alongside plots.
- Figures include legends with φv and operating conditions.

---

## Getting Help

- Check docs/notes for derivations and references on AVM and BLDC modeling.
- File issues or discussions for questions or improvements.

---

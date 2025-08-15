# Digital Clock in Verilog

## 📌 Overview
This project implements a **12/24-hour digital clock** in Verilog HDL with the following features:
- **Clock Divider** to generate a slower clock signal from a high-frequency input.
- **Digital Clock** module to keep track of seconds, minutes, and hours.
- **Set Mode** to manually adjust time using **up/down buttons**.
- Supports **12-hour** and **24-hour** formats.

The design is verified using a **testbench** that simulates time progression and manual adjustments.

---

## 📂 Project Structure
```
digital_clock/
├── digitalClock.v   # Main digital clock logic
└── README.md        # Documentation
```

---

## ⚙️ Modules Description

### 1️⃣ `clockDivider`
- **Purpose:** Reduces the high-frequency input clock to a lower frequency suitable for real-time counting.
- **Parameter:** `FREQ` – the target frequency for the divided clock.
- **Inputs:**
  - `clk` – input clock signal.
  - `rst` – synchronous reset.
- **Outputs:**
  - `clkDiv` – divided clock output.
- **Logic:**
  - Counts clock cycles until it reaches `(FREQ-1)/2`, then toggles `clkDiv`.

---

### 2️⃣ `digitalClock`
- **Purpose:** Tracks hours, minutes, and seconds; supports manual setting.
- **Inputs:**
  - `clk` – input clock (can be `clkDiv` from `clockDivider`).
  - `rst` – reset to `00:00:00`.
  - `format` – `1` for 12-hour format, `0` for 24-hour format.
  - `set` – enable manual time adjustment.
  - `up` / `down` – increment or decrement selected time field.
  - `select` – selects which time unit to adjust:
    - `000` – seconds (LSB)
    - `001` – seconds (MSB)
    - `010` – minutes (LSB)
    - `011` – minutes (MSB)
    - `100` – hours (LSB)
    - `101` – hours (MSB)
- **Outputs:**
  - `sec1`, `sec2` – seconds (LSB, MSB)
  - `min1`, `min2` – minutes (LSB, MSB)
  - `hour1`, `hour2` – hours (LSB, MSB)
- **Logic:**
  - Automatically increments time every clock pulse.
  - Rolls over after `59` seconds → `59` minutes → max hours (depending on format).
  - Manual setting mode allows adjusting any unit with `up`/`down` control.

---

### 3️⃣ `testbench`
- **Purpose:** Simulates the clock behavior and manual adjustments.
- **Features:**
  - Resets the clock.
  - Runs in **12-hour format** initially.
  - Switches to **manual set mode** to modify hours.
  - Displays time updates in simulation output.

---

## ▶️ Simulation
1. Use **Icarus Verilog** or any Verilog simulator:
   ```bash
   iverilog -o digitalClock_tb clockDivider.v digitalClock.v testbench.v
   vvp digitalClock_tb
   gtkwave digitalClock.vcd
   ```
2. Output format during simulation:
   ```
   time   HH:MM:SS
   25     00:00:00
   35     00:00:01
   45     00:00:02
   ...
   ```

---

## 📌 Notes
- The provided `clockDivider` parameter `FREQ` should be set based on your FPGA/ASIC clock speed to get **1 Hz** for real-time operation.
- In simulation, you can set `FREQ` to a smaller value for faster testing.
- The time rollover logic respects the chosen **12/24-hour format**.

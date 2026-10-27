# Cellular Signal Survey Worksheet

Fill this in **before buying hardware**. It tells you which carrier to use, where to mount the antenna or modem, and which build in the [guide](../cellular-failover-guide.md) fits.

> Keep your filled-in copy private if the repo is public. It can reveal your location and tower details.

## How to measure

1. Turn **Wi-Fi off** on the phone so tests use cellular only.
2. Get the readings:
   - **iPhone:** dial `*3001#12345#*` (Field Test mode) and look for RSRP, RSRQ and SINR under the serving cell.
   - **Android:** use an app such as Network Signal Guru, LTE Discovery or Network Cell Info. Some phones show them under *Settings → About phone → SIM status*.
3. Hold still for about 30 seconds at each spot and write down a typical value, not the best one.
4. Run a speed test (for example, Speedtest by Ookla) at each spot.
5. Repeat the best 1–2 spots **in the evening (7–10 pm)**, when towers are busiest.

## Tower lookup

| Carrier | Nearest tower direction (compass) | Approx. distance | Bands seen (e.g., B13, B66, n77) | Source |
|---|---|---|---|---|
| Verizon | | | | CellMapper |
| AT&T | | | | CellMapper |
| T-Mobile | | | | CellMapper |

## Readings

| Date / time | Carrier | Location (e.g., "upstairs window, N side", "roof peak") | Tech (LTE / 5G) | RSRP (dBm) | RSRQ (dB) | SINR (dB) | Down (Mbps) | Up (Mbps) | Ping (ms) | Notes |
|---|---|---|---|---|---|---|---|---|---|---|
| | | | | | | | | | | |
| | | | | | | | | | | |
| | | | | | | | | | | |
| | | | | | | | | | | |
| | | | | | | | | | | |
| | | | | | | | | | | |

## Reading the results

| Metric | Excellent | Good | Fair | Poor |
|---|---|---|---|---|
| **RSRP** (strength) | > −85 dBm | −85 to −100 | −100 to −110 | < −110 |
| **SINR** (quality) | > 20 dB | 13 to 20 | 0 to 13 | < 0 |
| **RSRQ** (quality under load) | > −10 dB | −10 to −15 | −15 to −20 | < −20 |

- **SINR matters most for speed.** A spot with weaker RSRP but better SINR often performs better.
- An outdoor, elevated antenna typically adds **10–25 dB** over an indoor reading.
- For video calls, aim for **SINR of 5 dB or better** and at least **3–5 Mbps upload** at the final mounting spot.

## Decision

- Best carrier: ________________
- Best mounting spot: ________________
- Build chosen (A / B / C, or non-cellular): ________________

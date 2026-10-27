# How to Set Up Cellular Failover on WAN2 (UDM Pro Max)

A step-by-step guide to adding a cellular backup link to the **UniFi Dream Machine Pro Max**, so the house stays online when the **Spectrum** cable connection (WAN1) goes down.

**Site:** Minoa, NY. **Measured signal:** Verizon 4G+ at **−114 dBm RSRP** at an upstairs window, which is weak.
**Goal:** keep work-from-home video calls going at the lowest cost that actually works.

> Prices and links were checked on **2026-10-27**. Retail prices change often, so confirm at checkout.
> Links marked *(search)* go to a retailer search page because no single stable product page could be confirmed.

---

## Contents

1. [Read this first: what cellular failover can and can't do](#1-read-this-first)
2. [Step 0: Test your signal before you buy anything](#2-step-0-test-your-signal-before-you-buy-anything)
3. [Pick a build](#3-pick-a-build)
4. [Shopping lists with purchase links](#4-shopping-lists)
5. [Pick a data plan](#5-pick-a-data-plan)
6. [Install the hardware](#6-install-the-hardware)
7. [Configure the UDM Pro Max](#7-configure-the-udm-pro-max)
8. [Test the failover](#8-test-the-failover)
9. [Troubleshooting](#9-troubleshooting)
10. [Why not the phone and booster plan?](#10-why-not-the-phone-and-booster-plan)
11. [Sources](#11-sources)

---

## 1. Read this first

- **Failover is not instant.** The UDM decides a WAN is down after its health-check pings fail, which takes a few seconds.
- **Active calls will drop and rejoin.** The backup link has a different public IP, so Teams, Zoom, Meet and any VPN reconnect. Plan on a freeze of a few seconds up to about a minute. Only a bonding service such as Speedify or Peplink SpeedFusion avoids that, and an employer VPN may not allow one.
- **Signal is the whole game.** At −114 dBm indoors, a cellular modem sitting inside the house will probably be unreliable. Every build below puts the antenna **outdoors and up high, aimed at the tower.** That move alone often gains 10–25 dB.
- **Cellular data is metered.** Pick a plan that is cheap while idle and can be uncapped during an outage (see [section 5](#5-pick-a-data-plan)).

---

## 2. Step 0: Test your signal before you buy anything

This costs nothing and decides which build to buy.

1. **Find the towers.** Open [CellMapper](https://www.cellmapper.net/map), set Provider to **Verizon** (and check **T-Mobile** and **AT&T** too), and zoom in on Minoa. Write down the direction from the house to the nearest Verizon tower or towers.
2. **Measure at the spot where the antenna would go,** such as the roofline, a gable end, or the upstairs window facing the tower. Turn Wi-Fi **off** on the phone and record:
   - **RSRP** (signal strength). Use the Android "Network Signal Guru" or "LTE Discovery" app, or the iPhone Field Test mode (dial `*3001#12345#*`).
   - **SINR** (signal quality). This matters more than RSRP for speed.
   - **Speed test** with [Speedtest by Ookla](https://www.speedtest.net/apps) or fast.com. Do it in the evening too, when the towers are busiest.
3. **If you can, borrow an AT&T or T-Mobile phone** and repeat. A different carrier on a closer tower can beat Verizon at your address.

### How to read the numbers

| RSRP | SINR | What to expect |
|---|---|---|
| Better than −100 dBm | Above 10 dB | Good. Any build below will work. |
| −100 to −110 dBm | 3 to 10 dB | Workable. An outdoor modem or directional antenna is needed. |
| −110 to −120 dBm | 0 to 3 dB | Marginal. Use **Build B** with directional antennas aimed at the tower and mounted as high as possible. |
| Worse than −120 dBm | Below 0 dB | Cellular is unlikely to carry video calls. Use Starlink as WAN2 instead (see `wan-failover-context.md`). |

> Rule of thumb: a video call needs about **3–5 Mbps up and down** with steady latency. Aim for **SINR of 5 dB or better** at the antenna location.

---

## 3. Pick a build

| | **Build A: UniFi 5G Max Outdoor** *(recommended)* | **Build B: GL.iNet Spitz AX + directional antennas** *(weakest signal)* | **Build C: UniFi 5G Backup** *(budget, T-Mobile only)* |
|---|---|---|---|
| What it is | All-in-one weatherproof 5G/LTE modem that mounts outside and runs on PoE | Indoor 5G router with 4 antenna ports, plus a 4x4 directional antenna kit mounted outside | Small PoE 5G RedCap backup modem with T-Mobile eSIM |
| Antenna | Built in. Two directional elements at up to 9 dBi | 4 external yagi/log-periodic elements at up to about 11 dBi each | Built in, small |
| UniFi integration | Native. Adopts into UniFi and shows signal in the dashboard | Shows as a plain Ethernet WAN | Native |
| Carrier | Verizon, AT&T or T-Mobile (bring your own SIM) | Bring your own SIM (confirm Verizon support) | T-Mobile eSIM only |
| Hardware cost | About **$470–520** | About **$700–900** | About **$130** |
| Best for | RSRP around −110 dBm or better at the mounting spot | RSRP worse than −110 dBm, or a tower that's far away | Only if T-Mobile tests well at the house |

**Recommendation:** Start with **Build A** if the rooftop test shows Verizon at about −110 dBm or better with SINR above 3 dB. It's one cable, it's fully managed in UniFi, and it's the simplest to keep running. Pick **Build B** if the outdoor reading is still weaker than −110 dBm, because higher-gain 4x4 antennas give the most signal improvement. Build C only makes sense if T-Mobile tests well.

---

## 4. Shopping lists

> **Important:** The UDM Pro Max has **no PoE ports**. Builds A and C need a **PoE injector** (or a PoE switch you already own).

### Build A: UniFi 5G Max Outdoor *(recommended)*

| # | Item | Why | Approx. price | Buy |
|---|---|---|---|---|
| 1 | **UniFi 5G Max Outdoor** (U5G-Max-Outdoor) | The modem and antennas in one weatherproof unit | $399 (store has shown $439 with a surcharge) | [Ubiquiti Store](https://store.ui.com/us/en/category/all-mobile/products/u5g-max-outdoor) |
| 2 | **PoE+ injector (802.3at, 30 W)** | Powers the modem, since the UDM Pro Max has no PoE. The modem draws up to 14.5 W, which is more than plain 802.3af can deliver. | $20–40 | Ubiquiti U-POE-AT *(search)* [Amazon](https://www.amazon.com/s?k=Ubiquiti+U-POE-AT) |
| 3 | **Outdoor-rated shielded Cat6 cable** (direct burial / UV-rated), long enough to run from the mount to the network rack plus about 10 ft of slack | Weatherproof data and power run | $40–80 for 100–250 ft | *(search)* [Amazon](https://www.amazon.com/s?k=outdoor+shielded+cat6+direct+burial+cable) |
| 4 | **Shielded RJ45 connectors and a crimp tool** (skip if you buy a pre-terminated cable) | Terminate the cable | $20–35 | *(search)* [Amazon](https://www.amazon.com/s?k=shielded+cat6+rj45+pass+through+connectors+crimp+tool) |
| 5 | **Ethernet surge protector** (Ubiquiti ETH-SP-G2), plus a ground wire to the house ground | Protects the UDM from lightning surges on the outdoor cable | About $14–20 | [CDW](https://www.cdw.com/product/ubiquiti-networks-eth-sp-g2-poe-surge-protector/5032008) · [Staples](https://www.staples.com/ubiquiti-networks-surge-protector-eth-sp-g2/product_IM12KF568) |
| 6 | **Mounting pole or J-mount** (1.25–2 in. mast) | Gets the modem above the roofline or onto a gable, aimed at the tower | $25–50 | *(search)* [Amazon](https://www.amazon.com/s?k=antenna+j+mount+wall+mount+mast) · [Home Depot](https://www.homedepot.com/s/antenna%20j%20mount) |
| 7 | **Verizon data SIM** | Service for the modem | See [section 5](#5-pick-a-data-plan) | — |
| 8 | **UPS** (for example, an APC Back-UPS Pro 1500VA) | Keeps the Spectrum modem, UDM, injector and cellular modem up during a power cut | $180–250 | *(search)* [Amazon](https://www.amazon.com/s?k=APC+Back-UPS+Pro+1500VA) |

**Hardware total (without UPS):** about **$470–520**.

Optional: a **5-year Ubiquiti coverage plan** is offered for $99 on the product page.

### Build B: GL.iNet Spitz AX + 4x4 directional antennas *(weakest signal)*

| # | Item | Why | Approx. price | Buy |
|---|---|---|---|---|
| 1 | **GL.iNet Spitz AX (GL-X3000)** 5G router | Quectel RM520N-GL modem with **four SMA antenna ports** for 4x4 MIMO | $380 (sometimes about $330 on Amazon) | [GL.iNet](https://www.gl-inet.com/en-us/products/gl-x3000) · [GL.iNet Store](https://store.gl-inet.com/products/spitz-ax-gl-x3000-wi-fi-6-4g-lte-sim-openwrt) |
| 2 | **Waveform 4x4 MIMO Log Periodic antenna kit** (up to about 11 dBi per element, SMA adapters included, 30 ft cables) | Highest-gain directional option, aimed at the tower | About $400 new; about $270 open-box | [Waveform (new)](https://waveform.com/products/4x4-mimo-log-periodic-kit) · [Waveform (open-box)](https://www.waveform.com/products/open-box-4x4-mimo-log-periodic-kit) |
| | *Cheaper alternative:* 2x2 log periodic kit (uses 2 of the 4 ports) | Less gain from MIMO, lower cost | Less than the 4x4 kit | [Waveform](https://waveform.com/products/mimo-log-periodic-hotspot-external-antennas) |
| 3 | **Mounting pole or J-mount** with room for 2–4 antennas | Height and aiming | $25–50 | *(search)* [Amazon](https://www.amazon.com/s?k=antenna+j+mount+wall+mount+mast) |
| 4 | **Coax entry**: a weatherproof wall pass-through plate or window feed-through, plus coax-seal / self-amalgamating tape | Gets the 4 coax cables inside without leaks | $15–30 | *(search)* [Amazon](https://www.amazon.com/s?k=coax+wall+pass+through+plate+weatherproof) |
| 5 | **Coax lightning arrestors** (SMA or N type, one per cable) | Surge protection on the antenna feeds | $10–15 each | *(search)* [Amazon](https://www.amazon.com/s?k=N+type+lightning+arrestor+coax) |
| 6 | **Short Cat6 patch cable** | GL-X3000 WAN/LAN to the UDM WAN2 port | $5–10 | *(search)* [Amazon](https://www.amazon.com/s?k=cat6+patch+cable+3ft) |
| 7 | **Verizon data SIM** | Service | See [section 5](#5-pick-a-data-plan) | — |
| 8 | **UPS** | Same as Build A | $180–250 | *(search)* [Amazon](https://www.amazon.com/s?k=APC+Back-UPS+Pro+1500VA) |

**Hardware total (without UPS):** about **$700–900**.

> **Verify before buying:** I found no official Verizon certification for the GL-X3000. Its RM520N-GL modem is widely used on Verizon, but check Verizon's BYOD checker with the router's IMEI (or ask GL.iNet support) **before** the return window closes.
> Keep the coax runs **as short as possible.** Every foot of cable loses signal, so mount the router close to where the cables enter the house.

### Build C: UniFi 5G Backup *(budget, only if T-Mobile tests well)*

| # | Item | Approx. price | Buy |
|---|---|---|---|
| 1 | **UniFi 5G Backup** (U5G) | $99 | [Ubiquiti Store](https://store.ui.com/us/en/category/internet-solutions/products/u5g-us) |
| 2 | **Ubiquiti data pack** (T-Mobile eSIM) | From $79/year | Bought through UniFi |
| 3 | **PoE injector** | $20–40 | *(search)* [Amazon](https://www.amazon.com/s?k=Ubiquiti+PoE%2B+injector+802.3at) |

This uses a small internal antenna and the **T-Mobile** network only. Skip it unless T-Mobile tests at −105 dBm or better at a window.

---

## 5. Pick a data plan

The ideal backup plan is cheap while idle, has no contract, and can be uncapped during an outage. Data use for HD video calls is roughly **1–2 GB per hour**.

| Plan | Price | Data | Notes |
|---|---|---|---|
| **Verizon Business Backup and Flexible Use Internet** *(best fit)* | $30/mo per line | 3 GB, then **$70 unlocks unlimited for the rest of that bill cycle** | No contract. Works with a customer-provided router. You pay the $70 only in months with a long outage. [Flyer (PDF)](https://www.verizon.com/business/resources/flyers/verizon-backup-and-flexible-use-promo-flyer-bm-061626-vzfl2730626.pdf) · [Plans](https://www.verizon.com/business/shop/products/networks/connectivity/lte-business-internet/plans) |
| Verizon Business 4G LTE Internet Backup | $20/mo | 1 GB | Cheapest idle cost, but 1 GB is about one hour of calls. Confirm it can be used with your own router. |
| Verizon (consumer) **Wi-Fi Backup** | $20–30/mo | **7 unlimited 24-hour days** per month | Verizon supplies its own router. Confirm the router can hand off over Ethernet to the UDM, and that it allows the UniFi or GL.iNet hardware instead. [Info](https://www.verizon.com/home/internet/wi-fi-backup/) · [FAQ](https://www.verizon.com/support/wifi-backup-faqs/) |
| Your Spectrum Mobile line | Existing | Hotspot cap of 5–10 GB | Ask Spectrum whether its SIM is allowed in a router. Their terms may not allow it, and it eats into your phone's hotspot allowance. |

**Recommendation:** The **Verizon Business Backup and Flexible Use** plan gives the best balance. When you sign up, tell Verizon the device's IMEI (it's printed on the modem or shown in UniFi or the GL.iNet admin page).

**Cutting data use on the backup:** In UniFi, keep WAN2 as **failover only** (don't load-balance), and consider pausing cloud backups, OS updates and camera uploads when you're running on WAN2 (see [step 7.5](#75-optional-keep-heavy-traffic-off-the-backup)).

---

## 6. Install the hardware

### 6.1 Choose the mounting spot
- Go to the **side of the house that faces the tower** you found on CellMapper.
- **Height beats everything.** Above the roofline is best; a gable end or chimney mount is next best.
- Keep a clear line of sight: no trees, metal siding, or solar panels in the way.
- Before drilling anything, **use the device to test.** Temporarily power the modem (or connect the antennas) at the spot and check the signal in UniFi or the GL.iNet admin page.

### 6.2 Build A: mount the UniFi 5G Max Outdoor
1. Put the **Verizon SIM** into the modem's SIM slot before mounting (it has two SIM slots, or eSIM).
2. Fit the mount to the pole or J-mount and attach the modem. **Point the front at the tower** but don't fully tighten it yet.
3. Run the outdoor Cat6 cable from the modem into the house. Leave a **drip loop** (a downward U-bend) just before the cable enters the wall so water drips off instead of following the cable inside.
4. Indoors, install the **ETH-SP-G2 surge protector** where the cable comes in and connect its ground wire to the house electrical ground.
5. Connect it like this:
   ```
   5G Max Outdoor ──(outdoor Cat6)── Surge protector ── PoE injector "PoE" port
                                                        PoE injector "LAN" port ──(patch)── UDM Pro Max LAN port
   ```
6. Plug the PoE injector into the **UPS**.
7. UniFi adopts the modem automatically. **Fine-tune the aim:** in UniFi Network, open the 5G device and watch RSRP and SINR while you rotate the mount about 10° at a time. Lock it down at the best **SINR**, not only the best RSRP.

### 6.3 Build B: mount the antennas and router
1. Mount the antennas on the pole, **all aimed at the tower.** For the 4x4 kit, follow Waveform's guide for spacing and polarization.
2. Run the coax to the house, add the **lightning arrestors** (grounded) at the entry point, and seal the wall pass-through.
3. Connect the four coax leads to the GL-X3000's four SMA ports, using the SMA adapters included in the kit.
4. Insert the Verizon SIM, power the router from the **UPS**, and finish setup at `http://192.168.8.1`.
5. In the GL.iNet admin page:
   - Set the **APN** if it doesn't pick one up automatically (Verizon business plans usually use `vzwinternet`, but use whatever Verizon tells you).
   - **Turn off its Wi-Fi.** The UDM network already handles Wi-Fi.
   - Enable **IP passthrough / bridge mode** if the firmware offers it, so the UDM gets the public-facing address and you avoid double NAT. If it doesn't, leaving it in router mode is fine for failover.
6. Connect the router's **LAN port** to the UDM Pro Max port you'll assign as **WAN2** (see [section 7](#7-configure-the-udm-pro-max)).
7. Fine-tune the aim while watching **SINR** on the GL.iNet **Cellular** page.

---

## 7. Configure the UDM Pro Max

> Menu names shift a little between UniFi Network versions. These steps follow the current layout under **Settings → Internet**.

### 7.1 Assign WAN2
- **Build A or C (UniFi 5G modem):** It shows up automatically under **Settings → Internet** as a mobile broadband WAN once adopted. No port reassignment is needed.
- **Build B (GL.iNet):** Go to **Settings → Internet → Create New / WAN2**. Choose the port the GL-X3000 is plugged into (a LAN port reassigned to WAN, or the second SFP+ WAN with an RJ45 SFP+ module). Set **IPv4 Connection: DHCP**.

### 7.2 Set failover
1. Go to **Settings → Internet → Multi-WAN** (or **WAN Load Balancing**, depending on version).
2. Set the mode to **Failover Only**.
3. Order the WANs as **Primary: Spectrum (WAN1)** and **Backup: Cellular (WAN2)**.

### 7.3 Tune health checks
- WAN monitoring pings targets to decide whether a link is up. Use **two reliable, independent targets**, such as `1.1.1.1` and `8.8.8.8`.
- Shorter intervals mean faster failover, but too short will make it **flap** (switch back and forth) during brief blips. Start with the defaults, test, then shorten if failover feels slow.

### 7.4 IPv6
- If WAN2 shows "connected" but traffic doesn't flow on IPv6, either **disable IPv6 on WAN2**, or set it to **SLAAC** (with **Prefix Delegation /56** if offered).

### 7.5 Optional: keep heavy traffic off the backup
- Under **Settings → Routing → Policy-Based Routes / Traffic Routes**, set NAS backups, game consoles, and UniFi Protect cloud uploads to use **WAN1 only** with failover **disabled**. They'll just wait until Spectrum is back instead of burning cellular data.
- Under **Settings → Internet → WAN2**, you can also set a **data limit / usage alert** if your version offers one.

### 7.6 Notifications
- Under **Settings → Notifications**, turn on alerts for **WAN failover / internet down** so you know when you're running on cellular (and spending data).

---

## 8. Test the failover

1. Start a test video call (for example, a Zoom test meeting or a call with a second device).
2. **Unplug the Spectrum coax** (or the Ethernet cable between the Spectrum modem and the UDM).
3. Time how long until the call reconnects. **Expect 5–60 seconds.**
4. Run a speed test on the backup. Target **3–5 Mbps or more** upload with no big latency spikes.
5. Plug Spectrum back in and confirm the UDM **fails back** to WAN1 (watch the **Internet** dashboard).
6. Do this again **in the evening,** when the cellular network is busiest.
7. Unplug the **power** to everything except the UPS to confirm the UPS keeps the whole chain up.

If the call quality on cellular is poor, revisit the antenna aim and height before anything else.

---

## 9. Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| Modem shows "no service" | SIM not activated, wrong APN, or IMEI not on the account | Call Verizon to confirm the line is active and the IMEI matches. Set APN. |
| Connected, but very slow | Low SINR (interference or a congested tower) | Re-aim for best **SINR**. Try locking to a different band or tower in the modem settings. Mount higher. |
| WAN2 "up" but no traffic | IPv6 route issue or double NAT quirks | Disable IPv6 on WAN2 (step 7.4). Use IP passthrough on the GL.iNet. |
| Keeps switching back and forth | Health checks too aggressive | Lengthen the monitor interval or add more ping targets. |
| 5G Max not adopting | No PoE or not enough PoE | Use an **802.3at (PoE+)** injector, and check the cable. |
| Data used up quickly | Background traffic on WAN2 | Add the WAN1-only routes in step 7.5. |

---

## 10. Why not the phone and booster plan?

The earlier plan (outdoor antenna → weBoost booster → spare phone → USB tether → GL.iNet travel router) is **not recommended**:
- A Spectrum Mobile hotspot gives only **5–10 GB** at full speed, which is a few hours of calls.
- It needs a dedicated phone and line. A phone left plugged in 24/7 risks **battery swelling**, and USB tethering often doesn't come back on its own after a reboot.
- A booster at −114 dBm may be marginal, and it costs as much as Build A.

A dedicated modem with an outdoor antenna and a proper backup SIM does the same job better and more reliably.

---

## 11. Sources

- Ubiquiti Store: [UniFi 5G Max Outdoor](https://store.ui.com/us/en/category/all-mobile/products/u5g-max-outdoor), [UniFi 5G Max](https://store.ui.com/us/en/category/all-mobile/products/u5g-max), [UniFi 5G Backup](https://store.ui.com/us/en/category/internet-solutions/products/u5g-us)
- Ubiquiti Tech Specs: [U5G-Max-Outdoor](https://techspecs.ui.com/unifi/integrations/u5g-max-outdoor) (14.5 W max, PoE powered)
- GL.iNet: [GL-X3000 Spitz AX](https://www.gl-inet.com/en-us/products/gl-x3000), [Waveform GL-X3000 antenna guide](https://www.waveform.com/guides/gl-inet-spitz-ax-gl-x3000nr)
- Waveform: [4x4 MIMO Log Periodic Kit](https://waveform.com/products/4x4-mimo-log-periodic-kit)
- Verizon: [Business Backup & Flexible Use flyer](https://www.verizon.com/business/resources/flyers/verizon-backup-and-flexible-use-promo-flyer-bm-061626-vzfl2730626.pdf), [LTE Business Internet plans](https://www.verizon.com/business/shop/products/networks/connectivity/lte-business-internet/plans), [Wi-Fi Backup](https://www.verizon.com/home/internet/wi-fi-backup/)
- Surge protector: [ETH-SP-G2 at CDW](https://www.cdw.com/product/ubiquiti-networks-eth-sp-g2-poe-surge-protector/5032008)
- UDM Pro Max specs (no PoE, 8x 1 GbE LAN, 2.5 GbE WAN, 2x SFP+): retailer spec sheets
- [CellMapper](https://www.cellmapper.net/map) for tower locations
- Planning context: [`wan-failover-context.md`](wan-failover-context.md)

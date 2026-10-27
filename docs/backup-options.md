# Choosing a Backup WAN

Cellular isn't the only way to fill WAN2. This page compares the common options so you can pick the right one before following the [cellular guide](../cellular-failover-guide.md).

> Prices are rough US figures as of late 2026. Check current pricing for your address.

## Quick comparison

| Option | Upfront | Monthly | Good for video calls? | Biggest catch |
|---|---|---|---|---|
| **Cellular modem + data SIM** | $130–900 | $20–30 idle, more during long outages | Yes, if signal is fair or better | Metered data; depends on local signal |
| **Starlink Mini / Standard on a full plan** | ~$150–350 | ~$55+ | Yes | Monthly cost; needs clear view of the sky |
| **Starlink on Standby Mode** | ~$150–350 | ~$5–10 | **No** (about 500 Kbps cap) | Only useful to keep the account alive |
| **Second wired ISP** (fiber, DSL, fixed wireless) | $0–100 | $30–70 | Yes | Often shares poles or conduit with the primary, so one storm can take out both |
| **Phone hotspot / tether** | $0 | Existing plan | Briefly | Small hotspot caps; must be switched on manually |

## Questions that decide it

1. **What's your cellular signal outdoors and up high?** Use the [signal survey worksheet](signal-survey-worksheet.md). Fair or better → cellular is usually cheapest. Poor → look at Starlink or a second ISP.
2. **How long are your typical outages?** Short (minutes to hours) → a small cellular data allowance is fine. Long (days) → you want unlimited data, either a plan that can be uncapped or Starlink.
3. **Do you have a clear view of the sky?** Starlink needs it. Trees and nearby buildings cause dropouts.
4. **Is a second wired ISP truly independent?** If it runs on the same poles as the primary, a downed line can take out both.
5. **Do calls need to survive the switch without dropping?** No UniFi failover does that on its own. You'd need a bonding service (for example, Speedify or Peplink SpeedFusion), and an employer VPN may not allow it.

## Things that apply to every option

- **Put everything on a UPS**: the ISP modem, the gateway, any PoE injector or switch, and the backup device. Most outages that matter come with a power cut.
- **Expect CGNAT on cellular and Starlink.** Inbound port forwarding and hosting a VPN server at home won't work over the backup. Use an overlay VPN such as Tailscale or WireGuard to a cloud server if you need remote access.
- **Expect a brief drop on failover.** The public IP changes, so active calls and VPNs reconnect. Plan on a few seconds up to about a minute.
- **Test it.** Use [`tools/failover-monitor.sh`](../tools/failover-monitor.sh) while unplugging the primary to see how long failover actually takes.

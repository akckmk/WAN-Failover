# WAN Failover

Guides and tools for adding a backup internet connection (WAN2) to a UniFi gateway, with a focus on keeping work-from-home video calls running when the primary ISP goes down.

## Start here

1. **Pick the type of backup:** [`docs/backup-options.md`](docs/backup-options.md) compares cellular, Starlink, a second wired ISP and phone tethering.
2. **Survey your signal** (for cellular): [`docs/signal-survey-worksheet.md`](docs/signal-survey-worksheet.md).
3. **Build it:** [`cellular-failover-guide.md`](cellular-failover-guide.md) covers hardware options with purchase links, data plans, installation, UniFi configuration and testing.
4. **Test it:** [`tools/failover-monitor.sh`](tools/failover-monitor.sh) logs outages and public-IP changes so you can time failover and failback.

## Failover monitor

```bash
chmod +x tools/failover-monitor.sh
./tools/failover-monitor.sh            # writes failover-YYYYMMDD-HHMMSS.log
# unplug the primary ISP, wait, plug it back in, then press Ctrl-C
```

It works on Linux and macOS (needs `ping` and `curl`). Settings can be changed with environment variables, for example `TARGETS="1.1.1.1 9.9.9.9" INTERVAL=2 ./tools/failover-monitor.sh`.

## Notes

- Prices and product links were checked in October 2026 and will drift. Verify before buying.
- Don't commit filled-in survey worksheets or monitor logs to a public repo. They can reveal your location and public IP addresses. `*.log` files are ignored by default.

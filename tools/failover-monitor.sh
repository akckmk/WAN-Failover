#!/usr/bin/env bash
# Logs connectivity and public-IP changes so you can measure how long WAN
# failover (and failback) actually takes.
#
# Usage: ./failover-monitor.sh [log-file]
#   Run it on a wired computer behind the gateway, then unplug the primary
#   ISP. Press Ctrl-C to stop; a summary of outages is printed on exit.
#
# Env overrides:
#   TARGETS="1.1.1.1 8.8.8.8"  hosts to ping (up if any reply)
#   INTERVAL=1                 seconds between checks
#   IP_EVERY=10                check the public IP every N checks
#   IP_URL=https://api.ipify.org

set -u

LOG="${1:-failover-$(date +%Y%m%d-%H%M%S).log}"
TARGETS="${TARGETS:-1.1.1.1 8.8.8.8}"
INTERVAL="${INTERVAL:-1}"
IP_EVERY="${IP_EVERY:-10}"
IP_URL="${IP_URL:-https://api.ipify.org}"

# Linux uses -W seconds; macOS uses -W milliseconds.
if [[ "$(uname)" == "Darwin" ]]; then PING_WAIT=1000; else PING_WAIT=1; fi

log() { printf '%s %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" | tee -a "$LOG"; }

is_up() {
  local t
  for t in $TARGETS; do
    ping -c 1 -W "$PING_WAIT" "$t" >/dev/null 2>&1 && return 0
  done
  return 1
}

public_ip() { curl -fsS --max-time 3 "$IP_URL" 2>/dev/null || echo "unknown"; }

state=""
down_since=0
outages=0
total_down=0
longest=0
last_ip=""
n=0

summary() {
  echo
  [[ "$state" == "down" ]] && log "STILL DOWN for $(( $(date +%s) - down_since ))s (not counted below)"
  log "SUMMARY outages=$outages total_down=${total_down}s longest=${longest}s"
  log "Log saved to $LOG"
  exit 0
}
trap summary INT TERM

log "START targets=[$TARGETS] interval=${INTERVAL}s"

while true; do
  now=$(date +%s)
  if is_up; then
    if [[ "$state" == "down" ]]; then
      dur=$((now - down_since))
      outages=$((outages + 1))
      total_down=$((total_down + dur))
      (( dur > longest )) && longest=$dur
      log "UP   after ${dur}s down"
      n=$IP_EVERY # check the IP right away; it usually changes on failover
    elif [[ -z "$state" ]]; then
      log "UP"
    fi
    state="up"

    if (( n % IP_EVERY == 0 )); then
      ip=$(public_ip)
      if [[ "$ip" != "unknown" && "$ip" != "$last_ip" ]]; then
        [[ -n "$last_ip" ]] && log "IP   changed $last_ip -> $ip (WAN switched)" || log "IP   $ip"
        last_ip=$ip
      fi
    fi
  else
    if [[ "$state" != "down" ]]; then
      down_since=$now
      log "DOWN"
    fi
    state="down"
  fi
  n=$((n + 1))
  sleep "$INTERVAL"
done

#!/bin/bash

HOST="${HOST:-http://localhost:80}"
PEAK2="${PEAK2:-100}"   # 2xx
PEAK4="${PEAK4:-60}"    # 4xx
PEAK5="${PEAK5:-25}"    # 5xx
STEP_SEC="${STEP_SEC:-5}"
STEPS="${STEPS:-10}"

fire() { for c in $(seq 1 "$1"); do curl -s -o /dev/null "$2" & done; }

# 10%..100%..10%
profile=()
for i in $(seq 1 $STEPS); do profile+=($i); done
for i in $(seq $STEPS -1 1); do profile+=($i); done

echo "Start: 2xx peak ${PEAK2}, 4xx peak ${PEAK4}, 5xx peak ${PEAK5} rps"

for k in "${profile[@]}"; do
    r2=$(( PEAK2 * k / STEPS ))
    r4=$(( PEAK4 * k / STEPS ))
    r5=$(( PEAK5 * k / STEPS ))
    echo "$(date +%T)  2xx:${r2}  4xx:${r4}  5xx:${r5}"
    for s in $(seq 1 $STEP_SEC); do
        fire $r2 "$HOST/load"          # → 200
        fire $r4 "$HOST/ping"          # → via rate limiter 429
        fire $r5 "$HOST/err"           # → 500
        fire 2   "$HOST/nonexistent"   # → 404
        wait
        sleep 1
    done
done

echo "Completed. Grafana → Last 15 minutes."
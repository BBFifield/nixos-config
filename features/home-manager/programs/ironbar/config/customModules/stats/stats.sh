#!/usr/bin/env bash

# Function to get CPU usage
get_cpu_usage() {
    top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}'
}

# Function to get memory usage
get_memory_usage() {
  local usage=$(free | grep Mem | awk '{print $3*0.000001"GB"}')
  local percentage=$(free | grep Mem | awk '{print $3/$2 * 100}')
  local formatted=$(printf "%.2fGiB (%.0f%%)" "$usage" "$percentage")
  echo $formatted
}

# Function to get disk usage
get_disk_usage() {
  disk_info=$(df -h -T --block-size=GiB | awk '$7 == "/"')
  echo "$disk_info" | awk '{used=$4; total=$3; usage=$6} END {printf "%s/%s (%s)", used, total, usage}'
}

get_gpu_attribute() {
  nvidia-smi --query-gpu=$1 --format=csv,noheader,nounits
}

get_uptime() {
  uptime | awk -F, '{ print $1 }' | awk '{print $NF}' | sed "s/,//" | awk -F: '{
    show_hours = false;
    if ($1 == 1) {
      printf "%s hour ", $1
      show_hours = true;
    }
    else if ($1 > 1) {
      printf "%s hours ", $1
      show_hours = true;
    }
    if ($2 == 1) {
      printf "%s minute", $2
    }
    else if ($2 > 1) {
      printf "%s minutes", $2
    }
    else if ($2 == 0 && show_hours == false) {
      printf "%s minutes", $2
    }
  }'
}
#%s hours 2
# Main monitoring function
monitor_system() {
  while :; do
    local cpu_usage=$(get_cpu_usage)
    local memory_usage=$(get_memory_usage)
    local disk_usage=$(get_disk_usage)
    local gpu_usage=$(get_gpu_attribute utilization.gpu)
    local gpu_memory_used=$(get_gpu_attribute memory.used | awk '{printf "%.1f", $1/1000}')
    local gpu_memory_total=$(get_gpu_attribute memory.total | awk '{printf "%.1f", $1/1000}')
    local gpu_temp=$(get_gpu_attribute temperature.gpu)

    ironbar var set cpu_stats "$(printf "%s\n" "$cpu_usage")" &> /dev/null
    ironbar var set ram_stats "$(printf "%s\n" "$memory_usage")" &> /dev/null
    ironbar var set disk_stats "$(printf "%s\n" "$disk_usage")" &> /dev/null
    ironbar var set gpu_stats "$(printf "%s%% | %sGiB/%sGiB | %s°C" "$gpu_usage" "$gpu_memory_used" "$gpu_memory_total" "$gpu_temp")" &> /dev/null
    ironbar var set uptime_stats "$(printf "%s\n" "$(get_uptime)")" &> /dev/null
    sleep 5
  done
}

# Run the monitoring function
monitor_system

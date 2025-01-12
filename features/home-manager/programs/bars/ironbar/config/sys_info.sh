distro_name_version="$(grep -w "PRETTY_NAME" "/etc/os-release" | cut -d '=' -f 2 | tr -d '"')"
build_id=$(grep -w "BUILD_ID" "/etc/os-release" | cut -d '=' -f 2 | tr -d '"')
kernel_version=$(uname -r)
hostname=$(hostname)
# Count the number of installed packages globally
num_packages=$(for x in $(nix-store --query --requisites /run/current-system); do if [ -d $x ]; then echo $x ; fi ; done | cut -d- -f2- | egrep '([0-9]{1,}\.)+[0-9]{1,}' | egrep -v '\-doc$|\-man$|\-info$|\-dev$|\-bin$|^nixos-system-nixos' | uniq | wc -l)
local_ip=$(ip addr show | grep "inet " | grep -v "127.0.0.1" | awk '{print $2}')
pub_ip=$(curl ifconfig.me)
root_partition_info=$(df -h -T | awk '$7 == "/"' | awk '{label=$1; type=$2} END {printf "%s (%s)", label, type}') &> /dev/null
cpu_info=$(echo lscpu)
cpu_model=$("$cpu_info" | awk -F: '/Model name/ {gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2; exit }')
cpu_frequency=$("$cpu_info" | awk -F: '/CPU max MHz/ {gsub(/^[ \t]+|[ \t]+$/, "",$2); printf "%.2f GHz", $2 /1000; exit }')
gpu_name=$(nvidia-smi --query-gpu=name --format=csv,noheader)
gpu_driver_version=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader)

set_ironvars() {
  ironbar var set root_partition_info "$root_partition_info" &> /dev/null
  ironbar var set cpu_info "$cpu_model @ $cpu_frequency" &> /dev/null
  ironbar var set gpu_info "$gpu_name ($gpu_driver_version)" &> /dev/null
}

print_sys_info() {
  printf "%s\n" "$distro_name_version"
  printf "%s\n" "$build_id"
  printf "%s\n" "$kernel_version"
  printf "%s\n" "$hostname"
  printf "%s (nix-system)\n" "$num_packages"
  printf "%s\n" "$local_ip"
  printf "%s\n" "$pub_ip"
}

print_sys_info
set_ironvars

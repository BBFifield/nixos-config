distro_name_version="$(grep -w "NAME" "/etc/os-release" | cut -d '=' -f 2) $(grep -w "VERSION_ID" "/etc/os-release" | cut -d '=' -f 2 | tr -d '"')"
build_id=$(grep -w "BUILD_ID" "/etc/os-release" | cut -d '=' -f 2 | tr -d '"')
kernel_version=$(uname -r)
hostname=$(hostname)


print_sys_info() {
  printf "Distro: %s\nBuild: %s\nKernel: %s\nHostname: %s" "$distro_name_version" "$build_id" "$kernel_version" "$hostname"
}

print_sys_info

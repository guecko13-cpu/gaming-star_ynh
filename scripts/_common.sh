#!/bin/bash

set -euo pipefail

source /usr/share/yunohost/helpers

app="${app:-casino-games-fun}"

load_settings() {
    domain=$(ynh_app_setting_get --app="$app" --key=domain)
    path=$(ynh_app_setting_get --app="$app" --key=path)
    install_dir=$(ynh_app_setting_get --app="$app" --key=install_dir)
    data_dir=$(ynh_app_setting_get --app="$app" --key=data_dir)
    port=$(ynh_port_get --app="$app" --port=main)
}

load_settings_allow_missing() {
    domain=$(ynh_app_setting_get --app="$app" --key=domain || true)
    path=$(ynh_app_setting_get --app="$app" --key=path || true)
    install_dir=$(ynh_app_setting_get --app="$app" --key=install_dir || true)
    data_dir=$(ynh_app_setting_get --app="$app" --key=data_dir || true)
    port=$(ynh_port_get --app="$app" --port=main || true)
}

ensure_env_file() {
    local env_file="$data_dir/.env"
    local jwt_secret

    if [ -f "$env_file" ]; then
        return
    fi

    jwt_secret=$(ynh_pwgen --length=48)
    mkdir -p "$data_dir"

    cat <<EOF_ENV > "$env_file"
NODE_ENV=production
PORT=${port}
JWT_SECRET=${jwt_secret}
DATABASE_URL=sqlite:${data_dir}/database.sqlite
EOF_ENV

    chmod 600 "$env_file"
    chown "$app":"$app" "$env_file"
}

sync_static_assets() {
    local frontend_dist="$install_dir/frontend/dist"
    local admin_dist="$install_dir/admin/dist"

    if [ ! -d "$frontend_dist" ]; then
        ynh_print_err "Missing frontend assets in ${frontend_dist}."
        ynh_die --message="Frontend assets not found. Provide prebuilt dist in the upstream tarball."
    fi

    if [ ! -d "$admin_dist" ]; then
        ynh_print_err "Missing admin assets in ${admin_dist}."
        ynh_die --message="Admin assets not found. Provide prebuilt dist in the upstream tarball."
    fi

    mkdir -p "$install_dir/www" "$install_dir/www-admin"

    rsync -a --delete "${frontend_dist}/" "$install_dir/www/"
    rsync -a --delete "${admin_dist}/" "$install_dir/www-admin/"
}

check_health() {
    local health_url="http://127.0.0.1:${port}/api/health"

    if ! curl -fsS "$health_url" > /dev/null; then
        ynh_print_err "Healthcheck failed on ${health_url}."
        ynh_die --message="Backend did not respond to healthcheck."
    fi
}

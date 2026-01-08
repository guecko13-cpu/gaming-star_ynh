#!/bin/bash

set -euo pipefail

source /usr/share/yunohost/helpers

app="${app:-gaming-star}"

UPSTREAM_REPO="guecko13-cpu/gaming-star"
UPSTREAM_REF="v1.0.0"
UPSTREAM_SHA256=""

install_dir=$(ynh_app_setting_get --app="$app" --key=install_dir || true)
data_dir=$(ynh_app_setting_get --app="$app" --key=data_dir || true)

ensure_github_token() {
    local github_token
    github_token=$(ynh_app_setting_get --app="$app" --key=github_token || true)
    if [ -z "$github_token" ]; then
        ynh_print_warn "Repo privé: fournir github_token lors de l'installation/upgrade."
        return 1
    fi
}

download_upstream() {
    local github_token
    local tmp_src
    github_token=$(ynh_app_setting_get --app="$app" --key=github_token || true)
    if [ -z "$github_token" ]; then
        ynh_print_warn "Repo privé: fournir github_token lors de l'installation/upgrade."
        return 1
    fi

    tmp_src=$(mktemp -d)
    ynh_print_info "Téléchargement des sources gaming-star (ref: ${UPSTREAM_REF})."

    set +x
    curl -sSL -H "Authorization: token ${github_token}" \
        "https://api.github.com/repos/${UPSTREAM_REPO}/tarball/${UPSTREAM_REF}" \
        -o "${tmp_src}/src.tgz"
    set +x

    if [ -n "$UPSTREAM_SHA256" ]; then
        echo "${UPSTREAM_SHA256}  ${tmp_src}/src.tgz" | sha256sum -c -
    fi

    echo "$tmp_src"
}

install_sources() {
    local tmp_src
    tmp_src=$(download_upstream)
    mkdir -p "$install_dir"
    tar -xzf "${tmp_src}/src.tgz" -C "$tmp_src"
    local extracted
    extracted=$(find "$tmp_src" -maxdepth 1 -mindepth 1 -type d | head -n1)
    rsync -a --delete "${extracted}/" "$install_dir/"
    rm -rf "$tmp_src"
}

create_config() {
    local config_dir
    config_dir="$data_dir/config"
    mkdir -p "$config_dir"

    cat <<EOF_CONFIG > "$config_dir/app.conf.php"
<?php
return [
    'db_name' => '${db_name}',
    'db_user' => '${db_user}',
    'db_pass' => '${db_pwd}',
    'db_host' => 'localhost',
    'base_url' => 'https://${domain}${path}',
];
EOF_CONFIG
}

link_config() {
    mkdir -p "$install_dir/config"
    ln -sfn "$data_dir/config/app.conf.php" "$install_dir/config/app.conf.php"
}

write_metadata() {
    local metadata_file
    metadata_file="$data_dir/config/maintenance.json"
    cat <<EOF_META > "$metadata_file"
{
  "package_version": "${package_version}",
  "upstream_ref": "${UPSTREAM_REF}"
}
EOF_META
}

setup_logrotate() {
    ynh_config_add --template="conf/logrotate" --destination="/etc/logrotate.d/${app}"
}

setup_sudoers() {
    ynh_config_add --template="conf/sudoers" --destination="/etc/sudoers.d/${app}"
    chmod 440 "/etc/sudoers.d/${app}"
}

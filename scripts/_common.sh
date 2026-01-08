#!/bin/bash

set -euo pipefail

source /usr/share/yunohost/helpers

app="${app:-gaming-star}"

install_dir=$(ynh_app_setting_get --app="$app" --key=install_dir || true)
data_dir=$(ynh_app_setting_get --app="$app" --key=data_dir || true)

load_settings() {
    domain=$(ynh_app_setting_get --app="$app" --key=domain)
    path=$(ynh_app_setting_get --app="$app" --key=path)
    upstream_repo=$(ynh_app_setting_get --app="$app" --key=upstream_repo)
    upstream_ref=$(ynh_app_setting_get --app="$app" --key=upstream_ref)
    package_repo_url=$(ynh_app_setting_get --app="$app" --key=package_repo_url)
    github_token=$(ynh_app_setting_get --app="$app" --key=github_token)
    db_name=$(ynh_app_setting_get --app="$app" --key=db_name)
    db_user=$(ynh_app_setting_get --app="$app" --key=db_user)
    db_pwd=$(ynh_app_setting_get --app="$app" --key=db_pwd)
}

ensure_github_token() {
    if [ -z "${github_token:-}" ]; then
        ynh_print_err "Repo privé: fournir github_token pour télécharger les sources."
        ynh_die --message="Repo privé: fournir github_token"
    fi
}

download_upstream() {
    local repo="$1"
    local ref="$2"
    local token="$3"
    local tmp_src

    if [ -z "$token" ]; then
        ynh_print_err "Repo privé: fournir github_token pour télécharger les sources."
        return 1
    fi

    tmp_src=$(mktemp -d)
    ynh_print_info "Téléchargement des sources gaming-star (${repo}@${ref})."

    set +x
    curl -fsSL -H "Authorization: Bearer ${token}" \
        "https://api.github.com/repos/${repo}/tarball/${ref}" \
        -o "${tmp_src}/src.tgz"
    set +x

    echo "$tmp_src"
}

install_sources() {
    local tmp_src
    local extracted
    local staging_dir

    tmp_src=$(download_upstream "$upstream_repo" "$upstream_ref" "$github_token")
    mkdir -p "$install_dir"

    tar -xzf "${tmp_src}/src.tgz" -C "$tmp_src"
    extracted=$(find "$tmp_src" -maxdepth 1 -mindepth 1 -type d | head -n1)

    staging_dir=$(mktemp -d)
    rsync -a \
        --exclude="maintenance" \
        --exclude="config" \
        "${extracted}/" "$staging_dir/"

    rsync -a --delete \
        --exclude="maintenance" \
        --exclude="config" \
        "${staging_dir}/" "$install_dir/"

    rm -rf "$tmp_src" "$staging_dir"
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
  "upstream_repo": "${upstream_repo}",
  "upstream_ref": "${upstream_ref}"

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

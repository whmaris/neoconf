#!/usr/bin/env bash
set -euo pipefail

REPO="$HOME/neoconf/nixos/.config"
CONFIG="$HOME/.config"

link_config() {
    local app="$1"
    local source="$CONFIG/$app"
    local target="$REPO/$app"

    # Đã link đúng từ lần trước
    if [[ -L "$source" ]] &&
       [[ "$(readlink -f "$source")" == "$(readlink -m "$target")" ]]; then
        echo "[INFO]: $app linked"
        return 0
    fi

    # Xóa cấu hình cũ nếu tồn tại
    if [[ -e "$source" || -L "$source" ]]; then
        rm -rf "$source"
    fi

    # Tạo thư mục đích nếu chưa có
    mkdir -p "$target"

    # Tạo symlink
    ln -s "$target" "$source"

    echo "[SUCCESS]: $app linked success"
}

link_config ghostty
link_config umbriel
link_config noctalia
link_config greeter
link_config zed
link_config yazi

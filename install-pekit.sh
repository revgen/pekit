#!/usr/bin/env bash
set -euo pipefail

bin_dir="${HOME}/.local/bin"
task_bin="${bin_dir}/task"
if [[ ! -e "${task_bin}" ]]; then
    task_bin="$(type -P task || true)"
fi

release_url="$(curl -fsSLI -o /dev/null -w '%{url_effective}' https://github.com/go-task/task/releases/latest)"
tag="${release_url##*/}"
if [[ ! "${tag}" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Could not determine the latest Task release." >&2
    exit 1
fi
latest="${tag#v}"
prompt="Install Task ${tag}"

if [[ -n "${task_bin}" ]]; then
    output="$("${task_bin}" --version)"
    # Older releases include a label. Newer ones may print just the version.
    if [[ "${output}" != "Task version: "* ]]; then
        help_text="$("${task_bin}" --help 2>&1)" || true
        if [[ "${help_text}" != *--taskfile* ]]; then
            echo "${task_bin} is an unrecognized task command." >&2
            exit 1
        fi
    fi
    output="${output#Task version: }"
    if [[ ! "${output}" =~ ^v?([0-9]+\.[0-9]+\.[0-9]+)(-[^[:space:]+]+)?([+[:space:]]|$) ]]; then
        echo "Could not identify the Go Task version at ${task_bin}." >&2
        exit 1
    fi
    current="${BASH_REMATCH[1]}"
    prerelease="${BASH_REMATCH[2]:-}"
    oldest="$(printf '%s\n' "${current}" "${latest}" | sort -t. -k1,1n -k2,2n -k3,3n | head -n 1)"
    if [[ "${oldest}" != "${current}" || ( "${current}" == "${latest}" && -z "${prerelease}" ) ]]; then
        echo "Task v${current}${prerelease} is up to date (${task_bin})."
        exit 0
    fi
    prompt="Update Task from v${current}${prerelease} to ${tag}"
fi

printf '%s in %s? [y/N] ' "${prompt}" "${bin_dir}"
read -r answer || exit 0
case "${answer}" in
    [yY]|[yY][eE][sS]) ;;
    *) exit 0 ;;
esac

mkdir -p "${bin_dir}"
installer="$(curl -fsSL https://taskfile.dev/install.sh)"
sh -c "${installer}" -- -b "${bin_dir}" "${tag}"
"${bin_dir}/task" --version
if [[ "$(type -P task || true)" != "${bin_dir}/task" ]]; then
    echo 'To use this copy, run: export PATH="${HOME}/.local/bin:${PATH}"'
fi
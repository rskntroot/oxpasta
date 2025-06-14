#!/bin/sh

# Exit codes
EXIT_OK=0
EXIT_GENERIC=1
EXIT_ARG_MISSING=64
EXIT_INVALID_OPTION=65
EXIT_INVALID_URL=69
EXIT_DEP_MISSING=71
EXIT_FILE_ERROR=74
EXIT_ENV_MISSING=78

# Display help message
show_help() {
  cat <<EOF
Usage: oxpasta [OPTION] FILE

Options:
  [none]             {file}   Upload a file
  -o, --oneshot      {file}   Upload a file as a oneshot link
  -s, --shorten-url  {url}    Shorten a given URL
  -h, --help                  Display this help message

Description:
  minimal rustypaste cli script

Requires:
  export OXP_SERVER="https://example.com"

Examples:
  oxpasta /path/to/file
    | Uploads the file located at /path/to/file
  oxpasta -o /path/to/file
    | Uploads the oneshot URL https://example.com
  oxpasta -s https://example.com/long/url
    | Shortens the URL to https://<server>/<some-text>
EOF
}

# check for curl command

if ! type curl >/dev/null 2>&1; then
  echo "Error: 'curl' is not installed or not in PATH." >&2
  show_help
  exit ${EXIT_DEP_MISSING}
fi

# check for OXP_SERVER env var

if [ -z "${OXP_SERVER}" ]; then
  echo "Error: OXP_SERVER environment variable is not set." >&2
  exit ${EXIT_ENV_MISSING}
fi

# functions

oneshot_upload() {
  file="$1"
  if [ -z "${file}" ]; then
      echo "Error: You must provide a file for --oneshot." >&2
    exit ${EXIT_ARG_MISSING}
  fi
  curl -fsS -F "oneshot=@${file}" "${OXP_SERVER}"
}

shorten_url() {
  long_url="$1"
  if [ -z "${long_url}" ]; then
    echo "Error: You must provide a URL for --shorten-url." >&2
    exit ${EXIT_ARG_MISSING}
  fi
  if ! curl -fsS -I --location "${long_url}" >/dev/null 2>&1; then
    echo "Error: URL appears to be invalid or not accessible." >&2
    exit ${EXIT_INVALID_URL}
  fi
  curl -fsS -F "url=${long_url}" "${OXP_SERVER}"
}

file_upload() {
  file="$1"
  if [ -z "${file}" ]; then
    echo "Error: No file provided for upload." >&2
    exit ${EXIT_ARG_MISSING}
  elif [ ! -f "${file}" ]; then
    echo "Error: File '${file}' not found." >&2
    exit ${EXIT_FILE_ERROR}
  fi
  curl -fsS -F "file=@${file}" "${OXP_SERVER}"
}

# argument dispatch

case "$1" in
  -h|--help)
    show_help
    ;;
  -o|--oneshot)
    shift
    oneshot_upload "$1"
    ;;
  -s|--shorten-url)
    shift
    shorten_url "$1"
    ;;
  -*)
    echo "Unknown option: $1" >&2
    exit ${EXIT_INVALID_OPTION}
    ;;
  *)
    file_upload "$1"
    ;;
esac

exit ${EXIT_OK}

#`lost`25my

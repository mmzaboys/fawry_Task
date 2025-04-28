#!/bin/bash

show_help() {
    echo "Usage: $0 [OPTIONS] SEARCH_STRING FILENAME"
    echo
    echo "Options:"
    echo "  -n, --line-numbers  Show line numbers with output lines"
    echo "  -v, --invert-match  Invert match (show non-matching lines)"
    echo "  -h, --help          Display this help and exit"
    exit 0
}

[ $# -eq 0 ] && { echo "Error: No arguments provided." >&2; show_help; exit 1; }

show_line_numbers=false
invert_match=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) show_help ;;
        -[nv]*)
            [[ "$1" == *n* ]] && show_line_numbers=true
            [[ "$1" == *v* ]] && invert_match=true
            shift
            ;;
        -n|--line-numbers) show_line_numbers=true; shift ;;
        -v|--invert-match) invert_match=true; shift ;;
        -*)
            echo "Error: Unknown option $1" >&2
            show_help
            exit 1
            ;;
        *)
            if [ -z "$search_string" ]; then
                search_string="$1"
            else
                [ -z "$file" ] && file="$1" || { echo "Error: Too many arguments" >&2; show_help; exit 1; }
            fi
            shift
            ;;
    esac
done

[ -z "$search_string" ] && { echo "Error: Missing search string" >&2; show_help; exit 1; }
[ -z "$file" ] && { echo "Error: Missing filename" >&2; show_help; exit 1; }
[ ! -f "$file" ] && { echo "Error: File '$file' not found." >&2; exit 1; }

line_number=0
while IFS= read -r line; do
    ((line_number++))
    if echo "$line" | grep -iq "$search_string"; then
        $invert_match && continue
    else
        $invert_match || continue
    fi
    $show_line_numbers && printf "%d:%s\n" "$line_number" "$line" || printf "%s\n" "$line"
done < "$file"
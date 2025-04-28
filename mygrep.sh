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

if [ $# -eq 0 ]; then
    echo "Error: No arguments provided." >&2
    show_help
    exit 1
fi

show_line_numbers=false
invert_match=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_help
            ;;
        -n|--line-numbers)
            show_line_numbers=true
            shift
            ;;
        -v|--invert-match)
            invert_match=true
            shift
            ;;
        -*)
            echo "Error: Unknown option $1" >&2
            show_help
            exit 1
            ;;
        *)
            if [ -z "$search_string" ]; then
                search_string="$1"
            else
                if [ -z "$file" ]; then
                    file="$1"
                else
                    echo "Error: Too many arguments" >&2
                    show_help
                    exit 1
                fi
            fi
            shift
            ;;
    esac
done

if [ -z "$search_string" ]; then
    echo "Error: Missing search string" >&2
    show_help
    exit 1
fi

if [ -z "$file" ]; then
    echo "Error: Missing filename" >&2
    show_help
    exit 1
fi

if [ ! -f "$file" ]; then
    echo "Error: File '$file' not found." >&2
    exit 1
fi

line_number=0
while IFS= read -r line; do
    line_number=$((line_number + 1))
    
    if echo "$line" | grep -iq "$search_string"; then
        matched=true
    else
        matched=false
    fi

    if $invert_match; then
        matched=$(! $matched)
    fi

    if $matched; then
        if $show_line_numbers; then
            printf "%d:%s\n" "$line_number" "$line"
        else
            printf "%s\n" "$line"
        fi
    fi
done < "$file"
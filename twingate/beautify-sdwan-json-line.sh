ESCAPED_STR=$(~/dev-newton/scripts/escape_str.py --input "${1}")
MODULE_NAME=$(echo "${1}" | awk -F '[:=\ ]' '{print $1}')

#echo "\"${ESCAPED_STR}\", \"${MODULE_NAME}\"" 1 >&2
~/dev-newton/scripts/search_and_replace.py --search "^\[.*\] ${ESCAPED_STR}(.*)" --cmd "echo '{MATCH}' | ~/dev-newton/scripts/search_and_replace.py --search \' | jq | fold -w 80 | tr '\n' '\\' | sed 's/\\\\/\\\\n/g' " \
| ~/dev-newton/scripts/search_and_replace.py --search "^(\[.*\]) ${ESCAPED_STR}(.*)"  --replace "note over ${MODULE_NAME}:\2: \\\\n \1"


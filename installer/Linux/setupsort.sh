#!/bin/bash
shopt -s globstar

# solve dependency of each installer
apps=() # app depends on other apps
app_required=()
for f in setup-*.sh;
do
  app_name="${f#setup-}"
  app_name="${app_name%.sh}"
  # get required app_name
  # if the file contains "require:" line, get the app_name
  if grep -q "^# *require:" "$f"; then
    for rapp in $(grep -m 1 "^# *require:" "$f" | sed -e "s/^# *require: *//" | tr -s ' ' | tr ' ' '\n' | awk NF); do
      app_required=("${app_required[@]}" "$app_name $rapp")
    done
  else
    app_required=("${app_required[@]}" "$app_name __none__")
  fi
done
# print app_required as new line separated file
while read -r line; do
  if [[ "$line" != "__none__" ]]; then
    apps=("$line" "${apps[@]}")
  fi
done < <(for l in "${app_required[@]}";do echo "$l";done | tsort)

for l in "${apps[@]}";do echo "$l";done

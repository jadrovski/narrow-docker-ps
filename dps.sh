#!/bin/bash

placeholders_input="ID,Names,Ports,Status,State,Image"
IFS=',' read -r -a placeholders_array <<<"${placeholders_input}"

placeholders_format=$(printf ";{{.%s}}" "${placeholders_array[@]}")
placeholders_format=${placeholders_format:1}

mapfile -t docker_ps_output < <(docker ps --format "table $placeholders_format")

out_array=("${docker_ps_output[0]}")

for ((i = 1; i < ${#docker_ps_output[@]}; i++)); do
  IFS=';' read -r -a docker_ps_row_array <<<"${docker_ps_output[$i]}"
  row_array=()

  ports_ext_array=()
  ports_idx=0
  row_length=${#docker_ps_row_array[@]}

  for ((j = 0; j < $row_length; j++)); do
    if [[ ${placeholders_array[$j]} == "Ports" ]]; then
      IFS=',' read -r -a ports_array <<<"${docker_ps_row_array[$j]}"
      ports_count=${#ports_array[@]}
      if [ $ports_count -gt 1 ]; then
        ports_ext_array=("${ports_array[@]}")
        row_array+=("${ports_array[0]}")
        ports_idx=$j
      else
        row_array+=("${docker_ps_row_array[$j]}")
      fi
    else
      row_array+=("${docker_ps_row_array[$j]}")
    fi
  done

  out_item=$(printf ";%s" "${row_array[@]}")
  out_item=${out_item:1}
  out_array+=("$out_item")

  for ((p = 1; p < ${#ports_ext_array[@]}; p++)); do
    port=${ports_ext_array[$p]}
    before=$(for ((b = 0; b < $ports_idx; b++)); do printf "%s" ";"; done)
    after=$(for ((a = $ports_idx + 1; a < $row_length; a++)); do printf "%s" ";"; done)
    out_array+=("$before$(echo $port)$after")
  done

  out_array+=(";")
done

# we need to add `-n` argument to `column` (only for BSD version of program) to format columns well
if (column -V 2>&1 | (grep -q "invalid")); then
  bsd_column=true
fi

(for ((z = 0; z < ${#out_array[@]}; z++)); do
  echo ${out_array[$z]}
done) | column -s ";" -t ${bsd_column:+-n}

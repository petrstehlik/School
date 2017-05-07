#!/bin/bash
for file in test/*.gif; do
    [ -e "$file" ] || continue
    # ... rest of the loop body

    echo $file

    `./gif2bmp -i $file -o output/$file`
done

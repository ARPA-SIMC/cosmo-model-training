#!/bin/sh

# Create index page for github
exec 1>README.md

cat README-pre.nomd

start=components.md
n=1
while true; do

    title=`sed -n -e '1{ s/^## \(.*\)$/\1/p}' $start`
    next=`sed -n -e 's/^\[next\](\(.*\))$/\1/p' $start`
    echo "$n. [$title]($start)"
    if [ -z "$next" ]; then
	break
    fi
    
    start=$next
    n=$(($n+1))
done

cat README-post.nomd

# Create index page for mkdocs
exec 1>index.md
cat README-pre.nomd
cat ../README.md
cat README-post.nomd

# Create mkdocs configuration
exec 1>../mkdocs.yml

cat <<EOF
docs_dir: ./doc
extra_css: ['https://media.readthedocs.org/css/badge_only.css', 'https://media.readthedocs.org/css/readthedocs-doc-embed.css']
extra_javascript: [readthedocs-data.js, 'https://media.readthedocs.org/static/core/js/readthedocs-doc-embed.js',
  'https://media.readthedocs.org/javascript/readthedocs-analytics.js']
google_analytics: null
site_name: cosmo-model-training
EOF




echo "pages:"
echo "- Index: 'index.md'"
start=components.md
while true; do

    title=`sed -n -e '1{ s/^## \(.*\)$/\1/p}' $start`
    next=`sed -n -e 's/^\[next\](\(.*\))$/\1/p' $start`
    echo "- $title: '$start'"
    if [ -z "$next" ]; then
	break
    fi
    
    start=$next
done

echo "- Rotated grid: 'rotated_grid.md'"

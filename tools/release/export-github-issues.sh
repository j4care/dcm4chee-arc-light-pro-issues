#!/bin/bash

if [[ $# != 2 ]]; then
    echo "usage: $0 {start yyyy-mm-dd} {end yyyy-mm-dd}"
    exit 1
fi

start_date=$1; shift
end_date=$1; shift

# os issues
curl -H "Accept: application/vnd.github+json" "https://api.github.com/repos/dcm4che/dcm4chee-arc-light/issues?state=closed&since=${start_date}T00:00:00:00Z&per_page=100" --output /tmp/os-all-issues.json
curl -H "Accept: application/vnd.github+json" "https://api.github.com/repos/dcm4che/dcm4chee-arc-light/issues?state=closed&since=${end_date}T00:00:00:00Z&per_page=100" --output /tmp/os-later-issues.json

cat /tmp/os-all-issues.json | jq '.[] | "- [#\(.number) - \(.title)](https://github.com/dcm4che/dcm4chee-arc-light/issues/\(.number))"' --raw-output | sort > /tmp/os-all-issues.md
cat /tmp/os-later-issues.json | jq '.[] | "- [#\(.number) - \(.title)](https://github.com/dcm4che/dcm4chee-arc-light/issues/\(.number))"' --raw-output | sort > /tmp/os-later-issues.md

# pro issues
curl -H "Accept: application/vnd.github+json" "https://api.github.com/repos/j4care/dcm4chee-arc-light-pro-issues/issues?state=closed&since=${start_date}T00:00:00:00Z&per_page=100" --output /tmp/pro-all-issues.json
curl -H "Accept: application/vnd.github+json" "https://api.github.com/repos/j4care/dcm4chee-arc-light-pro-issues/issues?state=closed&since=${end_date}T00:00:00:00Z&per_page=100" --output /tmp/pro-later-issues.json

cat /tmp/pro-all-issues.json | jq '.[] | "- [#pro-\(.number) - \(.title)](https://github.com/j4care/dcm4chee-arc-light-pro-issues/issues/\(.number))"' --raw-output | sort > /tmp/pro-all-issues.md
cat /tmp/pro-later-issues.json | jq '.[] | "- [#pro-\(.number) - \(.title)](https://github.com/j4care/dcm4chee-arc-light-pro-issues/issues/\(.number))"' --raw-output | sort > /tmp/pro-later-issues.md

# outputs
echo "os issues:"
comm -2 -3 /tmp/os-all-issues.md /tmp/os-later-issues.md | sort -r

echo "pro issues:"
comm -2 -3 /tmp/pro-all-issues.md /tmp/pro-later-issues.md | sort -r

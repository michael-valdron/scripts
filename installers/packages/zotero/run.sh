#!/bin/bash

bash -c "$(dirname $(realpath $(echo %k | sed -e 's/^file:\\//')))/zotero -url %U"

#!/bin/bash
git push &&
git annex copy --to=storage-bup --not --in=storage-bup -J4 &&
git submodule foreach --recursive '[[ $toplevel == *profession/my-projects* ||
                                      $toplevel == *profession/resources ||
                                      $toplevel == *sysconfigs/vim/bundle* ]] && exit 0 || { git push; if [[ -d .git/annex ]]; then
                                          git annex copy --to=storage-bup --not --in=storage-bup -J4; else exit 0; fi; }'

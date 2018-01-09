#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# vim:fileencoding=utf-8
from urllib.request import urlopen, Request
from time import sleep
import shlex
import sys
from logging import basicConfig, getLogger, INFO

def get_page(url):
    req = Request(url)
    req.add_header("User-Agent",
                   "Mozilla/5.0 (X11; Fedora; Linux x86_64) "
                   "AppleWebKit/537.36 (KHTML, like Gecko) "
                   "Chrome/59.0.3071.109 Safari/537.36")
    with urlopen(req) as response:
        page = response.read().decode("utf-8")
    return page

def bookable(page):
    return "canbook" in page or "loading" not in page

def main():
    basicConfig(
        format='%(asctime)s [%(levelname)s] %(lineno)d:%(funcName)s: %(message)s',
        level=INFO)
    logger = getLogger()
    url = sys.argv[1]
    while True:
        page = get_page(url)
        if bookable(page):
            logger.warning("page size %d, bookable NOW...", len(page))
        else:
            logger.info("page size %d, not bookable yet...", len(page))
        sleep(60)

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        pass

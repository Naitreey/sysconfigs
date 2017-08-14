#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# vim:fileencoding=utf-8
from urllib.request import urlopen, Request
from time import sleep
from subprocess import run
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
    return "other-canbook" in page or "other-loading" not in page

def notify(count):
    run(shlex.split("notify-send -u 'critical' -t 60000 -i "
                    "/home/naitree/mystuff/security-info/avatar/avatar.jpg "
                    f"'速度订房子 {count}'"),
        check=True)

def main():
    basicConfig(
        format='%(asctime)s [%(levelname)s] %(lineno)d:%(funcName)s: %(message)s',
        level=INFO)
    logger = getLogger()
    url = sys.argv[1]
    notified_times = 0
    while True:
        page = get_page(url)
        if bookable(page):
            notified_times += 1
            notify(notified_times)
            logger.warning("page size %d, bookable NOW...", len(page))
        else:
            logger.info("page size %d, not bookable yet...", len(page))
        sleep(60)

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        pass

#!/usr/bin/env python

import sys
from bom import boms
from sheets import sheets
from stls import stls
from plates import plates

def make_machine(machine):
    print("boms.py:")
    boms(machine)
    print("sheets.py:")
    sheets(machine)
    print("stls.py:")
    stls(machine)
    #print("plates.py:")
    #plates(machine)

if __name__ == '__main__':
    if len(sys.argv) > 1:
        make_machine(sys.argv[1])
    else:
        print("usage: make_machine [mendel|sturdy|your_machine]")
        sys.exit(1)

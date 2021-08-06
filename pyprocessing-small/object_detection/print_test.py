import sys
import time

print("Begin Test!")
while True:
    print("Print Tick!")
    print("Error Tick!", file=sys.stderr)
    # time.sleep(0.1)

import time
bar_len = 24
elements = ['|', '/', '-', '\\']

for i in range(bar_len + 1):
    frame = i % len(elements)
    print(f'r[{elements[frame]*i:=<{bar_len}}]', end='')   
    time.sleep(0.2)

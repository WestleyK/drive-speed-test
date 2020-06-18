## Drive speed test - for raspberry pi

Test the read and write speed of your external drive through the Terminal. This is designed and tested on raspberry pi.

## Download and install:

Download if you did not already:

```
$ git clone https://github.com/WestleyK/drive-speed-test.git
```

Then put the `drive-speed-test.sh` in your home directory, or whatever you want:

```
$ cp drive-speed-test/drive-speed-test.sh ~/
```

## How to use it:

To run it, just invoke the script:

```
$ ./drive-speed-test.sh
```

Then type the number that correspond with the drive you want to test. For
example, you want to test `/dev/sda1`, then type `1`. Likewise, if you want
to test `/dev/sdb1`, then type `2`.

```
$ ./drive-speed-test.sh 

1:/dev/sda:

What drive would you like to speed test?
[1-9]: 
```

Heres what it will look like:

```
$ ./drive-speed-test.sh 

1:/dev/sda:

What drive would you like to speed test?
[1-9]: 1
/dev/sda
How big do you want your file in Mb?
200
This will copy 200 Mb file onto /media/usb
Think twice before doing!

Are you sure you want to continue?
[Y,n]: y
Writing...

Time = 13.0130 s
Write = 15.3692 Mb/s


Reading...
Time = .8290 s
Read = 241.2545 Mb/s

Removing speed_test_file...
Done

Your results with 200 Mb file size:

Write speed = 15.3692 Mb/s
Read speed = 241.2545 Mb/s
```

WHAT! why is the read speed so high? Try a bigger file size, like >800Mb.

```
Your results with 800Mb file size:

Write speed = 10.1164 Mb/s
Read speed = 21.3304 Mb/s
```

Be sure to report any bugs or feature!

<br>


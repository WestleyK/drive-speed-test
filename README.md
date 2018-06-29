## What is drive-speed-test:

`drive-speed-test-vX.X.sh` test the read and write speed of your external drive through the Terminal. <br>
this is designed and tested on raspberry pi. <br>

<br>


## How to use:


#### Download and install:

Download if you did not already: <br>
`pi@raspberrypi:~ $ git clone https://github.com/WestleyK/drive-speed-test.git`<br>


Then put the `drive-speed-test-vX.X.sh` in your home directory, or whatever you want: <br>
`pi@raspberrypi:~ $ cp -i drive-speed-test/drive-speed-test-vX.X.sh ~/`<br>
<br>

#### How to test drives:

To run it, just do: <br>
`pi@raspberrypi:~ $ ./drive-speed-test-vX.X.sh`<br>
<br>

Then type the number that correspond with the drive you want to test.<br>
For example, you want to test `/dev/sda1`, then type `1`.<br>
Likewise, if you want to test `/dev/sdb1`, then type `2`.<br>

```
pi@raspberrypi:~ $ ./drive-speed-test-vX.X.sh 
https://github.com/WestleyK/drive-speed-test
Version-X.X



1:/dev/sda1  *     8064 30277631 30269568 14.4G  c W95 FAT32 (LBA)
2:/dev/sdb1           2 126353407 126353406 60.3G  b W95 FAT32

What drive would you like to speed test?
[1-9]:
```
<br>

Heres what it will look like:<br>

```
pi@raspberrypi:~ $ ./drive-speed-test-vX.X.sh 
https://github.com/WestleyK/drive-speed-test
Version-X.X



1:/dev/sda1  *     8064 30277631 30269568 14.4G  c W95 FAT32 (LBA)
2:/dev/sdb1           2 126353407 126353406 60.3G  b W95 FAT32

What drive would you like to speed test?
[1-9]:1 <user_input>
/dev/sda1

How big do you want your file in Mb?
600 <user_input>

This will copy 600 Mb file to your drive
Think twice before doing!

Are you sure you want to continue?
[Y,n]:y <user_input>

Writing...

Time = 54.2380 s
Write = 11.0623 Mb/s


Reading...
Time = .4850 s
Read = 1237.1134 Mb/s

Removing speed_test_file...
Done



Your results with 600Mb file size:

Write speed = 11.0623 Mb/s
Read speed = 1237.1134 Mb/s

pi@raspberrypi:~ $ 
```
<br>

WHAT! why is the read speed so high?<br>
Try a bigger file size, like >800Mb<br>
Heres with a 800Mb file:<br>

```
Your results with 800Mb file size:

Write speed = 10.1164 Mb/s
Read speed = 21.3304 Mb/s

```
<br>
<br>

Be sure to report any bugs or feature!<br>

<br>




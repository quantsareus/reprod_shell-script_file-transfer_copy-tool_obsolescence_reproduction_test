
Updates in Versions 0.6x:

- Increased nasty file and folder name stability. 
- Updated documentation.
- Removed depreciated b4k transfer mode. No good results with this one.
- Updated documentation.


Updates in Versions 0.5x:

- Improved transfer speed by tripling the transfer block size from 8 to 24. (Higher than bs=24 does not seem to be possible on a shell programming basis, because the 32 bit hardware acceleration will drop in at bs >= 32.)
- Disabled filesize display for performance reasons. (Mark # Disabled filesize display)
- Removed depreciated ('native') b512 transfer mode. No good results with this one.
- Flexible transfer and gmod modes for your own experiments.


Functionality and Features

- On a basic level reprod.sh provides a flexible and reliable file transfer functionality, that allows to transfers files, directories and links of a __directory structure__ of unlimited depth in one go. It is safe for nasty file and folder names containing blanks or quote characters. (However not safe for absolute nasty file and folder names containing a new line or the degree symbol.)

- The work horse for the simple copy tool functionality is the transfer mode '-m=cp' respectively '--mode=copy'.

- The default option '--talist=automatic' will create a full reproduction of all file objects of the <source-directory> in the <target-directory>.
  alternatively, the option 't=m' respectively '--talist=manual' can be used to transfer an absolutely free selected partial list of file objects (files, directories and links). The embedded tool parentdircomplete.py will complete the user generated transaction list /tmp/ta.lst for all their recursive parent directories, automatically. This is currently a unique 'selling' point functionality, that the standard linux transfer tools cannot provide, even if run in a pipeline; neither Windows or macOS-X transfer tools can do that. The automatic recursive parent directory completion is limited to maximum depth of 64.

- By default in case already existing file objects in the target directory are not overwritten and get reported as fail. To overwrite, you have to specify '-f' respectively '--force'. Directories however, cannot be overwritten. Thus, trying to transfer already existing directories will, '--force' specified or not, always fail.

- The original order of the file objects regarding their creation time stamps remains unchanged. Which usually keeps a linux boot sequence (inside a container or virtual machine image) alive.

- On a more advanced level the transferred data gets used as test data for a reproduction test of a container image or other (virtual machine) linux image, which is the primary purpose of the tool. (See --example to get an idea of a reproduction test.)

- The default transfer mode '-m=r' respectively '-mode=reprod' generates realistic test data applying a file authoring mimic. Here the file attributes of the target files are generated new, as if the file was created/ edited by an app. Except for the access mode and the ownership file attributes, which are always preserved in any transfer mode.

- The additional option '-g'/'--gmod' respectively '-gv X' modifies graphics of type (by suffix) png, jpg, jpeg, gif, xpm and bmp images, in order to simulate an authoring of graphics.

- The experimental transfer modes are truly granted for EXPERIMENTAL USE, only! (Do not blame the author for getting stuck in wonderland.)

- Last but not least reprod.sh provides a rough overall progress indicator during the transfer process and grants a detailed success reporting afterwards. Every eventual fail gets classified by the linux file type (file, directory or link). In case of fails two logs with failed files are generated ('/tmp/fail.lst' and '/tmp/g_fail.lst'). These ones can also get used to perform further batch jobs on the fails. E.g.  'sudo cat /tmp/g_fail.lst | sudo xargs shred -zn 0' (executed in the <target-directory>).


Requirements

The basic modes require nothing more than simply any Linux + bash or Unix + bash. Already a small Linux/ Unix stack should be fine (except busybox). zsh shell can be used as well. For usage with old zsh versions the bash style function definition symbols '{' and '}' need to get replaced by '(' and ')'. Other operating systems such as Windows and macOS-X do require WSL or another Linux bash shell port. This may or may not require code adoptions for non-posix pathes. The author neither tests nor supports that actively.

The option --talist=manual additionally requires python numpy.

The -g. options additionally requires the package gm, the package imagemagick or another image manipulation package. Usually one of those - or a third image manipulation package - is already installed in most Linux distributions out-of-box. The author does not recommend imagemagick. Thus, for use on own risk the outcommented imagemagick part in the script needs to be activated manually. Other image manipulation packages will require a self integration into the reprod.sh script.


Install

# Simple 'install' for use as copy tool
mkdir -m 777 <downloaddir>
Download reprod.sh (e.g. by browser) and save it to <downloaddir>
cd <downloaddir>
sudo chmod 755 reprod.sh

# Calling reprod.sh like this
sudo </path/to/downloaddir>/reprod.sh [OPTIONS] <source-directoryr> <target-directory>


# Advanced install for reproduction usage
Some complicated trusted operating system pre-requisits, which are out of the scope of this tiny tool. The author does not know them fully, either. All he can definitely tell from his test series is, that an Ubuntu family linux based starting version 18.04 is not suitable (out-of-box).
Perform the simple install procedure from above.
Then:
cd <downloaddir>
mkdir -m 777 ../anotherdir
dd if=reprod.sh of=../anotherdir/reprod.sh bs=24
sudo chmod 755 ../anotherdir/reprod.sh

# Calling reprod.sh like this
sudo </path/to/anotherdir>/reprod.sh [OPTIONS] <source-directoryr> <target-directory>


# More comfortable but also more risky install to /bin
sudo cp anotherdir/reprod.sh /bin
sudo rm -r anotherdir

# Calling reprod.sh like this
sudo reprod.sh [OPTIONS] <source-directoryr> <target-directory>



Safe Use (regarding reproduction test usage mainly):

1.
Follow the installation instructions 100% exactly.

2.
Do not save other files in the reprod.sh folder and do __not__ copy reprod.sh with a GUI file manager. (Move and rename is ok.)

3.
Once an error or an unusual behavior has occurred, stop the program at once and reboot your machine, before trying a new run! Do not let cracked jobs keep processing. And do not open files from a faulted job in a GUI. The best practice to get rid of maybe nasty generated data is the following deletion pipeline. (Take care where you do execute this!)
sudo find -P * -type f -print0 | sudo xargs -0 shred -zn 0
sudo rm -r *

4.
Do not edit the reprod.sh file in an editor, while the program is processing.

5.
Regarding reproduction tests the files are reproduced in a similar manner, as if they were created by an application or a linux command. However, it just became public, that there exists a folder based obsolescence functionality in Apple IOS. If such folder based obsolescence functionality also existed on macOS, Linux or Windows, __running__ the reproduced (container) image might age your machine some further, just like any obsolescence would get transferred from the developer machine's onto your machine by the folder structure of the binary programm or archive. While the extra aging typically is small and thus usually can be ignored, the reproduced (container) image might contain a lot of aging, if the machine used for reproduction is already pretty rocked down and close to BIOS/UEFI dying. Thus, before starting a (gigabyte) large reproduction test using reprod.sh the author recommends to install an on-premise linux machine fresh with a Linux distribution other than from the Ubuntu family.

6.
A fine reproduced image might suck (some minor) obsolescense again, when it in a docker style 'FROM ... ADD' pipeline gets further processed by an Ubuntu family distribution directly or by an automated cloud CI/CD build environment (e.g. at Docker Inc/ Github), that is based on Ubuntu. Other Debian family distributions seem to be fine. The recommendation reflects the author's experience. The research on file system based obsolescence functionalities is still work in progress and currently cannot be fully explained.



  In order to get a scrollable view let ' | less' follow the command.  

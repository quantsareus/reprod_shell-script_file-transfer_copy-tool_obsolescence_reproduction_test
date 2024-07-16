#! /bin/bash


# reprod.sh 
# By quantsareus.net
version="0.61.01"


print_usage() {
echo ""
echo "----------------------------------------------------------------------------------------------------------------------------"
echo "Usage:  sudo bash reprod.sh [ OPTIONS ] <source-directory> <target-directory>"
echo ""
echo " OPTIONS:"
echo ""
echo "----------------------------------------------------------------------------------------------------------------------------"
echo "  -h , --help             Show this help page."
echo "  -c , --contribution     Information, how to contribute to the program."
echo "  -e , --example          Examples."
echo "  -l , --license          License information."
echo "  -v , --version          Show version."
echo "  -r , --readme           Readme information. __The 'Safe Use' section is a MUST-READ before starting!__"
echo "----------------------------------------------------------------------------------------------------------------------------"
echo "BASIC MODES"
echo "  -m=cp, --mode=copy      Fast copy mode. This is the standard work horse for a simple 'as-is' file transfer. The file" 
echo "                          attributes of in the target files keep the same as the ones in the source files."
echo "----------------------------------------------------------------------------------------------------------------------------"
echo "  -t=m                    Manual transaction list generation by the user. For selective file transfer of a file object sub-"
echo "  --talist=manual         set. The manual transaction list has to be provided by a variation of"
echo "                          'find -P * > /tmp/ta.man'"
echo "                          __executed in the source folder__."
echo "                          The absolutely free selection of file objects will be completed for parent directories automa-" 
echo "                          tically by the embedded tool parentdircomplete.py. Unique 'selling' point."
echo "----------------------------------------------------------------------------------------------------------------------------"
echo "  -f , --force            Force. Overwrites existing file objects. Except for directories, which cannot get overwritten."
echo "                          USE RELUCTANTLY."
echo "----------------------------------------------------------------------------------------------------------------------------"
echo "  -g , --gmod             Default graphic modification. Mimicks a graphic authoring of png, webp, jpg, jpeg, gif, xpm and"
echo "                          bmp images. Requires one of the packages graphicsmagic or imagemagick."
echo "  -gv X                   Graphic modification as above with variable image depth. For quality/ size reduction."
echo "----------------------------------------------------------------------------------------------------------------------------"
echo "ADVANCED MODES"
echo "  -m=r, --mode=reprod     Default reproduction mode. On transfer additionally performs 50% of a refresh of the file attri-"   
echo "                          butes. The target file attributes are generated new, as if the file has just been created by an" 
echo "                          app. Except for the access mode and the ownership, that keep the same. Relatively slow."
echo "  -m=b32, --mode=b32      Reproduction in 32 bit blocks. Some HARDWARE ACCELERATION if on chipset. Relatively slow. FOR" 
echo "                          CLI USE OF GENERATED DATA."
echo "  -m=b8k, --mode=b8k      Fast reproduction with HARDWARE ACCELERATION in 'blocks of 4k in dual word mode'. Creates data"
echo "                          with sure aging. FOR EDUCATION OR OTHER USER PURPOSE."
echo "  -m=bv X, --mode=bv X    Variable size reproduction by MISCELANEOUS INTERNAL MECHANICS. E.g. to simulate aged folders."
echo "                          FOR FURTHER RESEARCH." 
echo "  -m=mv, --mode=move      Move mode. The mode is mainly offered for completeness. Anyway, the internally called command mv"  
echo "                          only performs a true move within the same filesystem (/ partition)! FOR FURTHER RESEARCH." 
echo "----------------------------------------------------------------------------------------------------------------------------"
echo ""
echo "Remark:"
echo "The options CANNOT be concatenated. E.g. enter '-f -g' NOT '-fg'."
echo ""
echo "Requirements: Linux + bash/zsh or Unix + bash/zsh. Maybe also Windows + WSL and macOS + shell are possible with some code adoptions."
echo ""
echo "  In order to get a scrollable view let ' | less' follow the command.  "
}


print_readme() {
echo ""
echo "Updates in Versions 0.6x:"
echo "" 
echo "- Increased nasty file and folder name stability. "
echo "- Updated documentation."
echo "- Removed depreciated b4k transfer mode. No good results with this one."
echo "- Updated documentation."
echo ""
echo ""
echo "Updates in Versions 0.5x:"
echo "" 
echo "- Improved transfer speed by tripling the transfer block size from 8 to 24. (Higher than bs=24 does not seem to be possible on a shell programming basis, because the 32 bit hardware acceleration will drop in at bs >= 32.)"
echo "- Disabled filesize display for performance reasons. (Mark # Disabled filesize display)"
echo "- Removed depreciated ('native') b512 transfer mode. No good results with this one."
echo "- Flexible transfer and gmod modes for your own experiments."
echo ""
echo ""
echo "Functionality and Features"
echo "" 
echo "- On a basic level reprod.sh provides a flexible and reliable file transfer functionality, that allows to transfers files, directories and links of a __directory structure__ of unlimited depth in one go. It is safe for nasty file and folder names containing blanks or quote characters. (However not safe for absolute nasty file and folder names containing a new line or the degree symbol.)"
echo ""
echo "- The work horse for the simple copy tool functionality is the transfer mode '-m=cp' respectively '--mode=copy'."
echo ""
echo "- The default option '--talist=automatic' will create a full reproduction of all file objects of the <source-directory> in the <target-directory>."
echo "  alternatively, the option 't=m' respectively '--talist=manual' can be used to transfer an absolutely free selected partial list of file objects (files, directories and links). The embedded tool parentdircomplete.py will complete the user generated transaction list /tmp/ta.lst for all their recursive parent directories, automatically. This is currently a unique 'selling' point functionality, that the standard linux transfer tools cannot provide, even if run in a pipeline; neither Windows or macOS-X transfer tools can do that. The automatic recursive parent directory completion is limited to maximum depth of 64."
echo ""
echo "- By default in case already existing file objects in the target directory are not overwritten and get reported as fail. To overwrite, you have to specify '-f' respectively '--force'. Directories however, cannot be overwritten. Thus, trying to transfer already existing directories will, '--force' specified or not, always fail."
echo ""
echo "- The original order of the file objects regarding their creation time stamps remains unchanged. Which usually keeps a linux boot sequence (inside a container or virtual machine image) alive."
echo ""
echo "- On a more advanced level the transferred data gets used as test data for a reproduction test of a container image or other (virtual machine) linux image, which is the primary purpose of the tool. (See --example to get an idea of a reproduction test.)"
echo "" 
echo "- The default transfer mode '-m=r' respectively '-mode=reprod' generates realistic test data applying a file authoring mimic. Here the file attributes of the target files are generated new, as if the file was created/ edited by an app. Except for the access mode and the ownership file attributes, which are always preserved in any transfer mode."
echo "" 
echo "- The additional option '-g'/'--gmod' respectively '-gv X' modifies graphics of type (by suffix) png, jpg, jpeg, gif, xpm and bmp images, in order to simulate an authoring of graphics."
echo "" 
echo "- The experimental transfer modes are truly granted for EXPERIMENTAL USE, only! (Do not blame the author for getting stuck in wonderland.)"
echo ""
echo "- Last but not least reprod.sh provides a rough overall progress indicator during the transfer process and grants a detailed success reporting afterwards. Every eventual fail gets classified by the linux file type (file, directory or link). In case of fails two logs with failed files are generated ('/tmp/fail.lst' and '/tmp/g_fail.lst'). These ones can also get used to perform further batch jobs on the fails. E.g.  'sudo cat /tmp/g_fail.lst | sudo xargs shred -zn 0' (executed in the <target-directory>)."
echo ""
echo ""
echo "Requirements"
echo ""
echo "The basic modes require nothing more than simply any Linux + bash or Unix + bash. Already a small Linux/ Unix stack should be fine (except busybox). zsh shell can be used as well. For usage with old zsh versions the bash style function definition symbols '{' and '}' need to get replaced by '(' and ')'. Other operating systems such as Windows and macOS-X do require WSL or another Linux bash shell port. This may or may not require code adoptions for non-posix pathes. The author neither tests nor supports that actively."
echo ""
echo "The option --talist=manual additionally requires python numpy."
echo ""
echo "The -g. options additionally requires the package gm, the package imagemagick or another image manipulation package. Usually one of those - or a third image manipulation package - is already installed in most Linux distributions out-of-box. The author does not recommend imagemagick. Thus, for use on own risk the outcommented imagemagick part in the script needs to be activated manually. Other image manipulation packages will require a self integration into the reprod.sh script."
echo ""
echo ""
echo "Install"
echo ""
echo "# Simple 'install' for use as copy tool"
echo "mkdir -m 777 <downloaddir>"
echo "Download reprod.sh (e.g. by browser) and save it to <downloaddir>"
echo "cd <downloaddir>"
echo "sudo chmod 755 reprod.sh"
echo ""
echo "# Calling reprod.sh like this"
echo "sudo </path/to/downloaddir>/reprod.sh [OPTIONS] <source-directoryr> <target-directory>"
echo ""
echo ""
echo "# Advanced install for reproduction usage"
echo "Some complicated trusted operating system pre-requisits, which are out of the scope of this tiny tool. The author does not know them fully, either. All he can definitely tell from his test series is, that an Ubuntu family linux based starting version 18.04 is not suitable (out-of-box)."
echo "Perform the simple install procedure from above."
echo "Then:"
echo "cd <downloaddir>"
echo "mkdir -m 777 ../anotherdir"
echo "dd if=reprod.sh of=../anotherdir/reprod.sh bs=24"
echo "sudo chmod 755 ../anotherdir/reprod.sh"
echo ""
echo "# Calling reprod.sh like this"
echo "sudo </path/to/anotherdir>/reprod.sh [OPTIONS] <source-directoryr> <target-directory>"
echo ""
echo ""
echo "# More comfortable but also more risky install to /bin"
echo "sudo cp anotherdir/reprod.sh /bin"
echo "sudo rm -r anotherdir"
echo ""
echo "# Calling reprod.sh like this"
echo "sudo reprod.sh [OPTIONS] <source-directoryr> <target-directory>"
echo ""
echo ""
echo ""
echo "Safe Use (regarding reproduction test usage mainly):" 
echo ""
echo "1."
echo "Follow the installation instructions 100% exactly."
echo ""
echo "2."
echo "Do not save other files in the reprod.sh folder and do __not__ copy reprod.sh with a GUI file manager. (Move and rename is ok.)"
echo ""
echo "3."
echo "Once an error or an unusual behavior has occurred, stop the program at once and reboot your machine, before trying a new run! Do not let cracked jobs keep processing. And do not open files from a faulted job in a GUI. The best practice to get rid of maybe nasty generated data is the following deletion pipeline. (Take care where you do execute this!)"
echo "sudo find -P * -type f -print0 | sudo xargs -0 shred -zn 0"
echo "sudo rm -r *"
echo ""
echo "4."
echo "Do not edit the reprod.sh file in an editor, while the program is processing."
echo ""
echo "5."
echo "Regarding reproduction tests the files are reproduced in a similar manner, as if they were created by an application or a linux command. However, it just became public, that there exists a folder based obsolescence functionality in Apple IOS. If such folder based obsolescence functionality also existed on macOS, Linux or Windows, __running__ the reproduced (container) image might age your machine some further, just like any obsolescence would get transferred from the developer machine's onto your machine by the folder structure of the binary programm or archive. While the extra aging typically is small and thus usually can be ignored, the reproduced (container) image might contain a lot of aging, if the machine used for reproduction is already pretty rocked down and close to BIOS/UEFI dying. Thus, before starting a (gigabyte) large reproduction test using reprod.sh the author recommends to install an on-premise linux machine fresh with a Linux distribution other than from the Ubuntu family." 
echo ""
echo "6."
echo "A fine reproduced image might suck (some minor) obsolescense again, when it in a docker style 'FROM ... ADD' pipeline gets further processed by an Ubuntu family distribution directly or by an automated cloud CI/CD build environment (e.g. at Docker Inc/ Github), that is based on Ubuntu. Other Debian family distributions seem to be fine. The recommendation reflects the author's experience. The research on file system based obsolescence functionalities is still work in progress and currently cannot be fully explained."
echo ""
echo ""
echo ""
echo "  In order to get a scrollable view let ' | less' follow the command.  "
}

print_example() {
echo ""
echo ""
echo "Example 1. Reproduction test example for a Drupal container image"
echo ""
echo "Usually container images are stateless and the configurations of the follow up developer get encapsulated in a new overlay layer. The effective filesystem of container image edited by multiple developers behaves like a layered piecework; bottom layers get effective where the layer(s) on top have holes (, to be specific do not provide the corresponding directory/ file/ link). However, there are also new stateful so called 2nd generation container images with an ordinary on-premise-installer (e.g. the docker images of Wordpress, Joomla and Drupal). When the follow-up developer has done an edit of one or more configuration files, then there might -- in the out-of-order and speculative bare metal processing of the CPU -- show up concurrent file attributes of the configuration file, when running the ordinary on-premise-installer. Which often crashes the installation process or causes other erratic behaviour later on, especially if there are many of such edited installer files. To avoid this, the follow-up developer can perform the configuration edits, respectively the preliminary reproduction test, that simulates a maximum configuration of any file in the image, as follows:" 
echo ""
echo ""
echo "Step 1: Downloading the Drupal image and exporting it" 
echo "mkdir -m 777 <imageorigfolder>"
echo "cd <imageorigfolder>"
echo "sudo docker/ podman pull drupal:latest" 
echo "sudo docker/ podman run -d drupalcontainer drupal:latest" 
echo "sudo docker/ podman export drupalcontainer > imageorig.tar" 
echo "sudo tar -xf imageorig.tar"
echo "sudo rm imageorig.tar"
echo ""
echo ""
echo "Step 2: Filling the imageworkfolder"
echo ""
echo "A1) Configuration alternative:"
echo "cd <imageorigfolder>"
echo "sudo find -P * -name "*.conf" > /tmp/ta.man" 
echo "cd .."
echo "sudo /bin/reprod.sh -g -t=m <imageorigfolder> <imageworkfolder>"
echo "Follow-up developer configurations in <imageworkfolder>"
echo ""
echo "A2) Reproduction test alternative (simulating a 100% configuration):"
echo "sudo /bin/reprod.sh -g <imageorigfolder> <imageworkfolder>"
echo ""
echo ""
echo "Step 3: Finalization"
echo "sudo /bin/reprod.sh -m=cp <imageworkfolder> <imagefinalfolder>"
echo ""
echo ""
echo "Step 4: Creating the new test container image"
echo ""
echo "Create the following Dockerfile in an editor:"
echo "FROM localhost/drupal"
echo "RUN echo 'Creating a new overlay layer by a executing a RUN action'"
echo "ADD imagefinalfolder /"
echo "WORKDIR /var/www/html"
echo "CMD ["apache2-foreground"]"
echo ""
echo "Having Dockerfile and <imagefinalfolder> in the current directory call:" 
echo "sudo docker/ podman build -t localhost/testimage ."
echo ""
echo ""
echo "Step 5: Test running the test image"
echo "sudo docker/ podman run -d --name testcontainer [some -e configs] localhost/testimage"
echo ""
echo ""
echo "Summary of alternatives for the configuration problem at an installer image:"
echo ""
echo "- A1: Looking for software, the developer distributes as app files plus a Dockerfile construction plan instead of a ready build docker image. This way necessary configurations can be made before packaging as a container image. Typically the best option."
echo "- A2: Pre-testing the container image for its configuration capability by the reproduction test shown above before starting the configuration development. If there is no alternative A1, this is usually the next best option for a container image, that includes an installer and requires configuration."
echo "- A3: Instead of using the standard 'FROM ... RUN ... ADD' pipeline alternatively building a new flat container image with just one overlay layer from the exported data files using docker/ podman import. However, this automatically makes you the maintainer for the whole new flat image without having an (automatic) update strategy at hand. Bad option from the point of efficiency."
echo ""
echo ""
echo ""
echo "Example 2. Using reprod.sh for a safe raw system image install on a sd card/ usb stick (as-is-install)"
echo ""
echo "On a brand new machine with Linux installed right from the beginning, writing a raw system image onto a flash medium using dd to is a low-brainer. However, the more the OS has aged already, the more frequently a low-brainer sd card does not work. Either the card does not boot all, or the system on the card is rapidly aging (even down to a maximum of 10 possible boots). "
echo ""
echo ""
echo "Insert the sd card into the admin machine before booting the admin machine up."
echo ""
echo "Erase the card properly as follows, also including brand new cards with factory exfat file system."
echo "sudo lsblk"
echo "sudo dd if=/dev/urandom of=/dev/sdb status=progress  # up to ~ 250 MB"
echo "sudo dd if=/dev/zero of=/dev/sdb bs=X status=progress  # with X = even divider of 16384 (16K) other than 512;  until the medium is full"
echo ""
echo ""
echo "Install"
echo "mkdir -m 777 somefolder"
echo "# Download Armbian_23.02.2_Rpi4b_jammy_current_5.15.92.img.xz (OR ALIKE) with your browser directly to somefolder."
echo "cd somefolder"
echo "sudo chmod 777 *.xz"
echo "xz -dk *.xz"
echo "cd .."
echo "sudo /bin/reprod.sh -m=b32 somefolder somefolder32"
echo "sudo /bin/reprod.sh -m=r somefolder32 somefolder32r"
echo "sudo /bin/reprod.sh -m=cp somefolder32r somefolder32rc"
echo "cd somefolder32rc"
echo ""
echo "# Version A. Runs once, runs long."
echo "sudo dd if=Armbian_23.02.2_Rpi4b_jammy_current_5.15.92.img of=/dev/sdb bs=X status=progress  #  with X = even divider of 16384 (16K) other than 512"
echo ""
echo "# Version B. Runs more probable, but maybe not very long."
echo "sudo dd if=Armbian_23.02.2_Rpi4b_jammy_current_5.15.92.img of=/dev/sdb bs=X status=progress #  with X = some high muliple of 16384 (16K)"
echo ""
echo "Shutdown the admin machine."
echo "Remove the card and insert it into the unpowered Raspberry (OR ALIKE)."
echo "Boot the Raspberry (OR ALIKE)."
echo "Set the passwords, but leave out the local language configuration."
echo "sudo armbian-config"
echo "Set language and keyboard layout."
echo ""
echo ""
echo "Troubleshooting"
echo "- Try another ARM OS distribution in an archive format other than xz or bz2."
echo "- Some SBC SOCs are this sensitive, that they can only get properly installed in a Windows like manner using an over-sophisticated media installer like Balena Etcher. Even if you get them installed this way, you won't have much fun with them. Whenever they are not properly shut down (including an unintended temporary power wire disconnection), the filesystem on the SD card dies a little bit. Finally also the SD card itself dies. A Raspberry is cheap. But a Raspberry plus 3 smashed 64GB A2 SD cards is not, anymore. When you get aware of such shitty SBC quality after the purchase, better make use of your 2 weeks/ 4 weeks return policy."
echo "- The USB controller of your admin machine got stuck. Unlock it."
echo "- Your admin machine OS is already rocked down, too much. Try a fresh install/ other machine."
echo "- Try to install from another Linux."
echo ""
echo ""
echo ""
echo "Example 3. Reproduction test of a linux image (off label use)"
echo ""
echo "The author could not run the following reproduction test example explicitly on the Raspberry 4b. To be frank, the author's Raspberry is out of order and the Raspberry 4b is out of stock since month. The impendance resistors of the wifi antennas were badly soldered. After a longer not-use period they have all fallen off and the Raspberry SOC from then on screen-printed everything diagonal from the left upper corner to right lower corner (without any modifications of the sd-card image). The author's other single board computers (BananaPi, RockPi) have all passed the presented reproduction test explicitly succesful."
echo ""
echo ""
echo "sudo mkdir -m 777 /media/orig"
echo "sudo losetup -fP --direct-io Armbian_23.02.2_Rpi4b_jammy_current_5.15.92.img"
echo "sudo mount -t ext4 /dev/loop0p1 /media/orig"
echo "sudo reprod.sh -g /media/orig imgfolder"
echo ""
echo "cp Armbian_23.02.2_Rpi4b_jammy_current_5.15.92.img reprod.img"
echo "sudo losetup -fP --direct-io reprod.img"
echo "sudo mkdir -m 777 /media/reprod"
echo "sudo mount -t ext4 /dev/loop1p1 /media/reprod"
echo "cd /media/reprod"
echo "sudo find -P * -type f -print0 | sudo xargs -0 shred -zn 0"
echo "sudo rm -r *"
echo ""
echo "sudo reprod.sh -m=cp imgfolder /media/reprod"
echo ""
echo "sudo umount /media/* && sudo losetup -D"
echo ""
echo ""
echo ""
echo ""
echo "  In order to get a scrollable view let ' | less' follow the command.  "
}

print_contribution() {
echo ""
echo "You are very welcome to contribute to this tool! All you need to do to make your contribution on to the tool as a non development team member is the following:"
echo ""
echo "1. git clone https://github.com/quantsareus/reprod<...>.git"
echo "2. cd reprod<...>"
echo "3. Make your edits."
echo "4. git add --all"
echo "5. git commit -m '<description of your fabulous update>' "
echo "6. git push origin <name_of_your_fork_branch>"
echo ""
echo "However, before you can do step 6, you need to register on github.com, once."
echo ""
echo "If you are not familiar with the collab development tool 'git' already, search for the free ProGit_2020.pdf book (or a newer version) on duckduckgo.com. The book explains  almost everything perfectly."
echo ""
echo "Alternatively, it should also be possible to create a fork using the guthub web interface. In case request duckduckgo.com, how to perform that."
echo ""
echo ""
echo "Your improved version has to meet four little requirements to get accepted to be incorporated into the main line version:"
echo ""
echo "1. You have to provide a working version, that can be tried out."
echo "2. The update version can still be distributed as a single file."
echo "3. The update version does not contain a GUI element." 
echo "4. An update version usually contains the features of the current version."
echo ""
echo "Other than these few requirements will - from the author's point of view - unnecessarily complicate the tiny tool. The last requirement, however, might be discussed, when offerering a significant improvement of the tool, that's ready to use."
echo ""
echo ""
echo "Your accepted fork currently gets merged into the main branch once a month, when I take my research days."
echo ""
echo ""
echo "Additionally, the author also provides his personal '# Further development options' at the end of the script file "
echo ""
echo ""
echo "  In order to get a scrollable view let ' | less' follow the command.  "
}

print_license() {
echo ""
echo "Licence, Warranty and Liability"
echo ""
echo ""
echo "Licence: GPL-V3" 
echo ""
echo "Which more or less means:"
echo "Unlimited free to use and unlimited free to redistribute. Free to recycle the code, as far the new code is granted with a GPL-V3 licence (or higher), again."
echo ""
echo ""
echo "The tool is granted without any warranty and also without any liability for damages, the tool might - properly or improperly applied - cause. In other words: The usage of the tool is fully at own risk in any direction."
echo ""
}

print_version() {
echo "Version: $version"
}


###############################################################################################################################################################
#
# Parsing arguments


basedir=$PWD


# Default values:
mode='reprod'
gmod='no'
force="no"
talist_gen='automatic'
# sdir=""
# tdir=""


while [ -n "$1" ]; 
do
    arghead="$(echo "$1" | sed 's/-.*/-/')"
      
    if [ "$1" = "-h" ] || [ "$1" = "--help" ] 
    then
        print_usage
        exit 0

    elif [ "$1" = "-c" ] || [ "$1" = "--contribution" ] 
    then
        print_contribution
        exit 0

    elif [ "$1" = "-e" ] || [ "$1" = "--example" ] 
    then
        print_example
        exit 0
              
    elif [ "$1" = "-l" ] || [ "$1" = "--license" ] 
    then
        print_license
        exit 0

    elif [ "$1" = "-v" ] || [ "$1" = "--version" ] 
    then
        print_version
        exit 0

    elif [ "$1" = "-r" ] || [ "$1" = "--readme" ] 
    then
        print_readme
        exit 0

    elif [ "$1" = "-m=r" ] || [ "$1" = "-m=reprod" ] || [ "$1" = "--mode=r" ] || [ "$1" = "--mode=reprod" ]
    then
        mode="reprod"

    elif [ "$1" = "-m=cp" ] || [ "$1" = "-m=copy" ] || [ "$1" = "--mode=cp" ] || [ "$1" = "--mode=copy" ]
    then
        mode="copy"
    
    elif [ "$1" = "-m=mv" ] || [ "$1" = "-m=move" ] || [ "$1" = "--mode=mv" ] || [ "$1" = "--mode=move" ]
    then
        mode="move"
    
    elif [ "$1" = "-m=b32" ] || [ "$1" = "--mode=b32" ] 
    then
        mode="b32"
  
    elif [ "$1" = "-m=b8k" ] || [ "$1" = "--mode=b8k" ] 
    then
        mode="b8k"       
       
    elif [ "$1" = "-m=bv" ] || [ "$1" = "--mode=bv" ] 
    then
        mode="bv"
        shift
        bsx="$1"
    
    elif [ "$1" = "-f" ] || [ "$1" = "--force" ] 
    then
        force="yes"
    
    elif [ "$1" = "-g" ] || [ "$1" = "--gmod" ] 
    then
        gmod="default"
    
    elif [ "$1" = "-gv" ]
    then
        gmod="gv"
        shift
        gdx="$1"
        
    elif [ "$1" = "-t=m" ] || [ "$1" = "-t=manual" ] || [ "$1" = "-talist=m" ] || [ "$1" = "--talist=manual" ]
    then
        talist_gen="manual"
    
    elif [ "$arghead" != "-" ]
    then
        sdir="$1"
        shift
        tdir="$1"
        
    else
        echo "ARGUMENT ERROR"
        echo "Consult 'bash reprod.sh --help' and validate the syntax." 
        exit 1
    fi

shift
done


if [ "$gmod" = "default" ] || [ "$gmod" = "gv" ] 
then
    if test -f /bin/gm
    then 
        gtool="gm"
    
    ### Activate imagemagick at own risk !!
    # elif test -f /bin/convert
    # then 
    #    gtool="im"
    
    else
        echo "ERROR: Image maniplation requested, but no image manipulation tool installed."
        echo "Imagemagick is out-of-the-box deactivated."
        exit 1
    fi
fi


###############################################################################################################################################################
#
# Defining the operation functions by operation modes


function makedir() {
    mkdir "$1"
}


if [ "$force" = "yes" ]
then 
    function makelink() {
        ln -fs "$1" "$2"
    }

else
    function makelink() {
        ln -s "$1" "$2"
    }
fi     


if [ "$force" = "yes" ]
then 
    if [ "$mode" = "reprod" ]
    then
        function reprodf() {
            dd if="$1" of="$2" bs=24 status=progress iflag=nofollow
         }
    elif [ "$mode" = "copy" ]
    then
        function reprodf() {
            cp -f "$1" "$2"
        }
    elif [ "$mode" = "move" ]
    then
        function reprodf() {
            mv -f "$1" "$2" 
        }
    elif [ "$mode" = "b32" ]
    then
        function reprodf() {
            dd if="$1" of="$2" bs=32 status=progress iflag=nofollow 
         }
         
    elif [ "$mode" = "b8k" ]
    then
        function reprodf() {
            # The concrete value might require continuous update.
            dd if="$1" of="$2" bs=8k status=progress iflag=nofollow 
        }

    elif [ "$mode" = "bv" ]
    then
        function reprodf() {
            dd if="$1" of="$2" bs="$bsx" status=progress iflag=nofollow 
         }
    else
        function reprodf() {
            echo "Error: No transfer mode."
        }
    
    fi
    
else

    if [ "$mode" = "reprod" ]
    then
        function reprodf() {
            dd if="$1" of="$2" bs=24 status=progress iflag=nofollow conv=excl 
         }
    elif [ "$mode" = "copy" ]
    then
        function reprodf() {
            cp "$1" "$2"
        }
    elif [ "$mode" = "move" ]
    then
        function reprodf() {
            mv "$1" "$2" 
        }
    elif [ "$mode" = "b32" ]
    then
        function reprodf() {
            dd if="$1" of="$2" bs=32 status=progress iflag=nofollow conv=excl 
         }
    elif [ "$mode" = "b8k" ]
    then
        function reprodf() {
            # The concrete value might require continuous update. 
            dd if="$1" of="$2" bs=8k status=progress iflag=nofollow conv=excl 
        }
    elif [ "$mode" = "bv" ]
    then
        function reprodf() {
            dd if="$1" of="$2" bs="$bsx" status=progress iflag=nofollow conv=excl 
         }
    else 
        function reprodf() {
            echo "Error: No transfer mode."
        }
    fi
fi



# Graphic modification. Mimicks a graphic authoring of png, jpg, jpeg, gif, xpm and bmp images.


if [ "$gmod" = "default" ]
then 
    
    if [ "$gtool" = "gm" ] && [ "$force" = "yes" ] && [ "$mode" != "move" ]
    then
        function reprodg() {
            gm convert "$1" -depth 6 "$2"
        }
    
    elif [ "$gtool" = "gm" ] && [ "$force" = "no" ] && [ "$mode" != "move" ]
    then
        function reprodg() {
            if ! ( test -f "$2" )
            then
                gm convert "$1" -depth 6 "$2"
                return $TRUE
            else
                return $FALSE
            fi
        }
    
    # imagemagick
    elif [ "$gtool" = "im" ] && [ "$force" = "yes" ] && [ "$mode" != "move" ]
    then
        function reprodg() {
            convert "$1" -depth 6 "$2"
        }
    
    elif [ "$gtool" = "im" ] && [ "$force" = "no" ] && [ "$mode" != "move" ]
    then
        function reprodg() {
            if ! ( test -f "$2" )
            then
                convert "$1" -depth 6 "$2"
                return $TRUE
            else
                return $FALSE
            fi    
        }
    
    else
        echo "gmod ERROR: The requested graphic authoring mode cannot be compiled."
        echo "Mode move cannot be combined with graphic authoring."
        echo "(Imagemagick is out-of-the-box deactivated.)"
        exit 1
    fi

elif [ "$gmod" = "gv" ]
then 

    if [ "$gtool" = "gm" ] && [ "$force" = "yes" ] && [ "$mode" != "move" ]
    then
        function reprodg() {
            gm convert "$1" -depth "$gdx" "$2"
        }
    
    elif [ "$gtool" = "gm" ] && [ "$force" = "no" ] && [ "$mode" != "move" ]
    then
        function reprodg() {
            if ! ( test -f "$2" )
            then
                gm convert "$1" -depth "$gdx" "$2"
                return $TRUE
            else
                return $FALSE
            fi
        }
    
    # imagemagick
    elif [ "$gtool" = "im" ] && [ "$force" = "yes" ] && [ "$mode" != "move" ]
    then
        function reprodg() {
            convert "$1" -depth "$gdx" "$2"
        }
    
    elif [ "$gtool" = "im" ] && [ "$force" = "no" ] && [ "$mode" != "move" ]
    then
        function reprodg() {
            if ! ( test -f "$2" )
            then
                convert "$1" -depth "$gdx" "$2"
                return $TRUE
            else
                return $FALSE
            fi    
        }
    
    else
        echo "gv ERROR: The requested graphic authoring mode cannot be compiled."
        echo "Mode move cannot be combined with graphic authoring."
        echo "(Imagemagick is out-of-the-box deactivated.)"
        exit 1
    fi

  
else
    
    # ELSE transfer mode.
    
    function reprodg() {
        reprodf "$1" "$2"
    }   
fi


function parentdircomplete_py_wrapper() {

echo ""
echo ""

# Embedding python as so called here document
 
python3 - <<END

print("Embedded parentdircomplete.py: Processing /tmp/ta.man")

# parentdircomplete.py
# By quantsareus.net
version="0.20"


import numpy as np


depthmax= 64
linelenmax= 'S256'
encoding= 'latin1'
inpathesfile= "/tmp/ta.man"
workpathesfile= inpathesfile +".work"
outpathesfile= "/tmp/ta.man.compl"
delimiter= chr(2)


if True:   
    fr = open(inpathesfile, "r")
    fw = open(workpathesfile, "w")
    for lineorig in fr:
        lineorig= lineorig.rstrip("\n")
        line= lineorig
        lastslashpos=-1
        for i in range (0, depthmax-1):
            lastslashpos= line.rfind('/')
            if lastslashpos > -1:
                line= line[0: lastslashpos]
                fw.write(line +"\n")
            else:
                break   
        fw.write(lineorig +"\n")   
    fr.close()
    fw.close()

  
try:
    arr00= np.array(np.loadtxt(workpathesfile, dtype=linelenmax, encoding=encoding, delimiter=delimiter ) )
except UnicodeDecodeError:
    print("The path file contains either chr(2) or characters outside the numpy encoding charset (by default 'latin1').")

arr= np.unique(arr00)

np.savetxt(workpathesfile, arr, fmt="%s")


fr = open(workpathesfile, "r")
fw = open(outpathesfile, "w")
for lineorig in fr:
    lineorig= lineorig.rstrip("\n")
    line= lineorig.lstrip("b'")
    line= line.rstrip("'")
    fw.write(line +"\n")   
fr.close()
fw.close()


print("") 
print("Embedded parentdircomplete.py: All possible parent pathes have been added once and the duplicate parent pathes have been removed again.") 
# print("")
# print("The new pathes file has been written to   " + outpathesfile +" .") 

END

}


###############################################################################################################################################################
#
# Catching run time errors


# Test tmp access
if 
	echo "" >/tmp/dummy.lst
then
	echo ""
else
	echo "ERROR: Cannot write to work directory: /tmp"
    exit 1
fi


# Cleaning up previous runs
if test -f "/tmp/dummy.lst"
then
	find -P /tmp -name "*.lst*" -print0 | xargs -0 shred -zn 0
	find -P /tmp -name "*.lst*" -print0 | xargs -0 rm
fi


# Test root privileges
if (! echo "" >/root/dummy.txt)
then
        echo "ERROR: No root priviliges. Use 'sudo bash reprod.sh' instead of 'bash reprod.sh'"
        echo ""
        echo "Aborted without any changes"
        echo ""
        exit 1
else
        shred -zn 0 /root/dummy.txt
        rm /root/dummy.txt
fi


# Test source dir
if  ! cd "$sdir" 
then
	echo "ERROR: Cannot access source directory:  $sdir"
	exit 1
else cd $basedir
fi


# Test target dir
if test -d "$tdir"
then	
	echo "The specified target directory"
	echo "$tdir"
	echo "already exists."
	
	tdirsize=$(cut -f 1 <<< $(du -b --max-depth=0 "$tdir"))
	if [ $tdirsize -gt 32768 ]
	then 
	    echo ""
	    echo ""
	    echo "The target directory"
	    echo "$tdir"
	    echo "seems not to be empty. (It is $tdirsize Byte large.)"
	    echo ""
	    echo "Already existing data will only be overwritten, if the option -f /--force is set."
	    echo ""
	    
	    read -p "Proceed? (y/ n/ CNTRL-c)" inpt 
        
        if ! [ "$inpt" = "y" ] || [ "$inpt" = "Y" ] 
        then
            exit 1
        fi	
    fi
	
else
	echo "The specified target directory"
	echo ""
	echo "$tdir"
	echo ""
	echo "does not exist."
	echo ""
	read -p "Should it be created? (y/ n/ CNTRL-c)" inpt 
	
	if [ "$inpt" = "y" ]
	then
		if mkdir -m 777 "$tdir"
		then 
			echo ""
			echo "The target-directory $tdir has been created successfully."
		else 
			echo "ERROR: Creating the target directory \n $tdir \n has failed."
			echo "Check the path."
			exit 1
		fi  	
	else
		echo "No target directory. Exiting."
		exit 1
	fi
fi


###############################################################################################################################################################
#
# Main program:


# Generating the transaction list

echo ""
echo ""
echo "Preparing the specified job. One moment please ..."



cd "$sdir" 

if [ "$talist_gen" = "manual" ]
then
    
    parentdircomplete_py_wrapper
    
    taman_count=0
    talst_count=0
    file=/tmp/ta.man.compl
    while read ta
    do 
        taman_count=$(($taman_count +1))
        if find -P "$ta" -maxdepth 0 -printf '%B@°°%y°%p\n' >> /tmp/ta.lst.work
        then
            talst_count=$(($talst_count +1))
        else
            echo "ERROR:   $ta   not accessible!"
        fi
            
    done < "$file"
    
    sort /tmp/ta.lst.work | sed 's/.*°°//' > /tmp/ta.lst

else
    find -P * -printf '%B@°°%y°%p\n' | sort | sed 's/.*°°//' > /tmp/ta.lst

    talst_count=$(cut -d - -f 1 <<< $(wc -l - < /tmp/ta.lst))     
        
    sdir_count=0
    for f in $(sudo find -P * -printf '%y\n')
    do 
        sdir_count=$(($sdir_count +1))
    done
    
    sdir_size=$(cut -f 1 <<< $(du -b --max-depth=0 .))

fi

cd "$basedir"



# Asking the specified job back
echo ""
echo ""
echo "Job Summary"
echo ""
echo "Specified Options"
echo "mode: $mode  force: $force  gmod: $gmod  talist-generation: $talist_gen"
echo ""
echo "Source Directory: $sdir       Target Directory: $tdir"
echo ""
if [ "$talist_gen" = "manual" ]
then
    echo "# File objects in the manual transaction list /tmp/ta.man: $taman_count"
    echo "# File objects in the final transaction list /tmp/ta.lst: $talst_count"
    echo "(File objects not accessible under the manual path in case got lost.)"
else
    echo "The source directory contains in total: $sdir_size Byte"
    echo "# File objects in source directory: $sdir_count"
    echo "# File objects in transaction list: $talst_count"
fi

echo ""
if [ "$mode" = "reprod" ]
then
    echo "The transfer speed in default reprod mode (on the same SSD) might range as follows:"
    echo "--mode=reprod [ avg. I/O size 10 kB ]     ~   2  -   6 GB/h."
    echo "--mode=reprod [ avg. I/O size  1 MB ]     ~  15  -  36 GB/h."
    echo ""
    echo "When on processing, the rough overall progress is shown."
    echo ""
fi

read -p "Start the job, right now? (y/ n/ CNTRL-c)" inpt

if ! [ "$inpt" = "y" ] || [ "$inpt" = "Y" ] 
then
    exit 1
fi


# Starting the job


starttime="$(date --iso-8601='seconds')"
echo ""
echo ""
echo "Starting to reprod"
echo ""
echo "Starttime: $starttime"
echo ""
echo ""


i=0
succcnt=0
failcnt=0
d_failcnt=0
l_failcnt=0
f_failcnt=0
g_failcount=0
u_failcnt=0

if test -f /tmp/ta.lst
then
    file=/tmp/ta.lst
    while read ta
    do
        taobjtype="$(sed 's/°.*//' <<<"$ta")" 
        taobj="$(sed 's/.*°//' <<<"$ta")" 
	    taobjname="$(find "$sdir/$taobj" -maxdepth 0 -printf '%f')"
	    taobjsuffix="$(sed 's/.*\.//' <<< "$taobjname")"

	    # graphic type definition
	    if [ "$taobjtype" = "f" ]
	    then
	        case "$taobjsuffix" in
	        png )
	        taobjtype="g"
	        ;;
	        webp )
	        taobjtype="g"
	        ;;
	        jpg )
	        taobjtype="g"
	        ;;
	        jpeg )
	        taobjtype="g"
	        ;;
	        gif )
	        taobjtype="g"
	        ;;
	        xpm )
	        taobjtype="g"
	        ;;
	        bmp )
	        taobjtype="g"
	        ;;
	        esac
        fi
        
        ### Display overall progress information and processed file object
        echo "Overall Progress: ~ $(($i *100 /$talst_count))%"
        i=$(($i +1))
        date --iso-8601='seconds'
        
        # Disabled filesize display 
        # find "$sdir/$taobj" -maxdepth 0 -printf " $taobj %s Byte \n" | xargs
        
        # File owner
        owner='root:root'
        owner="$(find "$sdir/$taobj" -maxdepth 0 -printf '%u:%g')"
        
        # File access mode with 4 digits
        accmode="0644"
        accmode="$(find "$sdir/$taobj" -maxdepth 0 -printf '%#m')"
               
        case $taobjtype in
	    d )
		    if 
	    	    makedir "$tdir/$taobj"
    	    then
                chown "$owner" "$tdir/$taobj"
                chmod "$accmode" "$tdir/$taobj"
                succcnt=$(($succcnt+1))
	       		echo "Ok"	    		
	    	else
	    		echo "Fail"
	    		failcnt=$(($failcnt+1))
	    		d_failcnt=$(($d_failcnt+1))
	    		echo "$taobj" >>/tmp/fail.lst
	    	fi
	        ;;
	    l )
	        lt=''
    		lt="$(readlink $sdir/$taobj)"
		    if
    			makelink "$lt" "$tdir/$taobj"
    		then
    			# links have neither an access mode and nor an owner
    		    succcnt=$(($succcnt+1))
    		    echo "Ok"	    		
	    	else
	    		echo "Fail"
	    		failcnt=$(($failcnt+1))
	    		l_failcnt=$(($l_failcnt+1))
	    		echo "$taobj" >>/tmp/fail.lst
	    	fi
	        ;;
	    f )
            if
		        reprodf "$sdir/$taobj" "$tdir/$taobj" 
	    	then
                chown "$owner" "$tdir/$taobj"
			    chmod "$accmode" "$tdir/$taobj"
			    succcnt=$(($succcnt+1))
	       		echo "Ok"	    		
	    	else
	    		echo "Fail"
	    		failcnt=$(($failcnt+1))
	    		f_failcnt=$(($f_failcnt+1))
	    		echo "$taobj" >>/tmp/fail.lst
	    	fi
	        ;;
	    g )
	        if
		        reprodg "$sdir/$taobj" "$tdir/$taobj"     
            then
                chown "$owner" "$tdir/$taobj"
			    chmod "$accmode" "$tdir/$taobj"
			    succcnt=$(($succcnt+1))
	       	    echo "Ok"
            else
			    echo "gmod failed"
			    g_failcount=$(($g_failcount+1))
	            echo "$taobj" >>/tmp/g_fail.lst
	            if
		            reprodf "$sdir/$taobj" "$tdir/$taobj" 
	    	    then
                    chown "$owner" "$tdir/$taobj"
			        chmod "$accmode" "$tdir/$taobj"
			        succcnt=$(($succcnt+1))
	       		    echo "Ok"	    		
	    	    else
	    		    echo "Fail"
	    		    failcnt=$(($failcnt+1))
	    		    f_failcnt=$(($f_failcnt+1))
	    		    echo "$taobj" >>/tmp/fail.lst
	    	    fi
	        fi
	        ;;
	    * )
		    echo "ERROR: Unknown file type"
     	    failcnt=$(($failcnt+1))
	    	u_failcnt=$(($u_failcnt+1))
	    	echo "$taobj" >>/tmp/fail.lst
            ;;
        esac
        
    done < "$file"

else
	echo "The generation of the transaction list /tmp/ta.lst has failed (, which is the central job control)."
	echo ""
    echo "Thus, nothing is reproduced."
	echo ""

fi


# Reporting

endtime="$(date --iso-8601='seconds')"

echo ""
echo ""
echo "Transfer Report"
# echo ""
# echo "Specified Options"
# echo "mode: $mode  force: $force  gmod: $gmod  talist-generation: $talist_gen"
echo ""
echo "Starttime: $starttime    Endtime: $endtime"
echo ""
if [ "$talist_gen" = "manual" ]
then
    echo "# File objects in the manual transaction list /tmp/ta.man: $taman_count"
    echo "# File objects in the final transaction list /tmp/ta.lst: $talst_count"
    # echo "(File objects not accessible under the manual path in case got lost.)"
else
    echo "The source directory contains in total: $sdir_size Byte"
    echo "# File objects in source directory: $sdir_count"
    echo "# File objects in transaction list: $talst_count"
fi
echo ""
echo "Result:"
echo ""
if [ $failcnt = 0 ]
then
	echo "FULL SUCCESS. All $succcnt file objects have been transferred."
	echo ""
else
	echo "SOME FAILS."
	echo "In total $succcnt file objects have been transferred successfully."
	echo "In total $failcnt file objects have failed."
	echo "Among these:"
	echo "$d_failcnt directories have failed."
	echo "$l_failcnt links have failed."
	echo "$f_failcnt files have failed."
	echo "$u_failcnt file objects of unknown type have failed."
	echo ""
    echo "To view in detail enter 'sudo cat< /tmp/fail.lst'"
fi

if [ $g_failcount -gt 0 ]
then
    echo ""
	echo ""
	echo "Graphics Report"
	echo ""
	echo "In $g_failcount graphics the specified graphic modification has not been performed."
	echo ""
	echo "To view in detail enter 'sudo cat< /tmp/g_fail.lst'"
	echo ""
fi



###############################################################################################################################################################
#
# Further development options :

# - Compiling the shell script to a binary, e.g. using simple script compiler. 
# - Variable graphic type definition by a list.
# - Functionality to skip the current transfer (of a large file).
# - A MB 'number format' for file sizes (kB sizes erratic; either kB or kiB).


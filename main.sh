#!/bin/bash
# while-menu-dialog: a menu driven system information program
DIALOG_CANCEL=1
DIALOG_ESC=255
HEIGHT=0
WIDTH=0
Stu_Num=""
Name=""
Exit_reg=1
Family_Name=""
res=""
emty=""
if [ ! -f ~/stuinfo.txt ]; then
    touch ~/stuinfo.txt
fi
display_result() {
  dialog --title "$1" \
    --no-collapse \
    --msgbox "$result" 0 0
}

while true; do
  exec 3>&1
  selection=$(dialog \
    --backtitle "System Information" \
    --title "Menu" \
    --clear \
    --cancel-label "Exit" \
    --menu "Please select:" $HEIGHT $WIDTH 4 \
    "1" "Student Registration" \
    "2" "Mark Registration" \
    "3" "Report" \
   2>&1 1>&3
)
  exit_status=$?
  #exec 3>&-
  case $exit_status in
    $DIALOG_CANCEL)
      clear
      echo "Program terminated."
      exit
      ;;
    $DIALOG_ESC)
      clear
      echo "Program aborted." >&2
      exit 1
      ;;
  esac
  case $selection in
    0 )
      clear
      echo "Program terminated."
      ;;
    1 )
     while true; do
     exec 3>&1
     dialog  --clear --separate-widget $ --ok-label "Ok" --backtitle "Stu Reg"  --title "Student Registration"  --form "creating new " 15 80 0 "student_number: "              1 1   "$Stu_Num"             1 25 40 0\
       "Name:"               2 1 "$Name"            2 25 40 0 \
       "Last Name:"               3 1 "$Family_Name"           3 25 40 0\
     2>&1 1>&3 | {
     read -r Stu_Num
     read -r Name
     read -r Family_Name
     if [ $Stu_Num != "" ] 
     then
        echo "student number:" $Stu_Num >> ~/stuinfo.txt
     fi
     if [ $Name != "" ] 
     then
     echo "Student Name:" $Name >> ~/stuinfo.txt
     fi
     if [ $Family_Name != "" ] 
     then
     echo "Last Name:" $Family_Name >> ~/stuinfo.txt
     fi
     echo "" >> ~/stuinfo.txt
     #read -r mail
     #The rest of the script goes here
     }
     exec 3>&-
     dialog --title "Message"  --yesno "Continue Registration?" 6 25
       return_value=$?
       case $return_value in
       $DIALOG_CANCEL)
      clear
      break
      esac
      done
      ;;
    2 )
      Stu_Num=0
      OS=0
      OSL=0
      exec 3>&1
     dialog  --clear --separate-widget $ --ok-label "Ok" --backtitle "Stu Num"  --title "Student Marks"  --form "creating new " 15 80 0 "student_number: "              1 1   "$Stu_Num"             1 28 40 0\
       "Operating System Mark:"               2 1 "$OS"            2 28 40 0 \
       "Operating System Lab. Mark:"               3 1 "$OSL"           3 28 40 0\
     2>&1 1>&3 | {
     read -r Stu_Num
     read -r OS
     read -r OSL
     res=0
     resos=0
     resosl=0
     res=$(grep -n -w $Stu_Num ~/stuinfo.txt | sed 's/^\([0-9]\+\):.*$/\1/')
     resos=$(($res+3))
     resosl=$(($res+4))
     sed -i ${resos}i${OS} ~/stuinfo.txt
     sed -i ${resosl}i${OSL} ~/stuinfo.txt
      #read -r mail
     #The rest of the script goes here
     }
     exec 3>&-
      ;;
    3 )
     exec 3>&1
  selection1=$(dialog \
    --backtitle "Student Information" \
    --title "Menu" \
    --clear \
    --cancel-label "Exit" \
    --menu "Please select:" $HEIGHT $WIDTH 4 \
    "1" "Operating System's Marks'" \
    "2" "Operating System's Lab Marks" \
    "3" "Student Marks Report" \
      2>&1 1>&3
)
    exit_status=$?
    #exec 3>&-
    case $exit_status in
     $DIALOG_CANCEL)
      clear
      echo "Program terminated."
      exit
      ;;
    $DIALOG_ESC)
      clear
      echo "Program aborted." >&2
      exit 1
      ;;
  esac
    case $selection1 in
     0 )
       echo "Program terminated."
      ;;
     1 )
      end="$(sed -n '$=' ~/stuinfo.txt)"
      for start in `seq 1 5 $end`;
        do
         till=$((start+3))
         sed -n "${start},${till}p" ~/stuinfo.txt >> /tmp/temp.txt
        done    
      result="$(cat /tmp/temp.txt)"       
      display_result "results"
      ;;
     2 )
      end="$(sed -n '$=' ~/stuinfo.txt)"
      for start in `seq 1 5 $end`;
        do
         till=$((start+2))
         oslab_mark=$((start+5))
         sed -n "${start},${till}p;${oslab_mark}" ~/stuinfo.txt >> /tmp/temp2.txt
        done    
      result="$(cat /tmp/temp2.txt)"       
      display_result "results"
       ;;
      3 )
        exec 3>&1;
        user_inp=$(dialog --inputbox test 0 0 2>&1 1>&3);
        #exitcode=$?;
        exec 3>&-;
        res2=$(grep -n -w $user_inp ~/stuinfo.txt | sed 's/^\([0-9]\+\):.*$/\1/')
        till1=$((res2+5))
        sed -n "${res2},${till1}p;${oslab_mark}" ~/stuinfo.txt >> /tmp/temp3.txt
        result="$(cat /tmp/temp3.txt)"
        display_result "results"
        result=0
  esac
esac
done
Script displaying a dialog menu

#!/bin/bash
# check fot valid parametr
if [[ -z "$1" ]] || [[ -z "$2" ]]
   then
    echo "param 1: name file, param 2: name of the pdf watermark, param 3 (optional param): slect pages: 1-5 or 1,3,5,7 (select pge #1 #3 #5 #7) or 1-4,8,9"
    exit
fi
rm -fr jpg/
rm -fr output/
#create work dir
mkdir -p jpg
mkdir -p output
#create var
file=$1
n=$(pdftk $1 dump_data | grep NumberOfPages | cut -d " " -f 2)
# split function
function cat_pdf {
      pdftk "_"$1 cat $2 output $2"_"$1
}
# convrt function
function jpg_pdf {
      name=$1
      name=${name::-4}
      convert -density 300 -quality 100 $2"_"$1 jpg/$2"_"$name".jpg"
      rm -f $2"_"$1
}
# split cat pdf function on slected page
function split_pdf {
      bar=${2//,/' '}
      pdftk $1 cat $bar output "cat_"$1
}
if [[ -z "$3" ]]
   then
   # add wotermark
   pdftk $file stamp $2 output "_"$file
   cp "_"$file output/"_"$file
   # split and convert
   for (( i=1; i <= $n; i++ ))
    do
     cat_pdf $file $i
     jpg_pdf $file $i
    done
   else
     split_pdf $file $3
     file="cat_"$file
     n=$(pdftk $file dump_data | grep NumberOfPages | cut -d " " -f 2)
     pdftk $file stamp $2 output "_"$file
     cp "_"$file output/"_"$file
     for (( i=1; i <= $n; i++ ))
      do
       cat_pdf $file $i
       jpg_pdf $file $i
      done
fi
#clear temp files
#rm -f "_"$1
#rm -f "cat_"$1

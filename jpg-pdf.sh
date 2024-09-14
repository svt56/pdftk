#!/bin/bash
rm -fr jpg/
rm -fr output/
#create work dir
mkdir -p jpg
mkdir -p output
# test imput param or no
if [[ $2 == "" ]] then
  echo "first param - name of the file"
  echo "second param - what we do whith him"
  echo "1 - convert pdft to jpg, whith watermark 1"
  echo "2 - convert pdft to jpg, whith watermark 2"
  echo "3 - cut pages in new pdf"
  echo "4 - insert password"
  echo "5 - convert pdf to jpg"
  echo "pleas restart script"
fi
# if enter greate then 5 param then return
if [[ $2 -gt 6 ]]
then
  echo "pleas restart script, $2 not in 1...5"
fi
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
# case cycle

case $2 in
  1)
    if [[ $n -gt 10 ]]
    then
      pdftk $file stamp 1.pdf output output/"_"$file
      echo "slect pages: 1-5 or 1,3,5,7 (select pge #1 #3 #5 #7) or 1-4,8,9"
      read pages
      split_pdf $file $pages
      file="cat_"$file
      n=$(pdftk $file dump_data | grep NumberOfPages | cut -d " " -f 2)
    fi
    #add watermark 1
    pdftk $file stamp 1.pdf output "_"$file
    cp "_"$file output/"_"$file
    # split in 1 page pdf, and then convert this pdf to jpg
    for (( i=1; i <= $n; i++ ))
      do
      cat_pdf $file $i
      jpg_pdf $file $i
      done
      rm -f "_"$file
    ;;
  2)
    if [[ $n -gt 10 ]]
    then
      pdftk $file stamp 1.pdf output output/"_"$file
      echo "slect pages: 1-5 or 1,3,5,7 (select pge #1 #3 #5 #7) or 1-4,8,9"
      read pages
      split_pdf $file $pages
      file="cat_"$file
      n=$(pdftk $file dump_data | grep NumberOfPages | cut -d " " -f 2)
    fi
    #add watermark 1
    pdftk $file stamp 2.pdf output "_"$file
    cp "_"$file output/"_"$file
    # split in 1 page pdf, and then convert this pdf to jpg
    for (( i=1; i <= $n; i++ ))
      do
      cat_pdf $file $i
      jpg_pdf $file $i
      done
      rm -f "_"$file
    ;;
  3)
    echo "slect pages: 1-5 or 1,3,5,7 (select pge #1 #3 #5 #7) or 1-4,8,9"
    read pages
    split_pdf $file $pages
    ;;
  4)
    echo " enter passwor, default is: $file"
    read pass
    pdftk $file output ${file::-4}"_pass.pdf" owner_pw $pass
    ;;
  5)
    for (( i=1; i <= $n; i++ ))
    do
     cp $file "_"$file
     cat_pdf $file $i
     jpg_pdf $file $i
    done
    ;;
esac
#clear temp files
rm -f "_"$1
rm -f "cat_"$1

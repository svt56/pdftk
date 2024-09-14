# pdftk bash script
## jpg-pdf.sh
bash is a script that applies watermarks to the original pdf file, then converts it page by page to jpg. Watermarks are placed from files 1.pdf and 2.pdf, which must be placed next to the crypt.</br>
there is also a separate option to set a password for copying and changing pdf.</br>
There is an option to convert pdf to a page resolution of 300 pixels.</br>
there is an option to pull out the necessary pages from the pdf.</br>
two parameters are passed to the script: 1 the file name must be in the same directory so that everything works normally and the option number:</br>
"1 - Convert pdf to jpg with watermark 1"</br>
"2 - convert pdf to jpg with watermark 2"</br>
"3 - cut pages in new pdf format"</br>
"4 - insert password"</br>
"5 - Convert pdf to jpg"</br>
the results will be in folders jpg and output</br>
## jpg-pdf-water.sh
one line command for input watermark, covet to jpg, and if needed split pdf</br>
param 1: name file </br>
param 2: name of the pdf watermark</br>
param 3 (optional param): slect pages: 1-5 or 1,3,5,7 (select pge #1 #3 #5 #7) or 1-4,8,9</br>
### exemple: </br>
./jpg-pdf-water.sh 7.pdf 2.pdf 1,3</br>
./jpg-pdf-water.sh 7.pdf 2.pdf 1-3</br>
./jpg-pdf-water.sh 7.pdf 2.pdf</br>


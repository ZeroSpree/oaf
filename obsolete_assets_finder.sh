# file: backup.sh

IMAGES="${PWD}/_assets/img"
VIDEOS="${PWD}/_assets/video"
LOG="${PWD}/obsolete_assets_finder.log"
count=0

search() {
  for pathname in "$1"/*; do

    # recursive search for subdirectories
    if [ -d "$pathname" ]; then
      search "$pathname"
    else
      # search the filename.ext only, exclude the rest of the path
      filename=$(basename "$pathname")
      grep -q -R --exclude-dir={node_modules,dist,_site,.sass-cache,.git,assets} -i "$filename" ./

      # $? == 0 if grep found something
      # if it didn't found anything:
      if [[ $? != 0 ]]; then
        # increase the obsolete assets counter
        count=`expr $count + 1`
        # print out the full filepath
        echo -e "\e[1;31m $pathname \e[0m"
        # also write it in the file log
        echo "$pathname" >> $LOG
      fi
    fi
  done
}

echo -e "\e[1;32m +----------------------------+ \e[0m"
echo -e "\e[1;32m |                            | \e[0m"
echo -e "\e[1;32m |                            | \e[0m"
echo -e "\e[1;32m |   Obsolete Assets Finder   | \e[0m"
echo -e "\e[1;32m |                            | \e[0m"
echo -e "\e[1;32m |                            | \e[0m"
echo -e "\e[1;32m +----------------------------+ \e[0m"

# we want to search the built site
cd ${PWD}/_site

# remove preexisting log, if any
rm $LOG

echo
echo "Searching Videos..."
search "$VIDEOS"
echo
echo "Searching Images..."
search "$IMAGES"

echo
echo "Found $count unused files."
echo "A log is available at $LOG"
echo "Goodbye!"

# close the window in 30s if didn't manually close it
sleep 30

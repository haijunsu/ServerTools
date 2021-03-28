###################
# check credential file
##
PASS_FILE=${HOME}/.mongorc.js
checkPass() {
  if [ ! -f "$PASS_FILE" ]; then
    echo "The mongo credential file doesn't exist. Please create one following the README."
    exit 1
  else
    if [ $(stat -c %a "$PASS_FILE") != '600' ]; then
      echo "The mongo credential file permission should be 600. Fixing it."
      chmod 600 "$PASS_FILE"
      echo The mongo credential file permission is $(stat -c %a "$PASS_FILE") now.
    fi
  fi
}

#!/bin/bash

success=`killall -q -w redshift-gtk || true` 

redshift-gtk &
DISPLAY=:8 redshift-gtk &

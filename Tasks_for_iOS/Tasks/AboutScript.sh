#!/bin/sh
#  AboutScript.sh
#  Tasks
#
#  Custom xcconfig: 1 parameters "development" or "adhoc" is mandatory.
#
#  Created by Javier Fuchs on 5/11/13.
#  Copyright (c) 2013 Hungry And Foolish. All rights reserved.

plistBuddy=/usr/libexec/PlistBuddy;
targetFile="${PROJECT_DIR}/Tasks/Tasks-Info.plist";

username=$(who am i | awk '{print $1}');

gitVersion=$(cd ${PROJECT_DIR} && git log -1 --oneline && cd - >/dev/null);

gitBranch=$(cd ${PROJECT_DIR} && git branch && cd - >/dev/null);

gitUrl=$(grep url ${PROJECT_DIR}/../.git/config | awk '{print $3}');

copyright="(c) Hungry And Foolish - javier.fuchs@me.com";

uname=$(uname -a);

uniqueId=$(uuidgen);

# date & time (UTC)
buildDateTime=$(date -u);

buildNumber=$(${plistBuddy} -c "Print :CFBundleVersion" "${targetFile}");

About=$(${plistBuddy} -c "Print :About" "${targetFile}" 2>/dev/null);
#echo "ABOUT = [$ABOUT]" > /tmp/about.log

${plistBuddy} -c "Set :CFBundleIdentifier com.hungryandfoolish.Tasks" "${targetFile}";

if [ ${CONFIGURATION} == "Debug" ]; then
    # only in Development

    if [ ${#About} -eq 0 ]; then
       command=Add; 
       type=string;

       ${plistBuddy} -c "${command} :About:${buildNumber} dict" ${targetFile};
    else
       command=Set; 
       type="";
    fi

    ${plistBuddy} -c "${command} :About:${buildNumber}:copyright ${type} \"${copyright}\"" ${targetFile};
    ${plistBuddy} -c "${command} :About:${buildNumber}:username ${type} \"${username}\"" ${targetFile};
    ${plistBuddy} -c "${command} :About:${buildNumber}:uname ${type} \"${uname}\"" ${targetFile};
    ${plistBuddy} -c "${command} :About:${buildNumber}:uniqueId ${type} \"${uniqueId}\"" ${targetFile};
    ${plistBuddy} -c "${command} :About:${buildNumber}:buildDateTime ${type} \"${buildDateTime}\"" ${targetFile};
    ${plistBuddy} -c "${command} :About:${buildNumber}:gitUrl ${type} \"${gitUrl}\"" ${targetFile};
    ${plistBuddy} -c "${command} :About:${buildNumber}:gitVersion ${type} \"${gitVersion}\"" ${targetFile};
    ${plistBuddy} -c "${command} :About:${buildNumber}:gitBranch ${type} \"${gitBranch}\"" ${targetFile};
    ${plistBuddy} -c "${command} :About:${buildNumber}:configuration ${type} \"${CONFIGURATION}\"" ${targetFile};

elif [ ${CONFIGURATION} == "Adhoc" ]; then

    # only in Adhoc
    buildNumber=$((${buildNumber} + 1));
    ${plistBuddy} -c "${command} :About:${buildNumber} dict" ${targetFile};


    ${plistBuddy} -c "Set :CFBundleVersion ${buildNumber}" ${targetFile};
    ${plistBuddy} -c "Add :About:${buildNumber}:copyright string \"${copyright}\"" ${targetFile};
    ${plistBuddy} -c "Add :About:${buildNumber}:username string \"${username}\"" ${targetFile};
    ${plistBuddy} -c "Add :About:${buildNumber}:uname string \"${uname}\"" ${targetFile};
    ${plistBuddy} -c "Add :About:${buildNumber}:uniqueId string \"${uniqueId}\"" ${targetFile};
    ${plistBuddy} -c "Add :About:${buildNumber}:buildDateTime string \"${buildDateTime}\"" ${targetFile};
    ${plistBuddy} -c "Add :About:${buildNumber}:gitUrl string \"${gitUrl}\"" ${targetFile};
    ${plistBuddy} -c "Add :About:${buildNumber}:gitVersion string \"${gitVersion}\"" ${targetFile};
    ${plistBuddy} -c "Add :About:${buildNumber}:gitBranch string \"${gitBranch}\"" ${targetFile};
    ${plistBuddy} -c "Add :About:${buildNumber}:configuration string \"${CONFIGURATION}\"" ${targetFile};
fi


#set >/tmp/x.log;

#!/bin/bash

#set -x

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    CYGWIN*)    MACHINE=Cygwin;;
    MINGW*)     MACHINE=MinGw;;
    *)          MACHINE="UNKNOWN:${unameOut}"
esac

PROGNAME=$(basename $0)
if [[ $MACHINE == "Mac" ]]; then
    echo "mac absolute directory"
    ABSPATH=$PWD/$0
else
    ABSPATH=$(readlink -f $0)
fi
ABSDIR=$(dirname $ABSPATH)
EXECHOME=$ABSDIR/../
TMPDIR=$EXECHOME/../tmp/$PROGNAME
LOGSDIR=$EXECHOME/../logs/$PROGNAME
RESOURCESDIR=$EXECHOME/resources/$PROGNAME
TIMESTAMP=`date +'%s'`
if [[ $MACHINE == "Mac" ]]; then
    echo "mac datetime"
    DATETIME=`date -r $TIMESTAMP '+%Y-%m-%d--%H:%M:%S'`
    LOGDATE=`date -r $TIMESTAMP '+%Y-%m-%d'`
else
    DATETIME=`date -d @$TIMESTAMP '+%Y-%m-%d--%H:%M:%S'`
    LOGDATE=`date -d @$TIMESTAMP '+%Y-%m-%d'`
fi

mkdir -p $TMPDIR
mkdir -p $LOGSDIR

LOGSDIRFORSCRIPT=$LOGSDIR/$PROGNAME-$LOGDATE
mkdir -p $LOGSDIRFORSCRIPT

# logging - initiate w full command   
logfile=$LOGSDIR/$PROGNAME-$LOGDATE.log
echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""logs initiated\n" >> $logfile

encryption_file=$EXECHOME/conf/$PROGNAME.param
encryption_file_enc=$encryption_file.enc

# decrypting the file
#/usr/bin/openssl enc -in $encryption_file_enc -salt -a  -d -aes-256-cbc -out $encryption_file  -pass file:$EXECHOME/working/profile/.pass.txt

. $encryption_file
#rm $encryption_file


echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""0:\n" 
echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""$0:\n"
echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""MACHINE:\n" 
echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""$MACHINE:\n"
echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""PROGNAME:\n" 
echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""$PROGNAME:\n" 
echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""ABSPATH:\n" 
echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""$ABSPATH:\n" 
echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""ABSDIR:\n" 
echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""$ABSDIR:\n" 
echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""EXECHOME:\n" 
echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""$EXECHOME:\n" 
echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""TMPDIR:\n" 
echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""$TMPDIR:\n" 
echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""LOGSDIR:\n" 
echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""$LOGSDIR:\n" 
echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""TIMESTAMP:\n" 
echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""$TIMESTAMP:\n" 
echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""DATETIME:\n" 
echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""$DATETIME:\n" 
echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""LOGDATE:\n" 
echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""$LOGDATE:\n" 
echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""logfile:\n" 
echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""$logfile:\n"
echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""encryption_file:\n" 
echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""$encryption_file:\n" 





usage() {

    # Display usage message on standard error
    echo "Usage: $PROGNAME <data_map_json_file_path>" 1>&2
}

clean_up() {

    # Perform program exit housekeeping
    # Optionally accepts an exit status
    echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""clean_up $1 triggered\n" >> $logfile
    #rm -f $encryption_file
    exit $1
}

error_exit() {

    # Display error message and exit
    echo "${PROGNAME}: error_exit triggered - ${1:-"Unknown Error"}" 1>&2
    echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""error_exit triggered\n" >> $logfile
    echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""$1\n" >> $logfile
    email_list="frank.myers@investors.com,analytics@investors.com"
    if command -v mailx &> /dev/null
    then
        echo -e "$1 \n" | mailx -s "ERROR: $PROGNAME for $DATETIME" -r "noreply_cron@investors.com" frank.myers@investors.com   
    fi
    if command -v sendmail &> /dev/null
    then
        echo -e "Subject: Sending email using sendmail\nERROR: $PROGNAME for $DATETIME"  | UseSTARTTLS=YES FromLineOverride=YES root=sys@`hostname` mailhub=mxout.williamoneil.com:25 sendmail frank.myers@investors.com
    fi
    clean_up 1
}

trap clean_up SIGHUP SIGINT SIGTERM

cd $EXECHOME


#if [ $# != "1" ]; then
#    usage
#    error_exit "L:$LINENO: specify correct args"
#fi

echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""pwd:\n" >> $logfile
echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""$(pwd):\n" >> $logfile

echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""1:\n" >> $logfile
echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""$1:\n" >> $logfile




#### TODO: initialize os and python environment

if [[ $MACHINE == "Mac" ]]; then
    echo "mac package installer"
else
    if command -v yum &> /dev/null
    then
        yum install -y jq
    fi
fi

#pip3 install virtualenv
#python3 -m venv venv
#source "venv/bin/activate"
#cat $EXECHOME/requirements.txt | xargs -n 1 pip3 install
#pip3 install pandas_redshift 
#pip3 install pymssql 




git_repo_sync() {

    bkt_assume_role_access_key=$( jq -r '.assume_role_access_key' <<< "${assume_creds_obj}" )
    bkt_assume_role_secret_key=$( jq -r '.assume_role_secret_key' <<< "${assume_creds_obj}" )
    bkt_assume_role_sessiontoken=$( jq -r '.assume_role_sessiontoken' <<< "${assume_creds_obj}" )

    echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""bkt_assume_role_access_key:\n" 
    echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""$bkt_assume_role_access_key \n" 

    echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""bkt_assume_role_secret_key:\n" 
    echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""$bkt_assume_role_secret_key \n"

    echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""bkt_assume_role_sessiontoken:\n" 
    echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""$bkt_assume_role_sessiontoken \n"



    sync_json="${1}"

    echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""sync_json:\n" 
    echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""$sync_json:\n"

    bkt_source=$( jq -r '.source.name' <<< "${sync_json}" )
    bkt_dest=$( jq -r '.dest.name' <<< "${sync_json}" )
    
    echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""bkt_source:\n" 
    echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""$bkt_source \n"

    echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""bkt_dest:\n" 
    echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""$bkt_dest \n"

    
    #echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""aws s3 ls s3://$bkt_source --human-readable --summarize true \n"
    #AWS_ACCESS_KEY_ID=${bkt_assume_role_access_key} AWS_SECRET_ACCESS_KEY=${bkt_assume_role_secret_key} AWS_SESSION_TOKEN=${bkt_assume_role_sessiontoken} aws s3 ls s3://$bkt_source --human-readable --summarize 

    #echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""aws s3 ls s3://$bkt_dest \n"
    #AWS_ACCESS_KEY_ID=${bkt_assume_role_access_key} AWS_SECRET_ACCESS_KEY=${bkt_assume_role_secret_key} AWS_SESSION_TOKEN=${bkt_assume_role_sessiontoken} aws s3 ls s3://$bkt_dest --page-size 1

    echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""aws s3 sync s3://$bkt_source  s3://$bkt_dest \n"
    AWS_ACCESS_KEY_ID=${bkt_assume_role_access_key} AWS_SECRET_ACCESS_KEY=${bkt_assume_role_secret_key} AWS_SESSION_TOKEN=${bkt_assume_role_sessiontoken} aws s3 sync s3://$bkt_source  s3://$bkt_dest  &> $LOGSDIRFORSCRIPT/s3-sync-$bkt_source-to-$bkt_dest.log
}






#### input json file w repos to sync

repos_to_sync_json=$(cat $RESOURCESDIR/repos.json)

repos_to_sync=$( jq -rc '.repos' <<< "${repos_to_sync_json}" )

echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""repos_to_sync:\n" 
echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""$repos_to_sync \n"


#### generate dict of source to dest repos

git_repo_objects=$( jq -rc '.[]' <<< "${repos_to_sync}" )

echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""git_repo_objects:\n" 
echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""$git_repo_objects \n"



#### loop through each dict set

for git_repo_object in $(echo "${git_repo_objects}" | jq -rc '.'); do

    echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""git_repo_object:\n" 
    echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""$git_repo_object \n"

    sync_source=$( jq -rc '.source' <<< "${git_repo_object}" )
    sync_dest=$( jq -rc '.dest' <<< "${git_repo_object}" )

    echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""sync_source:\n" 
    echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""$sync_source \n"

    echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""sync_dest:\n" 
    echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""$sync_dest \n"

    # pull down source repo
    repo_source_name=$( jq -r '.name' <<< "${sync_source}" )
    repo_source_url=$( jq -r '.url' <<< "${sync_source}" )
    echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""repo_source_name: $repo_source_name\n" 
    echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""repo_source_url: $repo_source_url\n" 
    rm -rf $TMPDIR/$repo_source_name
    git clone $repo_source_url $TMPDIR/$repo_source_name

    # pull down target repo
    repo_dest_name=$( jq -r '.name' <<< "${sync_dest}" )
    repo_dest_url=$( jq -r '.url' <<< "${sync_dest}" )
    echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""repo_dest_name: $repo_dest_name\n" 
    echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""repo_dest_url: $repo_dest_url\n" 

    repo_dest_url_w_token=$( sed 's,https://',"https://$dj_git_token@,g" <<< "${repo_dest_url}" )
    echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""repo_dest_url_w_token: $repo_dest_url_w_token\n" 

    rm -rf $TMPDIR/$repo_dest_name
    git clone $repo_dest_url_w_token $TMPDIR/$repo_dest_name

    # rsync source and target
    echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""rsync -avz --delete --exclude .git --exclude  ignore_dir --exclude  venv $TMPDIR/$repo_source_name/ $TMPDIR/$repo_dest_name/\n"
    rsync -avz --delete --exclude .git --exclude  ignore_dir --exclude  venv $TMPDIR/$repo_source_name/ $TMPDIR/$repo_dest_name/

    # commit and push target repo
    echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""git commit -m \"sync push $LOGDATE\"\n" 
    cd $TMPDIR/$repo_dest_name
    #git add -A .
    #git commit -m "sync push $LOGDATE"
    #git push

    # get all branches for source repo

    # foreach source repo branch

        # switch source repo to current branch

        # pull down current branch

        # query whether branch exists in target repo

            # create branch if does not exist

        # rsync source repo branch with target branch

        # push target branch



    #### cp objects new/modified within data range
    #git_repo_sync "${git_repo_object}"


    #### track cp'd objects in log file


    #### verify cp'd objects exists in dest bucket

done




echo -e "["`date '+%H:%M:%S'`"-L:$LINENO] ""SCRIPT_COMPLETE\n" >> $logfile


clean_up







#!/bin/bash


RUN="java"
HAMCREST="./libs/hamcrest-core-1.3.jar"
JUNIT="./libs/junit-4.12.jar"
AWS="./libs/aws-java-sdk-1.9.13.jar"
JACKSONANN="./libs/jackson-annotations-2.4.0.jar"
JACKSONDB="./libs/jackson-databind-2.4.4.jar"
JACKSONCORE="./libs/jackson-core-2.4.4.jar"
APACHELOG="./libs/commons-logging-1.2.jar"
HTTPCLIENT="./libs/httpclient-4.3.6.jar"
HTTPCORE="./libs/httpcore-4.3.3.jar"
HTTPCLIENTC="./libs/httpclient-cache-4.3.6.jar"
JODATIME="./libs/joda-time-2.6.jar"
OUTDIR="./bin"
CLASSPATH=".:$OUTDIR:$HAMCREST:$JUNIT:$AWS:$JACKSONANN:$JACKSONDB:$JACKSONCORE:$APACHELOG:$HTTPCLIENT:$HTTPCLIENTC:$HTTPCORE:$JODATIME"

EXTRA="-XX:+UseConcMarkSweepGC -Xmx4096m"
#EXTRA="-Xms128m -Xmx8192m"

MAINCLASS="eoram/cloudexp/CloudExperiments"

if [ ! -d "$OUTDIR" ]; then
    echo "Class files directory does not exist: run 'compile.sh' first, exiting...";
    exit 1;
fi


WORKINGDIR="$1"
if [ -z "$WORKINGDIR" ]; then
	echo "No working directory specified, exiting..."; exit 1;
fi

shift # remove the first arg

BINPATH="`pwd`/bin"
LIBSPATH="`pwd`/libs"

# move to the working directory
cd "$WORKINGDIR"

# make the links / copy
if ! [ -d "./bin" ]; then
	cp -r "$BINPATH" .
	ln -s "$LIBSPATH" .
fi

#create what's needed
mkdir -p "log" "temp" "local" "state"

ARGS="$@"
cmd=`echo "$RUN" -ea "$EXTRA" -classpath "$CLASSPATH" "$MAINCLASS" "$ARGS"`
echo "Run command: \"$cmd\" ";

echo "--------------------------";

# run
$cmd

echo "--------------------------";

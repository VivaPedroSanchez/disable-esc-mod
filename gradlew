#!/usr/bin/env sh
#
# Copyright 2017 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-20.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Determine the Java command to use to start the JVM.
if [ -n "$JAVA_HOME" ] ; then
    if [ -x "$JAVA_HOME/jre/bin/java" ] ; then
        JAVACMD="$JAVA_HOME/jre/bin/java"
    else
        JAVACMD="$JAVA_HOME/bin/java"
    fi
    if [ ! -x "$JAVACMD" ] ; then
        die "ERROR: JAVA_HOME is set to an invalid directory: $JAVA_HOME

Please set the JAVA_HOME variable in your environment to match the location of your Java installation."
    fi
else
    JAVACMD="java"
fi

# Determine the location of the Gradle distribution.
if [ -n "$GRADLE_HOME" ] ; then
    GRADLE_HOME="$GRADLE_HOME"
elif [ -n "$HOME" ] ; then
    GRADLE_HOME="$HOME/.gradle/wrapper/dists"
elif [ -n "$USERPROFILE" ] ; then
    GRADLE_HOME="$USERPROFILE/.gradle/wrapper/dists"
else
    GRADLE_HOME="."
fi

# Find the corresponding JAR file in the distribution.
if [ -n "$GRADLE_VERSION" ] ; then
    GRADLE_JAR="$GRADLE_HOME/gradle-$GRADLE_VERSION/lib/gradle-launcher-$GRADLE_VERSION.jar"
else
    GRADLE_JAR=$(find "$GRADLE_HOME" -name 'gradle-launcher-*.jar' | head -n 1)
fi

# Determine the location of the Gradle wrapper JAR.
APP_NAME="Gradle"
APP_BASE_NAME="gradle"

# Add default JVM options here. You can also use $JAVA_OPTS and $GRADLE_OPTS to pass JVM options to this script.
DEFAULT_JVM_OPTS=""

# Use JNI library path if it is set.
if [ -n "$LD_LIBRARY_PATH" ] ; then
    JAVA_OPTS="$JAVA_OPTS -Djava.library.path=$LD_LIBRARY_PATH"
fi

# Determine the script directory.
PRG="$0"
while [ -h "$PRG" ]; do
    ls=$(ls -ld "$PRG")
    link=$(expr "$ls" : '.*-> \(.*\)$')
    if expr "$link" : '/.*' > /dev/null; then
        PRG="$link"
    else
        PRG=$(dirname "$PRG")/"$link"
    fi
done
APP_HOME=$(dirname "$PRG")

# OS specific support (must be 'true' or 'false').
cygwin=false
darwin=false
mingw=false
case "`uname`" in
  CYGWIN*) cygwin=true ;;
  Darwin*) darwin=true ;;
  MINGW*) mingw=true ;;
esac

# Execute Gradle.
exec "$JAVACMD" \
  $DEFAULT_JVM_OPTS $JAVA_OPTS $GRADLE_OPTS \
  -cp "$APP_HOME/gradle/wrapper/gradle-wrapper.jar" \
  org.gradle.wrapper.GradleWrapperMain "$@"

#!/bin/sh

# Check if running as root
if [ "$EUID" -ne 0 ]
then 
    echo "Please run as root"
    exit 1
fi

# Variables
VERSION="7.0"

# Create required directories if they don't exist
mkdir -p /tmp /opt/gradle

# Install Dependencies
dnf -y install curl which unzip java-11-openjdk

# Install Gradle
curl -L "https://downloads.gradle-dn.com/distributions/gradle-${VERSION}-bin.zip" -o /tmp/gradle.zip

# Install Gradle
unzip /tmp/gradle.zip -d /opt/gradle
mv /opt/gradle/gradle-$VERSION/* /opt/gradle
rm -rf /opt/gradle/gradle-$VERSION
chmod +x /opt/gradle/bin/gradle
ln -s /opt/gradle/bin/gradle /usr/bin/gradle

# Installation Check
GRADLE_PATH=$(which gradle)
if [ -z "${GRADLE_PATH}" ]
then
    echo "Gradle was not installed correctly."
    exit 207
fi

# Run Command
gradle --version

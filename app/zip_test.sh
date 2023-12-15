#!/usr/bin/bash
#
# Zip test script for Tapis V3
# Copied from smoke_test.sh
# Check:
#  - two incoming arguments: arg1 arg2
#  - various environment variables
#  - input files have been staged
#
# NOTE: To run manually please see instructions in README
#
PrgName=$(basename "$0")

USAGE="Usage: $PrgName arg1 arg2 [<seconds_to_sleep>]"

ARG1=$1
ARG2=$2

export IN_DIR="./"

# Function to exit with specified exit code
function error_exit () {
  if [ -z "$1" ]; then
    exit_code=1
  else
    exit_code=$1
  fi
  echo "$USAGE"
  echo "FAILED"
  echo "$exit_code" > "./tapisjob.exitcode"
  exit $exit_code
}

echo "Running script: $PrgName with arguments: $*"
echo "id=$(id)"
echo "PWD=$(pwd)"
echo "HOME=$HOME"
echo "========================================="
echo "ls -l $IN_DIR"
ls -l $IN_DIR
echo "========================================="

#
# Check number of arguments
#
if [ $# -lt 2 ]; then
  echo "Must have at least two arguments."
  error_error_exit 1
fi
if [ $# -gt 3 ]; then
  echo "Must have at most three arguments"
  error_error_exit 1
fi

echo "Found expected number of app args."

#
# Check argument values
#
if [ "$ARG1" != "arg1" ]; then
  echo "First argument was not arg1"
  error_error_exit 1
fi
echo "Found expected arg1 value."

if [ "$ARG2" != "arg2" ]; then
  echo "Second argument was not arg2"
  error_error_exit 1
fi
echo "Found expected arg2 value."

#
# Check that all environment variables expected are set
# NOTE: Bash can distinguish between not set (a.k.a. null) and set but no value (a.k.a. empty string)
#       The expression ${env_variable-set_because_null} expands to "set_because_null" only if
#       env_variable was not set.
# NOTE: The use of {!ev_name} allows us to reference the loop variable as an environment variable name.
#
# NOTE: When this is run via docker using --env-file it appears that variables without a value are unset, so
#       we can only check for variables with a value. Possibly because they are not exported.
# NOTE: This means we are unable to support env variables that are set but empty when running a Tapis job.
# Variables that should be set but empty.
# EV_CHECK_SET="APP_ALL_DEFAULTS APP_BY_DEFAULT_DEFAULT APP_ONLY_FIXED_DEFAULT"
# EV_CHECK_SET="$EV_CHECK_SET SYS_ALL_DEFAULTS SYS_BY_DEFAULT_DEFAULT SYS_ONLY_FIXED_DEFAULT"

EV_CHECK_SET="APP_BY_DEFAULT_SET APP_ONLY_FIXED_SET APP_REQUIRED_DEFAULT APP_REQUIRED_SET"
EV_CHECK_SET="$EV_CHECK_SET SYS_APP_FIXED SYS_BY_DEFAULT_SET SYS_ONLY_FIXED_SET SYS_REQUIRED_DEFAULT SYS_REQUIRED_SET"
EV_CHECK_SET="$EV_CHECK_SET _tapisExecSystemInputDir ENV_1"
for ev in $EV_CHECK_SET
do
  ev_name=$ev
  ev_resolved=${!ev_name-x_set_because_null}
  if [ "${ev_resolved}" == "x_set_because_null" ]; then
    echo "Environment variable not set. Environment variable: $ev_name"
    error_error_exit 1
  fi
  echo "Found environment variable: $ev with value: $ev_resolved"
done

#
# Check specific values for environment variables
#
# ---------------------------------------------
if [ "$ENV_1" != "env_1_value" ]; then
  echo "Environment variable had incorrect value. Expected: env_1_value Found: $ENV_1"
  error_error_exit 1
fi
echo "Found expected ENV_1 value: $ENV_1"
# ---------------------------------------------
ev_name="APP_BY_DEFAULT_SET"
ev_value="app_by_default_set"
ev_resolved=${!ev_name}
if [ "${ev_resolved}" != "${ev_value}" ]; then
  echo "Found incorrect value for environment value. Name: $ev_name Expected: ${ev_value} Found: ${ev_resolved}"
  error_error_exit 1
fi
echo "Found expected value for environment variable. Name: $ev_name Value: ${ev_resolved}"
# ---------------------------------------------
ev_name="APP_ONLY_FIXED_SET"
ev_value="app_only_fixed_set"
ev_resolved=${!ev_name}
if [ "${ev_resolved}" != "${ev_value}" ]; then
  echo "Found incorrect value for environment value. Name: $ev_name Expected: ${ev_value} Found: ${ev_resolved}"
  error_error_exit 1
fi
echo "Found expected value for environment variable. Name: $ev_name Value: ${ev_resolved}"
# ---------------------------------------------
ev_name="APP_REQUIRED_DEFAULT"
ev_value="app_required_default_set_in_job"
ev_resolved=${!ev_name}
if [ "${ev_resolved}" != "${ev_value}" ]; then
  echo "Found incorrect value for environment value. Name: $ev_name Expected: ${ev_value} Found: ${ev_resolved}"
  error_exit 1
fi
echo "Found expected value for environment variable. Name: $ev_name Value: ${ev_resolved}"
# ---------------------------------------------
ev_name="APP_REQUIRED_SET"
ev_value="app_required_set_set_in_job"
ev_resolved=${!ev_name}
if [ "${ev_resolved}" != "${ev_value}" ]; then
  echo "Found incorrect value for environment value. Name: $ev_name Expected: ${ev_value} Found: ${ev_resolved}"
  error_exit 1
fi
echo "Found expected value for environment variable. Name: $ev_name Value: ${ev_resolved}"
# ---------------------------------------------
ev_name="SYS_APP_FIXED"
ev_value="sys_app_fixed"
ev_resolved=${!ev_name}
if [ "${ev_resolved}" != "${ev_value}" ]; then
  echo "Found incorrect value for environment value. Name: $ev_name Expected: ${ev_value} Found: ${ev_resolved}"
  error_exit 1
fi
echo "Found expected value for environment variable. Name: $ev_name Value: ${ev_resolved}"
# ---------------------------------------------
ev_name="SYS_BY_DEFAULT_SET"
ev_value="sys_by_default_set"
ev_resolved=${!ev_name}
if [ "${ev_resolved}" != "${ev_value}" ]; then
  echo "Found incorrect value for environment value. Name: $ev_name Expected: ${ev_value} Found: ${ev_resolved}"
  error_exit 1
fi
echo "Found expected value for environment variable. Name: $ev_name Value: ${ev_resolved}"
# ---------------------------------------------
ev_name="SYS_ONLY_FIXED_SET"
ev_value="sys_only_fixed_set"
ev_resolved=${!ev_name}
if [ "${ev_resolved}" != "${ev_value}" ]; then
  echo "Found incorrect value for environment value. Name: $ev_name Expected: ${ev_value} Found: ${ev_resolved}"
  error_exit 1
fi
echo "Found expected value for environment variable. Name: $ev_name Value: ${ev_resolved}"
# ---------------------------------------------
ev_name="SYS_REQUIRED_DEFAULT"
ev_value="sys_required_default_set_in_app"
ev_resolved=${!ev_name}
if [ "${ev_resolved}" != "${ev_value}" ]; then
  echo "Found incorrect value for environment value. Name: $ev_name Expected: ${ev_value} Found: ${ev_resolved}"
  error_exit 1
fi
echo "Found expected value for environment variable. Name: $ev_name Value: ${ev_resolved}"
# ---------------------------------------------
ev_name="SYS_REQUIRED_SET"
ev_value="app_required_set_set_in_app"
ev_resolved=${!ev_name}
if [ "${ev_resolved}" != "${ev_value}" ]; then
  echo "Found incorrect value for environment value. Name: $ev_name Expected: ${ev_value} Found: ${ev_resolved}"
  error_exit 1
fi
echo "Found expected value for environment variable. Name: $ev_name Value: ${ev_resolved}"

#
# Check input files
#
flist="s3_ceph_file.txt s3_rootdir_test/s3_ceph_file2.txt s3_aws/test1.txt"

for f in $flist
do
  file_path="$IN_DIR/$f"
  if [ ! -f "$file_path" ]; then
    echo "No file found: $file_path"
    error_exit 1
  fi
  echo "Found file: $file_path"
done

echo "================================"

# Sleep if requested
if [ -n "$3" ]; then
  echo "============Sleeping for $3 seconds ======================="
  date
  sleep $3
  date
  echo "============Done sleeping for $3 seconds ======================="
fi

echo "Success"

exit 0

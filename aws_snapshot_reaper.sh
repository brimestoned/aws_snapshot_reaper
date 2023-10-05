#!/bin/bash

# Get date from 2 days ago on macOS
date_minus_two=$(date -v-2d +%Y-%m-%d)

# Command to describe snapshots
describe_cmd="aws ec2 describe-snapshots --owner self --output json --region=us-west-2"

# Command to filter snapshots based on date
filter_cmd="jq -r '.Snapshots[] | select(.StartTime < \"$date_minus_two\") | .SnapshotId'"

# Get list of snapshots
snapshots=$($describe_cmd | eval $filter_cmd)

# Delete snapshots
delete_cmd="aws ec2 delete-snapshot --region=us-west-2 --snapshot-id"

# Counter for the number of deleted snapshots
deleted_count=0

for snap_id in $snapshots
do
    echo "Deleting: $snap_id..." 
    #eval "$delete_cmd $snap_id"

    # Increment the counter
    ((deleted_count++))
done

# Report the total number of deleted snapshots
echo "Total snapshots deleted: $deleted_count"

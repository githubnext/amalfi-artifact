import csv
import os

from datetime import datetime


def parse_date(timestamp):
    return datetime.strptime(timestamp, "%Y-%m-%dT%H:%M:%S.%fZ")


def version_date(versions, feature_dir):
    package_dir = os.path.dirname(feature_dir)
    version_dir = os.path.basename(feature_dir)

    if package_dir not in versions:
        version_dates = {}
        with open(os.path.join(package_dir, "versions.csv"), "r") as versions_file:
            for row in csv.reader(versions_file):
                version, timestamp = row
                date = parse_date(timestamp)
                version_dates[version] = date
        versions[package_dir] = version_dates

    return versions[package_dir][version_dir] if version_dir in versions[package_dir] else None

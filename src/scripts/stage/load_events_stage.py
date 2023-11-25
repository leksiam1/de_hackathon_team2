import findspark
findspark.init()
findspark.find()

import pyspark
from pyspark.sql import SparkSession

spark = SparkSession.builder \
                    .master("yarn") \
                    .appName("Learning DataFrames") \
                    .getOrCreate()

events = spark.read.parquet("hdfs:///user/master/data/events-2022-Sep-30-2134.parquet")

    events.write \
        .mode('append') \
        .format('jdbc') \
        .option('url', 'jdbc:postgresql://158.160.117.11:5432/de_student') \
        .option('driver', 'org.postgresql.Driver') \
        .option('dbtable', 'stage.events') \
        .option('user', 'de_student') \
        .option('password', 'de_student') \
        .save()


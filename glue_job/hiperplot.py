import sys

from dataclasses import dataclass

from awsglue.dynamicframe import DynamicFrame
from awsglue.utils import getResolvedOptions
from awsglue.context import GlueContext
from awsglue.job import Job

from pyspark.sql.types import StructType
from pyspark.sql import functions as F
from pyspark.conf import SparkConf
from pyspark.context import SparkContext



def get_raw_data(spark, s3_path):
    df = spark.read.format("parquet").load(s3_path)
    return df


def transform_data(df):
    df = df.select("timestamp_received", "value", "aircraft_sn", "day", "field")
    df = df_5.withColumn("day", F.to_timestamp("day")).withColumn(
        "value", F.col("value").cast("float")
    )

    return df

def load_data(df):
    df.writeTo("glue.hyperplot.table_iceberg_2").append()

def main():
    conf = SparkConf()
    conf.set(
        "spark.sql.catalog.glue.warehouse", "s3://flojoy-ts-app/hyperplot/iceberg-data"
    )
    conf.set("spark.sql.catalog.glue", "org.apache.iceberg.spark.SparkCatalog")
    conf.set(
        "spark.sql.catalog.glue.catalog-impl", "org.apache.iceberg.aws.glue.GlueCatalog"
    )
    conf.set(
        "spark.sql.catalog.glue.warehouse", "s3://flojoy-ts-app/hyperplot/iceberg-data"
    )
    conf.set("spark.sql.catalog.glue.io-impl", "org.apache.iceberg.aws.s3.S3FileIO")
    conf.set(
        "spark.sql.extensions",
        "org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions",
    )
    conf.set("spark.sql.sources.partitionOverwriteMode", "dynamic")
    conf.set("spark.sql.iceberg.handle-timestamp-without-timezone", "true")
    sc = SparkContext(conf=conf)
    glueContext = GlueContext(sc)
    spark = glueContext.spark_session

    s3_path = "s3://flojoy-ts-app/hyperplot/data/"
    df = get_raw_data(spark, s3_path)

    transformed_df = transform_data(df)
    load_data(transformed_df)

if __name__ == "__main__":
    main()